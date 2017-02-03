//
//  KIImagePager.m
//  KIImagePager
//
//  Created by Marcus Kida on 07.04.13.
//  Copyright (c) 2013 Marcus Kida. All rights reserved.
//

#define kPageControlHeight  30
#define kOverlayWidth       50
#define kOverlayHeight      15
#import <SDWebImage/SDWebImageCompat.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/SDWebImageManager.h>

#import <SDWebImage/NSData+ImageContentType.h>
#import <SDWebImage/SDImageCache.h>

#import <SDWebImage/SDWebImageDecoder.h>

#import <SDWebImage/SDWebImageDownloader.h>

#import <SDWebImage/SDWebImageDownloaderOperation.h>


#import <SDWebImage/SDWebImageOperation.h>

#import <SDWebImage/SDWebImagePrefetcher.h>

#import <SDWebImage/UIButton+WebCache.h>

#import <SDWebImage/UIImage+GIF.h>

#import <SDWebImage/UIImage+MultiFormat.h>


#import <SDWebImage/UIImageView+HighlightedWebCache.h>


#import <SDWebImage/UIView+WebCacheOperation.h>
#import "KIImagePager.h"

@interface KIImagePagerDefaultImageSource : NSObject <KIImagePagerImageSource>
@end

@interface KIImagePager () <UIScrollViewDelegate>
{
    __weak id <KIImagePagerDataSource> _dataSource;
    __weak id <KIImagePagerDelegate> _delegate;

    UIPageControl *_pageControl;
    UILabel *_countLabel;
    UILabel *_captionLabel;
    UIView *_imageCounterBackground;
    NSTimer *_slideshowTimer;
    NSUInteger _slideshowTimeInterval;
    NSMutableDictionary *_activityIndicators;

    BOOL _indicatorDisabled;
	BOOL _bounces;
}
@end

@implementation KIImagePager

@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;
@synthesize contentMode = _contentMode;
@synthesize pageControl = _pageControl;
@synthesize indicatorDisabled = _indicatorDisabled;

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
		_bounces = YES;
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
		_bounces = YES;
        // Initialization code
    }
    return self;
}

- (void) awakeFromNib
{
    [super awakeFromNib];
}

- (void) layoutSubviews
{
	for (UIView *view in self.subviews) {
		[view removeFromSuperview];
	}
    [self initialize];
}

#pragma mark - General
- (void) initialize
{
    self.slideshowShouldCallScrollToDelegate = YES;
    self.captionBackgroundColor = [UIColor whiteColor];
    self.captionTextColor = [UIColor blackColor];
    self.captionFont = [UIFont fontWithName:@"Helvetica-Light" size:12.0f];
    self.hidePageControlForSinglePages = YES;

    [self initializeScrollView];
    [self initializePageControl];
    if(!_imageCounterDisabled) {
        //[self initalizeImageCounter];
    }
    //[self initializeCaption];

    if(!self.imageSource)
    {
        self.imageSource = [[self class] defaultDataSource];
    }

    [self loadData];
}


+ (id<KIImagePagerImageSource>)defaultDataSource {
    static KIImagePagerDefaultImageSource *_defaultDataSource = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultDataSource = [KIImagePagerDefaultImageSource new];
    });

    return _defaultDataSource;
}


- (UIColor *) randomColor
{
    return [UIColor colorWithHue:(arc4random() % 256 / 256.0)
                      saturation:(arc4random() % 128 / 256.0) + 0.5
                      brightness:(arc4random() % 128 / 256.0) + 0.5
                           alpha:1];
}

