//
//  ProductsViewController.swift
//  NowFloats
//
//  Created by Mahesh Y on 8/18/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit
import QuartzCore


class ProductsViewController: CXViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    var screenWidth: CGFloat! = nil
    var products: NSArray!
    let chooseArticleDropDown = DropDown()
    @IBOutlet var updatecollectionview: UICollectionView!
    @IBOutlet weak var chooseArticleButton: UIButton!
    @IBOutlet weak var productSearhBar: UISearchBar!
    var type : String = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "ProductsCollectionViewCell", bundle: nil)
        self.updatecollectionview.register(nib, forCellWithReuseIdentifier: "ProductsCollectionViewCell")
        UISearchBar.appearance().tintColor = CXAppConfig.sharedInstance.getAppTheamColor()
        chooseArticleButton.imageEdgeInsets = UIEdgeInsetsMake(0, chooseArticleButton.titleLabel!.frame.size.width+55, 0, -chooseArticleButton.titleLabel!.frame.size.width)
        
        //chooseArticleButton.imageEdgeInsets = UIEdgeInsetsMake(<#T##top: CGFloat##CGFloat#>, <#T##left: CGFloat##CGFloat#>, <#T##bottom: CGFloat##CGFloat#>, <#T##right: CGFloat##CGFloat#>)
        getTheProducts()
        setupDropDowns()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updatecollectionview.reloadData()
    }
    
    @IBAction func chooseBtnAction(_ sender: AnyObject) {
        chooseArticleDropDown.show()
    }
    func setupDropDowns() {
        self.chooseArticleButton.setTitle("\("  ")Popularity", for: UIControlState())
        setupChooseArticleDropDown()
    }
    
    
    func getTheProducts(){
        
        #if MyLabs
            let fetchRequest :  NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CX_Products")
            let predicate =  NSPredicate(format: "type=='\(self.type)'", argumentArray: nil)
            fetchRequest.predicate = predicate
            self.products =  CX_Products.mr_executeFetchRequest(fetchRequest) as NSArray!
        #else
            self.products =  CX_Products.mr_findAll() as NSArray!
            
        #endif
 
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
        let discount:String = "0"// CXDataProvider.sharedInstance.getJobID("DiscountAmount", inputDic: products.json!)
        
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
    //    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
    //
    //        return 3.0
    // }
    
    
    //    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    //        screenWidth =  UIScreen.mainScreen().bounds.size.width
    //
    //        return CGSize(width: screenWidth/2.2+7, height: 222);
    //    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (updatecollectionview.bounds.size.width)/2-8, height: 222)
        
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
}

//Cart and Wishlist functios

extension ProductsViewController {
    
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



extension ProductsViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked( _ searchBar: UISearchBar)
    {
        self.productSearhBar.resignFirstResponder()
        self.doSearch()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
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
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.refreshSearchBar()
        // Do a default fetch of the beers
        self.loadDefaultList()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.productSearhBar.showsCancelButton = false;
        
    }
    
    func doSearch () {
        
        #if MyLabs
            //let productEn = NSEntityDescription.entity(forEntityName: "CX_Products", in: NSManagedObjectContext.mr_contextForCurrentThread())
            let predicate:NSPredicate =  NSPredicate(format: "name contains[c] %@ AND type=='\(self.type)'",self.productSearhBar.text!)
            let fetchRequest :  NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CX_Products")
           // let predicate =  NSPredicate(format: "type=='\(self.type)'", argumentArray: nil)
            fetchRequest.predicate = predicate
            self.products =  CX_Products.mr_executeFetchRequest(fetchRequest) as NSArray!
        #else
            let productEn = NSEntityDescription.entity(forEntityName: "CX_Products", in: NSManagedObjectContext.mr_contextForCurrentThread())
            let predicate:NSPredicate =  NSPredicate(format: "name contains[c] %@",self.productSearhBar.text!)
            
            let fetchRequest = CX_Products.mr_requestAllSorted(by: "pid", ascending: false)
            fetchRequest?.predicate = predicate
            fetchRequest?.entity = productEn
            self.products = CX_Products.mr_executeFetchRequest(fetchRequest) as NSArray

        #endif
        
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
        
        var predicate : NSPredicate = NSPredicate()
        
        #if MyLabs
           predicate = NSPredicate(format: "type=='\(self.type)'", argumentArray: nil)
        #else
        #endif
        
        // Action triggered on selection
        chooseArticleDropDown.selectionAction = { [unowned self] (index, item) in
            self.chooseArticleButton.setTitle(item, for: UIControlState())
              if index == 0{
                 self.products  = CX_Products.mr_findAll() as NSArray!
            }else if index == 1{
    
                self.products = CX_Products.mr_findAllSorted(by: "pUpdateDate", ascending: false, with: predicate) as NSArray!
            }else if index == 2{
                //pPrice
                self.products = CX_Products.mr_findAllSorted(by: "pPrice", ascending: false, with: predicate) as NSArray!
            }else if index == 3{
                self.products = CX_Products.mr_findAllSorted(by: "pPrice", ascending: true, with: predicate) as NSArray!
            }else if index == 4{
                self.products = CX_Products.mr_findAllSorted(by: "pUpdateDate", ascending: true, with: predicate) as NSArray!
            }
            
            self.updatecollectionview.reloadData()
        }
                                   
    }
}


