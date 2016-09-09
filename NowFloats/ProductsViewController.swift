//
//  ProductsViewController.swift
//  NowFloats
//
//  Created by Mahesh Y on 8/18/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit

class ProductsViewController: CXViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    //let screenSize:CGRect = UIScreen.mainScreen().bounds
    var screenWidth: CGFloat! = nil
    var products: NSArray!
    @IBOutlet var updatecollectionview: UICollectionView!
    @IBOutlet weak var dropDownView: DOPDropDownMenu!
    
    @IBOutlet weak var productSearhBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.productSearhBar.placeholder = "Search for products"
        self.view.backgroundColor = UIColor.lightGrayColor()
        let nib = UINib(nibName: "ProductsCollectionViewCell", bundle: nil)
        self.updatecollectionview.registerNib(nib, forCellWithReuseIdentifier: "ProductsCollectionViewCell")
        getTheProducts()
        self.setUpdroopDown()
    }
    
    func setUpdroopDown(){
        self.dropDownView.delegate = self
        self.dropDownView.dataSource = self
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
        cell.productdescriptionLabel.text = products.name
        cell.produstimageview.sd_setImageWithURL(NSURL(string: products.imageUrl!))
        cell.productdescriptionLabel.sizeToFit()
        
        let rupee = "\u{20B9}"
        let price:String = CXDataProvider.sharedInstance.getJobID("MRP", inputDic: products.json!)
        let discount:String = CXDataProvider.sharedInstance.getJobID("DiscountAmount", inputDic: products.json!)
        
        if discount == "0"{
            cell.productFinalPriceLabel.hidden = true
            cell.productpriceLabel.text = "\(rupee) \(price)"
            cell.productpriceLabel.font = cell.productpriceLabel.font.fontWithSize(13)
            cell.productpriceLabel.textColor = UIColor.darkGrayColor()
        }else{
            cell.productFinalPriceLabel.hidden = false
            cell.productpriceLabel.font = cell.productpriceLabel.font.fontWithSize(11)
            cell.productpriceLabel.textColor = CXAppConfig.sharedInstance.getAppTheamColor()
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "\(rupee) \(price)")
            attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length))
            cell.productpriceLabel.attributedText = attributeString
            
            
            let finalPriceNum:Int = Int(price)!-Int(discount)!
            cell.productFinalPriceLabel.text = "\(rupee) \(String(finalPriceNum))"
        }
          return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        screenWidth =  UIScreen.mainScreen().bounds.size.width
        return CGSize(width: screenWidth/2-11, height: 200);
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let products:CX_Products = (self.products[indexPath.item] as? CX_Products)!
        
        let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let productDetails = storyBoard.instantiateViewControllerWithIdentifier("PRODUCT_DETAILS") as! ProductDetailsViewController
        //productDetails.productString = products.json
        self.navigationController?.pushViewController(productDetails, animated: true)
        
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
        self.productSearhBar.showsCancelButton = true;
        
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
            predicate = NSPredicate(format: "masterCategory = %@ AND name contains[c] %@", "Products List(129121)",self.searchBar.text!)
        }else{
            predicate = NSPredicate(format: "masterCategory = %@ AND name contains[c] %@", "Miscellaneous(135918)",self.searchBar.text!)
        }
        
        fetchRequest.predicate = predicate
        fetchRequest.entity = productEn
        
        self.productCategories =   TABLE_PRODUCT_SUB_CATEGORIES.MR_executeFetchRequest(fetchRequest)
        
        self.productCollectionView.reloadData()*/
        
    }
    
    
}