- (void) initalizeImageCounter
{
    _imageCounterBackground = [[UIView alloc] initWithFrame:CGRectMake(_scrollView.frame.size.width-(kOverlayWidth-4),
                                                                       _scrollView.frame.size.height-kOverlayHeight,
                                                                       kOverlayWidth,
                                                                       kOverlayHeight)];
    _imageCounterBackground.backgroundColor = [UIColor whiteColor];
    _imageCounterBackground.alpha = 0.7f;
    _imageCounterBackground.layer.cornerRadius = 5.0f;

    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    [icon setImage:[UIImage imageNamed:@"KICamera"]];
    icon.center = CGPointMake(_imageCounterBackground.frame.size.width-18, _imageCounterBackground.frame.size.height/2);
    [_imageCounterBackground addSubview:icon];

    _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 48, 24)];
    [_countLabel setTextAlignment:NSTextAlignmentCenter];
    [_countLabel setBackgroundColor:[UIColor clearColor]];
    [_countLabel setTextColor:[UIColor blackColor]];
    [_countLabel setFont:[UIFont systemFontOfSize:11.0f]];
    _countLabel.center = CGPointMake(15, _imageCounterBackground.frame.size.height/2);
    [_imageCounterBackground addSubview:_countLabel];

    if(!_imageCounterDisabled) [self addSubview:_imageCounterBackground];
}

- (void) initializeCaption
{
    _captionLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, _scrollView.frame.size.width - 10, 20)];
    [_captionLabel setBackgroundColor:self.captionBackgroundColor];
    [_captionLabel setTextColor:self.captionTextColor];
    [_captionLabel setFont:self.captionFont];

    _captionLabel.alpha = 0.7f;
    _captionLabel.layer.cornerRadius = 5.0f;

    [self addSubview:_captionLabel];
}

- (void) reloadData
{
    for (UIView *view in _scrollView.subviews)
        [view removeFromSuperview];
 
    [self loadData];
    [self checkWetherToToggleSlideshowTimer];
}

#pragma mark - ScrollView Initialization
- (void) initializeScrollView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
	_scrollView.bounces = _bounces;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.autoresizingMask = self.autoresizingMask;
    [self addSubview:_scrollView];
}

- (void) loadData
{
    NSArray *aImageUrls = (NSArray *)[_dataSource arrayWithImages:self];
    _activityIndicators = [NSMutableDictionary new];

    //[self updateCaptionLabelForImageAtIndex:0];

    if([aImageUrls count] > 0) {
        [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width * [aImageUrls count],
                                               _scrollView.frame.size.height)];

        for (int i = 0; i < [aImageUrls count]; i++) {
            //CGRect imageFrame = CGRectMake(_scrollView.frame.size.width * i, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
           
            
            self.pagerView =  [[[NSBundle mainBundle] loadNibNamed:@"PagerCustomView" owner:self options:nil] objectAtIndex:0];
            ProductModelClass *data = [_dataSource populateTheProductData:i inPager:self];

            self.pagerView.productImage.hidden = YES;
            self.pagerView.productNameLbl.hidden = YES;
            self.pagerView.productSubLbl.hidden = YES;
            self.pagerView.orederNowBtn.hidden = YES;
            [self.pagerView.pageImageView sd_setImageWithURL:[NSURL URLWithString:data.productimage] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
            }];
           
            //CGRect imageFrame = CGRectMake(_scrollView.frame.size.width * i +50, 20, 100, 100);
            self.pagerView.frame =  CGRectMake(_scrollView.frame.size.width * i , 0, _scrollView.frame.size.width, _scrollView.frame.size.height-50);
            
            
            // Add GestureRecognizer to ImageView
            UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                                  initWithTarget:self
                                                                  action:@selector(imageTapped:)];
            [singleTapGestureRecognizer setNumberOfTapsRequired:1];
            [self.pagerView addGestureRecognizer:singleTapGestureRecognizer];
            [self.pagerView setUserInteractionEnabled:YES];

            [_scrollView addSubview:self.pagerView];
        }
        [self updateCaptionLabelForImageAtIndex:0];
        [_countLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)[[_dataSource arrayWithImages:self] count]]];
        _pageControl.numberOfPages = [(NSArray *)[_dataSource arrayWithImages:self] count];
    } else {
        UIImageView *blankImage = [[UIImageView alloc] initWithFrame:_scrollView.frame];
        if ([_dataSource respondsToSelector:@selector(placeHolderImageForImagePager:)]) {
            [blankImage setImage:[_dataSource placeHolderImageForImagePager:self]];
        }
        if([_dataSource respondsToSelector:@selector(contentModeForPlaceHolder:)]) {
            [blankImage setContentMode:[_dataSource contentModeForPlaceHolder:self]];
        }
        [_scrollView addSubview:blankImage];
    }
    [self updatePageControl];
}

