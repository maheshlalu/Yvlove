                     //
//  ProductsViewController.swift
//  NowFloats
//
//  Created by Mahesh Y on 8/18/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit


class ProductsViewController: CXViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    var screenWidth: CGFloat! = nil
    var products: NSArray!
    let chooseArticleDropDown = DropDown()
    @IBOutlet var updatecollectionview: UICollectionView!
    @IBOutlet weak var chooseArticleButton: UIButton!
    @IBOutlet weak var productSearhBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "ProductsCollectionViewCell", bundle: nil)
        self.updatecollectionview.registerNib(nib, forCellWithReuseIdentifier: "ProductsCollectionViewCell")
        UISearchBar.appearance().tintColor = CXAppConfig.sharedInstance.getAppTheamColor()
        chooseArticleButton.imageEdgeInsets = UIEdgeInsetsMake(0, chooseArticleButton.titleLabel!.frame.size.width+55, 0, -chooseArticleButton.titleLabel!.frame.size.width)
        
        //chooseArticleButton.imageEdgeInsets = UIEdgeInsetsMake(<#T##top: CGFloat##CGFloat#>, <#T##left: CGFloat##CGFloat#>, <#T##bottom: CGFloat##CGFloat#>, <#T##right: CGFloat##CGFloat#>)
        getTheProducts()
        setupDropDowns()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.updatecollectionview.reloadData()
    }
    
    @IBAction func chooseBtnAction(sender: AnyObject) {
        chooseArticleDropDown.show()
    }
    func setupDropDowns() {
        self.chooseArticleButton.setTitle("\("  ")Popularity", forState: .Normal)
        setupChooseArticleDropDown()
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
    //    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
    //
    //        return 3.0
    // }
    
    
    //    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    //        screenWidth =  UIScreen.mainScreen().bounds.size.width
    //
    //        return CGSize(width: screenWidth/2.2+7, height: 222);
    //    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: (updatecollectionview.bounds.size.width)/2-8, height: 222)
        
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
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
}

//Cart and Wishlist functios

extension ProductsViewController {
    
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



extension ProductsViewController : DOPDropDownMenuDelegate,DOPDropDownMenuDataSource {
    
    func numberOfColumnsInMenu(menu: DOPDropDownMenu!) -> Int {
        return 1
    }
    
    func menu(menu: DOPDropDownMenu!, numberOfRowsInColumn column: Int) -> Int {
        return 3
    }
    
    func menu(menu: DOPDropDownMenu!, titleForRowAtIndexPath indexPath: DOPIndexPath!) -> String! {
        return "test1"
    }
   
}



extension ProductsViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked( searchBar: UISearchBar)
    {
        self.productSearhBar.resignFirstResponder()
        self.doSearch()
    }
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        // print("search string \(searchText)")
        if (self.productSearhBar.text!.characters.count > 0) {
            self.doSearch()
        } else {
            self.loadDefaultList()
        }
        
    }
    
    func loadDefaultList (){
        self.getTheProducts()
        /*if isProductCategory {
            let predicate:NSPredicate = NSPredicate(format: "masterCategory = %@", "Products List(129121)")
            self.getProductSubCategory(predicate)
        }else{
            let predicate:NSPredicate = NSPredicate(format: "masterCategory = %@", "Miscellaneous(135918)")
            self.getProductSubCategory(predicate)
        }*/
    }
    
    func refreshSearchBar (){
        self.productSearhBar.resignFirstResponder()
        // Clear search bar text
        self.productSearhBar.text = "";
        // Hide the cancel button
        self.productSearhBar.showsCancelButton = false;
        
    }
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.refreshSearchBar()
        // Do a default fetch of the beers
        self.loadDefaultList()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.productSearhBar.showsCancelButton = false;
        
    }
    
    func doSearch () {
 
        let productEn = NSEntityDescription.entityForName("CX_Products", inManagedObjectContext: NSManagedObjectContext.MR_contextForCurrentThread())
        let predicate:NSPredicate =  NSPredicate(format: "name contains[c] %@",self.productSearhBar.text!)
        let fetchRequest = CX_Products.MR_requestAllSortedBy("pid", ascending: false)
        fetchRequest.predicate = predicate
        fetchRequest.entity = productEn
        self.products = CX_Products.MR_executeFetchRequest(fetchRequest)
       self.updatecollectionview.reloadData()
        
        /*let productEn = NSEntityDescription.entityForName("TABLE_PRODUCT_SUB_CATEGORIES", inManagedObjectContext: NSManagedObjectContext.MR_contextForCurrentThread())
        let fetchRequest = TABLE_PRODUCT_SUB_CATEGORIES.MR_requestAllSortedBy("id", ascending: false)
        var predicate:NSPredicate = NSPredicate()
        
        if isProductCategory {
            predicate = NSPredicate(format: "masterCategory = %@ AND name contains[c] k%@", "Products List(129121)",self.searchBar.text!)
        }else{
            predicate = NSPredicate(format: "masterCategory = %@ AND name contains[c] %@", "Miscellaneous(135918)",self.searchBar.text!)
        }
        
        fetchRequest.predicate = predicate
        fetchRequest.entity = productEn
        
        self.productCategories =   TABLE_PRODUCT_SUB_CATEGORIES.MR_executeFetchRequest(fetchRequest)
        
        self.productCollectionView.reloadData()*/
        
    }
    
    
    
    
}

//Droup down
extension ProductsViewController{
    
    func setupChooseArticleDropDown() {
        chooseArticleDropDown.anchorView = chooseArticleButton
        chooseArticleDropDown.bottomOffset = CGPoint(x: 0, y: self.productSearhBar.frame.size.height+4)
        
        // You can also use localizationKeysDataSource instead. Check the docs.
        chooseArticleDropDown.dataSource = [
            "   Popularity",
            "   Recent",
            "   High Price",
            "   Low Price",
            "   Oldest"
        ]
        
        // Action triggered on selection
        chooseArticleDropDown.selectionAction = { [unowned self] (index, item) in
            self.chooseArticleButton.setTitle(item, forState: .Normal)
              if index == 0{
                 self.products  = CX_Products.MR_findAll()
            }else if index == 1{
                self.products = CX_Products.MR_findAllSortedBy("pUpdateDate", ascending: false)
            }else if index == 2{
                self.products = CX_Products.MR_findAllSortedBy("pPrice", ascending: false)
            }else if index == 3{
                self.products = CX_Products.MR_findAllSortedBy("pPrice", ascending: true)
            }else if index == 4{
                self.products = CX_Products.MR_findAllSortedBy("pUpdateDate", ascending: true)
            }
            
            self.updatecollectionview.reloadData()
        }
                                   
    }
}


