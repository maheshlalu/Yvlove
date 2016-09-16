//
//  ViewController.swift
//  Nowfloatwishlist
//
//  Created by apple on 13/09/16.
//  Copyright © 2016 apple. All rights reserved.
//

import UIKit

class NowfloatWishlistViewController: CXViewController,UICollectionViewDataSource,UICollectionViewDelegate{
    
    @IBOutlet var wishlistcollectionView: UICollectionView!
    var products: NSMutableArray!
    var screenwidth = [String]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.wishlistcollectionView.backgroundColor = UIColor.lightGrayColor()
        let nib = UINib(nibName: "WishlistCollectionViewCell", bundle: nil)
        self.wishlistcollectionView.registerNib(nib, forCellWithReuseIdentifier: "WishlistCollectionViewCell")
        
        getTheProducts()
        
    }
    func getTheProducts(){
        let cartlist : NSArray =  CX_Cart.MR_findAllWithPredicate(NSPredicate(format: "addToWishList = %@", "1"))
        self.products  = NSMutableArray(array: cartlist)
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
        let products:CX_Cart = (self.products[indexPath.item]as?
            CX_Cart)!
        
        cell.imagetitleLabel.text = products.name
        cell.wishlistimageview.sd_setImageWithURL(NSURL(string: products.imageUrl!))
        cell.wishlistaddtocartbutton.tag = indexPath.row+1
        cell.wishlistdeletebutton.tag = indexPath.row+1
        cell.wishlistaddtocartbutton.addTarget(self, action: #selector(NowfloatWishlistViewController.addTocartBtnAction(_:)), forControlEvents: .TouchUpInside)
        cell.wishlistdeletebutton.addTarget(self, action: #selector(NowfloatWishlistViewController.deleteWishListButtonAction(_:)), forControlEvents: .TouchUpInside)
        
        
        let rupee = "\u{20B9}"
        let price:String = CXDataProvider.sharedInstance.getJobID("MRP", inputDic: products.json!)
        let discount:String = CXDataProvider.sharedInstance.getJobID("DiscountAmount", inputDic: products.json!)
        
        if discount == "0"{
            cell.mrpLbl.hidden = true
            cell.discountBdgeLb.hidden = true
            cell.wishlistpricelabel.text = "\(rupee) \(price)"
            
        }else{
            cell.mrpLbl.hidden = false
            cell.discountBdgeLb.hidden = false
            
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "\(rupee) \(price)")
            attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length))
            cell.mrpLbl.attributedText = attributeString
            
            cell.discountBdgeLb.text = "\(discount)"
            let finalPriceNum:Int = Int(price)!-Int(discount)!
            cell.wishlistpricelabel.text = "\(rupee) \(String(finalPriceNum))"
        }

        return cell
    }

    
    
    func addTocartBtnAction(button : UIButton!){

        let proListData : CX_Cart = self.products[button.tag-1] as! CX_Cart
        self.products.removeObjectAtIndex(button.tag-1)
        self.wishlistcollectionView.reloadData()
        CXDataProvider.sharedInstance.itemAddToWishListOrCarts(proListData.json!, itemID: proListData.pID!, isAddToWishList: false, isAddToCartList: true, isDeleteFromWishList: true, isDeleteFromCartList: true, completionHandler: { (isAdded) in
            
        })
        
        print("delete the cell");
        
    }
    
    func deleteWishListButtonAction(button : UIButton!){
        //Add to wishList
        
        // let updateDic : NSDictionary = self.p[button.tag-1] as! NSDictionary
        //   (indexPath.section)
        //self.collectionview.deleteItemsAtIndexPaths([indexPath])
        let proListData : CX_Cart = self.products[button.tag-1] as! CX_Cart
        self.products.removeObjectAtIndex(button.tag-1)
        self.wishlistcollectionView.reloadData()

       // self.wishlistcollectionView.deleteItemsAtIndexPaths([NSIndexPath(forItem: button.tag-1, inSection: 0)])
       // self.wishlistcollectionView.reloadItemsAtIndexPaths([NSIndexPath(forItem: button.tag-1, inSection: 0)])
       // print(proListData.pID)
        CXDataProvider.sharedInstance.itemAddToWishListOrCarts(proListData.json!, itemID: proListData.pID!, isAddToWishList: false, isAddToCartList: false, isDeleteFromWishList: true, isDeleteFromCartList: true, completionHandler: { (isAdded) in
            
        })
        
        print("delete the cell");
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

