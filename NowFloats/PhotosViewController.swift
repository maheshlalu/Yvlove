//
//  PhotosViewController.swift
//  NowFloats
//
//  Created by Mahesh Y on 8/18/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit
import SKPhotoBrowser
import SDWebImage
class PhotosViewController: CXViewController {
    
    @IBOutlet weak var photosCollectionView: UICollectionView!
    var images = [SKPhoto]()
    var gallaryItems:NSArray!
    var screenWidth:CGFloat! = nil
    let imageNames: NSArray = ["image1.jpeg", "image2.jpeg", "image3.jpeg"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.navigationBarHidden = true
        let nib = UINib(nibName: "PhotosCollectionViewCell", bundle: nil)
        self.photosCollectionView.registerNib(nib, forCellWithReuseIdentifier: "PhotosCollectionViewCell")
        self.getTheGalleryItems()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.gallaryItems.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotosCollectionViewCell", forIndexPath: indexPath)as! PhotosCollectionViewCell
        cell.layer.cornerRadius = 10
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius: cell.layer.cornerRadius).CGPath
        cell.layer.masksToBounds = true
        let gallaeryData : CX_Gallery =  (self.gallaryItems[indexPath.item] as? CX_Gallery)!
        cell.photosImage.sd_setImageWithURL(NSURL(string: gallaeryData.gImageUrl!))
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        screenWidth =  UIScreen.mainScreen().bounds.size.width
        return CGSize(width: screenWidth/2-11, height: 100);
    }
    
    /*let browser = SKPhotoBrowser(photos: images)
     browser.initializePageIndex(0)
     presentViewController(browser, animated: true, completion: {})
     */
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // handle tap events
        
        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(indexPath.row)
        presentViewController(browser, animated: true, completion: {})
        
        print("You selected cell #\(indexPath.item)!")
    }
    
}

extension PhotosViewController {
    
    
    func getTheGalleryItems(){
        self.gallaryItems = CXDataProvider.sharedInstance.getTheTableDataFromDataBase("CX_Gallery", predicate: NSPredicate(format:"isBannerImage=%@","false" ), ispredicate: true, orederByKey: "").dataArray
        self.photosCollectionView.reloadData()
        for  gallaeryData  in self.gallaryItems {
            let imageData : CX_Gallery = (gallaeryData as? CX_Gallery)!
            let photo = SKPhoto.photoWithImageURL(imageData.gImageUrl!)
            photo.shouldCachePhotoURLImage = false // you can use image cache by true(NSCache)
            images.append(photo)
        }
  
    }
    
    
}

//extension PhotosViewController : SwiftPhotoGalleryDataSource,SwiftPhotoGalleryDelegate{
//    
//
//    func numberOfImagesInGallery(gallery: SwiftPhotoGallery) -> Int {
//        return imageNames.count
//    }
//    
//    func imageInGallery(gallery: SwiftPhotoGallery, forIndex: Int) -> UIImage? {
//        
//        
//        return UIImage(named: imageNames[forIndex] as! String)
//    }
//    
//    func galleryDidTapToClose(gallery: SwiftPhotoGallery) {
//        // do something cool like:
//        dismissViewControllerAnimated(true, completion: nil)
//    }
//}