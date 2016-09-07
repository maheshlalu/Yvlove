//
//  PhotosViewController.swift
//  NowFloats
//
//  Created by Mahesh Y on 8/18/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit

class PhotosViewController: CXViewController {

    @IBOutlet weak var photosCollectionView: UICollectionView!
    var gallaryItems:NSArray!
    var screenWidth:CGFloat! = nil
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
    
}

extension PhotosViewController {
    
    
    func getTheGalleryItems(){
        self.gallaryItems = CXDataProvider.sharedInstance.getTheTableDataFromDataBase("CX_Gallery", predicate: NSPredicate(format:"isBannerImage=%@","false" ), ispredicate: true, orederByKey: "").dataArray
        self.photosCollectionView.reloadData()
    }
    
    
}