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
    var screenWidth:CGFloat! = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.navigationBarHidden = true
        let nib = UINib(nibName: "PhotosCollectionViewCell", bundle: nil)
        self.photosCollectionView.registerNib(nib, forCellWithReuseIdentifier: "PhotosCollectionViewCell")

        
        
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotosCollectionViewCell", forIndexPath: indexPath)as! PhotosCollectionViewCell

        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        screenWidth =  UIScreen.mainScreen().bounds.size.width
        return CGSize(width: screenWidth/2-11, height: 200);
    }
    
}




