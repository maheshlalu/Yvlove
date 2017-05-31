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
        self.updatecollectionview.register(nib, forCellWithReuseIdentifier: "ProductsCollectionViewCell")
        UISearchBar.appearance().tintColor = CXAppConfig.sharedInstance.getAppTheamColor()
        
        getTheProducts()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updatecollectionview.reloadData()
    }
    
    
    func getTheProducts(){
        let fetchRequest : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CX_Products")
        self.products  = CX_Products.mr_executeFetchRequest(fetchRequest) as NSArray
        self.updatecollectionview.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.products.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductsCollectionViewCell", for: indexPath)as! ProductsCollectionViewCell
        
        let products:CX_Products = (self.products[indexPath.item] as? CX_Products)!
        let productJson = products.value(forKey: "json") as! NSString
        let dic = CXConstant.sharedInstance.convertStringToDictionary(productJson as String) as NSDictionary
        let shipmentDuration = dic.value(forKey: "ShipmentDuration")
        cell.productdescriptionLabel.text = products.name
        if shipmentDuration != nil {
            cell.produstimageview.contentMode = UIViewContentMode.scaleToFill
        }else{
            cell.produstimageview.contentMode = UIViewContentMode.scaleAspectFit
        }
        cell.produstimageview.sd_setImage(with: URL(string: products.imageUrl!))
        
        let rupee = "\u{20B9}"
        let price:String = CXDataProvider.sharedInstance.getJobID("MRP", inputDic: products.json!)
        let discount:String = CXDataProvider.sharedInstance.getJobID("DiscountAmount", inputDic: products.json!)
        
        if discount == "0"{
            cell.productpriceLabel.isHidden = true
            cell.productFinalPriceLabel.text = "\(rupee) \(price)"
            cell.productFinalPriceLabel.font = cell.productpriceLabel.font.withSize(14)
            cell.productFinalPriceLabel.textColor = UIColor.darkGray
        }else{
            cell.productpriceLabel.isHidden = false
            cell.productpriceLabel.font = cell.productpriceLabel.font.withSize(11)
            cell.productpriceLabel.textColor = CXAppConfig.sharedInstance.getAppTheamColor()
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "\(rupee) \(price)")
            attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 1, range: NSMakeRange(0, attributeString.length))
            cell.productpriceLabel.attributedText = attributeString
            
            let finalPriceNum:Int = Int(price)!-Int(discount)!
            cell.productFinalPriceLabel.text = "\(rupee) \(String(finalPriceNum))"
        }
        
        cell.cartaddedbutton.tag = indexPath.row+1
        cell.likebutton.tag = indexPath.row+1
        
        
        cell.cartaddedbutton.addTarget(self, action: #selector(ProductsViewController.productAddedToCart(_:)), for: UIControlEvents.touchUpInside)
        cell.likebutton.addTarget(self, action: #selector(ProductsViewController.productAddedToWishList(_:)), for: UIControlEvents.touchUpInside)
        
        self.assignCartButtonWishtListProperTy(cell, indexPath: indexPath, productData: products)
        
        
        return cell
    }
    
    
    func assignCartButtonWishtListProperTy(_ tableViewCell:ProductsCollectionViewCell,indexPath:IndexPath,productData:CX_Products){
        
        if CXDataProvider.sharedInstance.isAddToCart(productData.pid! as NSString).isAddedToCart{
            tableViewCell.cartaddedbutton.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
            tableViewCell.cartaddedbutton.imageView?.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
            tableViewCell.cartaddedbutton.setTitleColor(UIColor.white, for: .selected)
            tableViewCell.cartaddedbutton.isSelected = true
        }else{
            tableViewCell.cartaddedbutton.isSelected = false
            tableViewCell.cartaddedbutton.backgroundColor = UIColor.white
            tableViewCell.cartaddedbutton.imageView?.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
            tableViewCell.cartaddedbutton.setTitleColor(CXAppConfig.sharedInstance.getAppTheamColor(), for: UIControlState())
        }
        
        if CXDataProvider.sharedInstance.isAddToCart(productData.pid! as NSString).isAddedToWishList{
            tableViewCell.likebutton.isSelected = true
            
        }else{
            tableViewCell.likebutton.isSelected = false
        }
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width-20, height: 222)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let products:CX_Products = (self.products[indexPath.item] as? CX_Products)!
        
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let productDetails = storyBoard.instantiateViewController(withIdentifier: "PRODUCT_DETAILS") as! ProductDetailsViewController
        productDetails.productString = products.json
        self.navigationController?.pushViewController(productDetails, animated: true)
        
    }
    
}

//Cart and Wishlist functios

extension ProductSearchViewController {
    
    func productAddedToCart(_ sender:UIButton){
        
        let proListData : CX_Products = self.products[sender.tag-1] as! CX_Products
        let indexPath = IndexPath(row: sender.tag-1, section: 0)
        
        //CXDataProvider.sharedInstance.itemAddToWishListOrCarts(proListData.json!, itemID: proListData.pid!, isAddToWishList: false, isAddToCartList: true)
        
        if sender.isSelected {
            //Remove Item From Cart
            CXDataProvider.sharedInstance.itemAddToWishListOrCarts(proListData.json!, itemID: proListData.pid!, isAddToWishList: false, isAddToCartList: false, isDeleteFromWishList: false, isDeleteFromCartList: true, completionHandler: { (isAdded) in
                //self.updatecollectionview.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                self.updatecollectionview.reloadItems(at: [indexPath])
            })
            
        }else{
            
            CXDataProvider.sharedInstance.itemAddToWishListOrCarts(proListData.json!, itemID: proListData.pid!, isAddToWishList: false, isAddToCartList: true, isDeleteFromWishList: false, isDeleteFromCartList: false, completionHandler: { (isAdded) in
                self.updatecollectionview.reloadItems(at: [indexPath])
                
            })
            // Add Item to Cart
            //            sender.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
            //            sender.imageView?.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
            //            sender.setTitleColor(UIColor.whiteColor(), forState: .Selected)
            //            sender.selected = true
            // CXDataProvider.sharedInstance.itemAddToWishListOrCarts(proListData.json!, itemID: proListData.pid!, isAddToWishList: false, isAddToCartList: true, isDeleteFromWishList: false, isDeleteFromCartList: false)
            
        }
        
        
        
        
    }
    
    func productAddedToWishList(_ sender:UIButton){
        
        let proListData : CX_Products = self.products[sender.tag-1] as! CX_Products
        let indexPath = IndexPath(row: sender.tag-1, section: 0)
        
        if sender.isSelected {
            //Remove Item From WishList
            
            CXDataProvider.sharedInstance.itemAddToWishListOrCarts(proListData.json!, itemID: proListData.pid!, isAddToWishList: false, isAddToCartList: false, isDeleteFromWishList: true, isDeleteFromCartList: false, completionHandler: { (isAdded) in
                //self.updatecollectionview.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                self.updatecollectionview.reloadItems(at: [indexPath])
            })
            
        }else{
            
            //Add Item to WishList
            
            CXDataProvider.sharedInstance.itemAddToWishListOrCarts(proListData.json!, itemID: proListData.pid!, isAddToWishList: true, isAddToCartList: false, isDeleteFromWishList: false, isDeleteFromCartList: false, completionHandler: { (isAdded) in
                self.updatecollectionview.reloadItems(at: [indexPath])
                
            })
            
        }
    }
    
}


