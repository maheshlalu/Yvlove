//
//  ViewController.swift
//  Nowfloatwishlist
//
//  Created by apple on 13/09/16.
//  Copyright © 2016 apple. All rights reserved.
//

import UIKit

class NowfloatWishlistViewController: CXViewController{
    
    @IBOutlet var wishlistcollectionView: UICollectionView!
    var products: NSArray!
    var screenwidth = [String]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.wishlistcollectionView.backgroundColor = UIColor.lightGrayColor()
        let nib = UINib(nibName: "WishlistCollectionViewCell", bundle: nil)
        self.wishlistcollectionView.registerNib(nib, forCellWithReuseIdentifier: "WishlistCollectionViewCell")
        
        getTheProducts()
        
    }
    func getTheProducts(){
        let fetchRequest : NSFetchRequest = NSFetchRequest(entityName: "CX_Products")
        self.products  = CX_Products.MR_executeFetchRequest(fetchRequest)
        self.wishlistcollectionView.reloadData()
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        
        return  self.products.count
        
        
    }
    
   
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        
        
        
        let cell = wishlistcollectionView.dequeueReusableCellWithReuseIdentifier("WishlistCollectionViewCell", forIndexPath: indexPath)as! WishlistCollectionViewCell
        cell.imagetitleLabel.text = self.products[indexPath.item] as? String
        let products:CX_Products = (self.products[indexPath.item]as?
            CX_Products)!
        
        cell.imagetitleLabel.text = products.name

        
        cell.wishlistimageview.sd_setImageWithURL(NSURL(string: products.imageUrl!))
        
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

