//
//  ProductSearchViewController.swift
//  NowFloats
//
//  Created by Manishi on 9/30/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit

class ProductSearchViewController: CXViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

    var screenWidth: CGFloat! = nil
    var products: NSArray!

    @IBOutlet var updatecollectionview: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "ProductsCollectionViewCell", bundle: nil)
        self.updatecollectionview.registerNib(nib, forCellWithReuseIdentifier: "ProductsCollectionViewCell")
        UISearchBar.appearance().tintColor = CXAppConfig.sharedInstance.getAppTheamColor()
        
        getTheProducts()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.updatecollectionview.reloadData()
    }

    
    func getTheProducts(){
        let fetchRequest : NSFetchRequest = NSFetchRequest(entityName: "CX_Products")
        self.products  = CX_Products.MR_executeFetchRequest(fetchRequest)
        self.updatecollectionview.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.products.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ProductsCollectionViewCell", forIndexPath: indexPath)as! ProductsCollectionViewCell
        
        let products:CX_Products = (self.products[indexPath.item] as? CX_Products)!
        let productJson = products.valueForKey("json") as! NSString
        let dic = CXConstant.sharedInstance.convertStringToDictionary(productJson as String) as NSDictionary
        let shipmentDuration = dic.valueForKey("ShipmentDuration")
        cell.productdescriptionLabel.text = products.name
        if shipmentDuration != nil {
            cell.produstimageview.contentMode = UIViewContentMode.ScaleToFill
        }else{
            cell.produstimageview.contentMode = UIViewContentMode.ScaleAspectFit
        }
        cell.produstimageview.sd_setImageWithURL(NSURL(string: products.imageUrl!))
        
        let rupee = "\u{20B9}"
        let price:String = CXDataProvider.sharedInstance.getJobID("MRP", inputDic: products.json!)
        let discount:String = CXDataProvider.sharedInstance.getJobID("DiscountAmount", inputDic: products.json!)
        
        if discount == "0"{
            cell.productpriceLabel.hidden = true
            cell.productFinalPriceLabel.text = "\(rupee) \(price)"
            cell.productFinalPriceLabel.font = cell.productpriceLabel.font.fontWithSize(14)
            cell.productFinalPriceLabel.textColor = UIColor.darkGrayColor()
        }else{
            cell.productpriceLabel.hidden = false
            cell.productpriceLabel.font = cell.productpriceLabel.font.fontWithSize(11)
            cell.productpriceLabel.textColor = CXAppConfig.sharedInstance.getAppTheamColor()
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "\(rupee) \(price)")
            attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 1, range: NSMakeRange(0, attributeString.length))
            cell.productpriceLabel.attributedText = attributeString
            
            let finalPriceNum:Int = Int(price)!-Int(discount)!
            cell.productFinalPriceLabel.text = "\(rupee) \(String(finalPriceNum))"
        }
        
        cell.cartaddedbutton.tag = indexPath.row+1
        cell.likebutton.tag = indexPath.row+1
        
        
        cell.cartaddedbutton.addTarget(self, action: #selector(ProductsViewController.productAddedToCart(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        cell.likebutton.addTarget(self, action: #selector(ProductsViewController.productAddedToWishList(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.assignCartButtonWishtListProperTy(cell, indexPath: indexPath, productData: products)
        
        
        return cell
    }
    
    
    func assignCartButtonWishtListProperTy(tableViewCell:ProductsCollectionViewCell,indexPath:NSIndexPath,productData:CX_Products){
        
        if CXDataProvider.sharedInstance.isAddToCart(productData.pid!).isAddedToCart{
            tableViewCell.cartaddedbutton.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
            tableViewCell.cartaddedbutton.imageView?.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
            tableViewCell.cartaddedbutton.setTitleColor(UIColor.whiteColor(), forState: .Selected)
            tableViewCell.cartaddedbutton.selected = true
        }else{
            tableViewCell.cartaddedbutton.selected = false
            tableViewCell.cartaddedbutton.backgroundColor = UIColor.whiteColor()
            tableViewCell.cartaddedbutton.imageView?.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
            tableViewCell.cartaddedbutton.setTitleColor(CXAppConfig.sharedInstance.getAppTheamColor(), forState: .Normal)
        }
        
        if CXDataProvider.sharedInstance.isAddToCart(productData.pid!).isAddedToWishList{
            tableViewCell.likebutton.selected = true
            
        }else{
            tableViewCell.likebutton.selected = false
        }
        
        
    }

    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width-20, height: 222)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let products:CX_Products = (self.products[indexPath.item] as? CX_Products)!
        
        let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let productDetails = storyBoard.instantiateViewControllerWithIdentifier("PRODUCT_DETAILS") as! ProductDetailsViewController
        productDetails.productString = products.json
        self.navigationController?.pushViewController(productDetails, animated: true)
        
    }
    
}