- (void) imageTapped:(UITapGestureRecognizer *)sender
{
    if([_delegate respondsToSelector:@selector(imagePager:didSelectImageAtIndex:)]) {
        [_delegate imagePager:self didSelectImageAtIndex:[(UIGestureRecognizer *)sender view].tag];
    }
}

- (void) setIndicatorDisabled:(BOOL)indicatorDisabled
{
    if(indicatorDisabled) {
        [_pageControl removeFromSuperview];
    } else {
        [self addSubview:_pageControl];
    }

    _indicatorDisabled = indicatorDisabled;
}

- (BOOL)bounces {

	return _bounces;
}

- (void)setBounces:(BOOL)bounces {
	_bounces = bounces;
	_scrollView.bounces = _bounces;
}

- (void)setImageCounterDisabled:(BOOL)imageCounterDisabled
{
    if (imageCounterDisabled) {
        [_imageCounterBackground removeFromSuperview];
    } else {
        [self addSubview:_imageCounterBackground];
    }

    _imageCounterDisabled = imageCounterDisabled;
}

#pragma mark - PageControl Initialization
- (void) initializePageControl
{
    CGRect pageControlFrame = CGRectMake(0, 0, _scrollView.frame.size.width, kPageControlHeight);
    _pageControl = [[UIPageControl alloc] initWithFrame:pageControlFrame];
    _pageControl.center = CGPointMake(_scrollView.frame.size.width / 2, _scrollView.frame.size.height - 12.0);
    _pageControl.userInteractionEnabled = NO;
    if(!_indicatorDisabled) [self addSubview:_pageControl];
}

#pragma mark - ScrollView Delegate;
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if([_slideshowTimer isValid]) {
        [_slideshowTimer invalidate];
    }
    [self checkWetherToToggleSlideshowTimer];
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    long currentPage = lround((float)scrollView.contentOffset.x / scrollView.frame.size.width);
    _pageControl.currentPage = currentPage;

    [self updateCaptionLabelForImageAtIndex:currentPage];
    [self fireDidScrollToIndexDelegateForPage:currentPage];
}

#pragma mark - Delegate Helper
- (void) updateCaptionLabelForImageAtIndex:(NSUInteger)index
{
    //- (void)populateTheProductDataInPager:(NSUInteger)index  inPager:(KIImagePager*)pager;

    if ([_dataSource respondsToSelector:@selector(captionForImageAtIndex:inPager:)]) {
        if ([[_dataSource captionForImageAtIndex:index inPager:self] length] > 0) {
            [_captionLabel setHidden:NO];
            [_captionLabel setText:[NSString stringWithFormat:@" %@", [_dataSource captionForImageAtIndex:index inPager:self]]];
            return;
        }
    }
    if ([_dataSource respondsToSelector:@selector(populateTheProductDataInPager:inPager:)]) {
        [_dataSource populateTheProductDataInPager:index inPager:self];
    }
    
    [_captionLabel setHidden:YES];
}

- (void) fireDidScrollToIndexDelegateForPage:(NSUInteger)page
{
    if([_delegate respondsToSelector:@selector(imagePager:didScrollToIndex:)]) {
        [_delegate imagePager:self didScrollToIndex:page];
    }
}

