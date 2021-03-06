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

class PhotosViewController: CXViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var photosCollectionView: UICollectionView!
    var images = [SKPhoto]()
    var gallaryItems:NSArray!
    var screenWidth:CGFloat! = nil
    
    override func viewDidLoad() {
        CXMixpanel.sharedInstance.mixelGalleryTrack()
        super.viewDidLoad()
        let nib = UINib(nibName: "PhotosCollectionViewCell", bundle: nil)
        self.photosCollectionView.register(nib, forCellWithReuseIdentifier: "PhotosCollectionViewCell")
        self.getTheGalleryItems()
        self.view.backgroundColor = CXAppConfig.sharedInstance.getAppBGColor()
        self.photosCollectionView.backgroundColor = UIColor.clear
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return gallaryItems.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotosCollectionViewCell", for: indexPath as IndexPath)as! PhotosCollectionViewCell
        cell.layer.cornerRadius = 10
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius: cell.layer.cornerRadius).cgPath
        cell.layer.masksToBounds = true
        let gallaeryData : CX_Gallery =  (self.gallaryItems[indexPath.item] as? CX_Gallery)!
        
        if let urlStr = gallaeryData.gImageUrl {
            cell.photosImage.sd_setImage(with: NSURL(string: urlStr) as URL!)

        }
        cell.photosImage.contentMode = .scaleAspectFill
        return cell
    }
    
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //screenWidth =  UIScreen.main.bounds.size.width
         //return CGSize(width: self.view.frame.size.width/2-9, height: 150)
        return CGSize(width: self.view.frame.size.width/2-8, height: 222)
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(indexPath.row)
        present(browser, animated: true, completion: {})
    }
}

extension PhotosViewController {
    
    func getTheGalleryItems(){
        
        
        let fetchRequest = CX_Gallery.mr_requestAllSorted(by: "gID", ascending: true)
           // fetchRequest?.predicate = NSPredicate(format:"isBannerImage=%@","true" )
        
       self.gallaryItems = CX_Gallery.mr_executeFetchRequest(fetchRequest) as NSArray
        
       // self.gallaryItems = CXDataProvider.sharedInstance.getTheTableDataFromDataBase("CX_Gallery", predicate: NSPredicate(format:"isBannerImage=%@","true" ), ispredicate: false, orederByKey: "").dataArray
        self.photosCollectionView.reloadData()
        for  gallaeryData  in self.gallaryItems {
            let imageData : CX_Gallery = (gallaeryData as? CX_Gallery)!
           if let imageUrl = imageData.gImageUrl {
                let photo = SKPhoto.photoWithImageURL(imageUrl)
                photo.shouldCachePhotoURLImage = false // you can use image cache by true(NSCache)
                images.append(photo)
            }
          
        }
    }
}