//Cart and Wishlist functios

extension ProductSearchViewController {
    
    func productAddedToCart(sender:UIButton){
        
        let proListData : CX_Products = self.products[sender.tag-1] as! CX_Products
        let indexPath = NSIndexPath(forRow: sender.tag-1, inSection: 0)
        
        //CXDataProvider.sharedInstance.itemAddToWishListOrCarts(proListData.json!, itemID: proListData.pid!, isAddToWishList: false, isAddToCartList: true)
        
        if sender.selected {
            //Remove Item From Cart
            CXDataProvider.sharedInstance.itemAddToWishListOrCarts(proListData.json!, itemID: proListData.pid!, isAddToWishList: false, isAddToCartList: false, isDeleteFromWishList: false, isDeleteFromCartList: true, completionHandler: { (isAdded) in
                //self.updatecollectionview.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                self.updatecollectionview.reloadItemsAtIndexPaths([indexPath])
            })
            
        }else{
            
            CXDataProvider.sharedInstance.itemAddToWishListOrCarts(proListData.json!, itemID: proListData.pid!, isAddToWishList: false, isAddToCartList: true, isDeleteFromWishList: false, isDeleteFromCartList: false, completionHandler: { (isAdded) in
                self.updatecollectionview.reloadItemsAtIndexPaths([indexPath])
                
            })
            // Add Item to Cart
            //            sender.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
            //            sender.imageView?.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
            //            sender.setTitleColor(UIColor.whiteColor(), forState: .Selected)
            //            sender.selected = true
            // CXDataProvider.sharedInstance.itemAddToWishListOrCarts(proListData.json!, itemID: proListData.pid!, isAddToWishList: false, isAddToCartList: true, isDeleteFromWishList: false, isDeleteFromCartList: false)
            
        }
        
        
        
        
    }
    
    func productAddedToWishList(sender:UIButton){
        
        let proListData : CX_Products = self.products[sender.tag-1] as! CX_Products
        let indexPath = NSIndexPath(forRow: sender.tag-1, inSection: 0)
        
        if sender.selected {
            //Remove Item From WishList
            
            CXDataProvider.sharedInstance.itemAddToWishListOrCarts(proListData.json!, itemID: proListData.pid!, isAddToWishList: false, isAddToCartList: false, isDeleteFromWishList: true, isDeleteFromCartList: false, completionHandler: { (isAdded) in
                //self.updatecollectionview.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                self.updatecollectionview.reloadItemsAtIndexPaths([indexPath])
            })
            
        }else{
            
            //Add Item to WishList
            
            CXDataProvider.sharedInstance.itemAddToWishListOrCarts(proListData.json!, itemID: proListData.pid!, isAddToWishList: true, isAddToCartList: false, isDeleteFromWishList: false, isDeleteFromCartList: false, completionHandler: { (isAdded) in
                self.updatecollectionview.reloadItemsAtIndexPaths([indexPath])
                
            })
            
        }
    }
    
}