#pragma mark - Slideshow
- (void) slideshowTick:(NSTimer *)timer
{
    NSUInteger nextPage = 0;
    if([_pageControl currentPage] < ([[_dataSource arrayWithImages:self] count] - 1)) {
        nextPage = [_pageControl currentPage] + 1;
    }

    [_scrollView scrollRectToVisible:CGRectMake(self.frame.size.width * nextPage, 0, self.frame.size.width, self.frame.size.width) animated:YES];
    [_pageControl setCurrentPage:nextPage];

    [self updateCaptionLabelForImageAtIndex:nextPage];

    if (self.slideshowShouldCallScrollToDelegate) {
        [self fireDidScrollToIndexDelegateForPage:nextPage];
    }
}

- (void) checkWetherToToggleSlideshowTimer
{
    
    
    if (_slideshowTimeInterval > 0) {
        if ([(NSArray *)[_dataSource arrayWithImages:self] count] > 1) {
            if(_slideshowTimer){
                [_slideshowTimer invalidate];
            }
            _slideshowTimer = [NSTimer scheduledTimerWithTimeInterval:_slideshowTimeInterval target:self selector:@selector(slideshowTick:) userInfo:nil repeats:YES];
        }
    }
}

#pragma mark - Setter / Getter
- (void) setSlideshowTimeInterval:(NSUInteger)slideshowTimeInterval
{
    _slideshowTimeInterval = slideshowTimeInterval;

    if([_slideshowTimer isValid]) {
        [_slideshowTimer invalidate];
    }
    [self checkWetherToToggleSlideshowTimer];
}

- (NSUInteger) slideshowTimeInterval
{
    return _slideshowTimeInterval;
}

- (void) setCaptionBackgroundColor:(UIColor *)captionBackgroundColor
{
    [_captionLabel setBackgroundColor:captionBackgroundColor];
    _captionBackgroundColor = captionBackgroundColor;
}

- (void) setCaptionTextColor:(UIColor *)captionTextColor
{
    [_captionLabel setTextColor:captionTextColor];
    _captionTextColor = captionTextColor;
}

- (void) setCaptionFont:(UIFont *)captionFont
{
    [_captionLabel setFont:captionFont];
    _captionFont = captionFont;
}

- (void) setHidePageControlForSinglePages:(BOOL)hidePageControlForSinglePages
{
  _hidePageControlForSinglePages = hidePageControlForSinglePages;
  [self updatePageControl];
}

- (void)updatePageControl {
  if (self.hidePageControlForSinglePages) {
    if ([(NSArray *)[_dataSource arrayWithImages:self] count] < 2) {
      [_pageControl setHidden:YES];
      return;
    }
  }
  [_pageControl setHidden:NO];
}

- (void) setPageControlCenter:(CGPoint)pageControlCenter
{
    _pageControl.center = pageControlCenter;
}

- (NSUInteger) currentPage
{
    return [_pageControl currentPage];
}

- (void) setCurrentPage:(NSUInteger)currentPage
{
    [self setCurrentPage:currentPage animated:YES];
}

- (void) setCurrentPage:(NSUInteger)currentPage animated:(BOOL)animated
{
    NSAssert((currentPage < [(NSArray *)[_dataSource arrayWithImages:self] count]), @"currentPage must not exceed maximum number of images");

    [_pageControl setCurrentPage:currentPage];
    [_scrollView scrollRectToVisible:CGRectMake(self.frame.size.width * currentPage, 0, self.frame.size.width, self.frame.size.width) animated:animated];
}

@end



#pragma mark  - Image source


@implementation KIImagePagerDefaultImageSource

-(void) imageWithUrl:(NSURL*)url completion:(KIImagePagerImageRequestBlock)completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        dispatch_sync(dispatch_get_main_queue(), ^{
            if(completion) completion([UIImage imageWithData:imageData],nil);
        });
    });
}

@end
