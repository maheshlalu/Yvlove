//
//  PagerCustomView.h
//  KIImagePager
//
//  Created by apple on 01/09/16.
//  Copyright © 2016 Marcus Kida. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PagerCustomView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *productImage;
@property (weak, nonatomic) IBOutlet UILabel *productNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *productSubLbl;
@property (weak, nonatomic) IBOutlet UIButton *orederNowBtn;

@property (weak, nonatomic) IBOutlet UIImageView *pageImageView;
@end
