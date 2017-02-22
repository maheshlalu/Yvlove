//
//  ProductsViewController.swift
//  NowFloats
//
//  Created by Mahesh Y on 8/18/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit
import QuartzCore
import FacebookCore
import FBSDKCoreKit
import Alamofire

class ProductsViewController: CXViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,KYButtonDelegate {
    
    var arrAdditinalCategery = NSMutableArray()
    var screenWidth: CGFloat! = nil
    var products: NSArray!
    let chooseArticleDropDown = DropDown()
    
    @IBOutlet var updatecollectionview: UICollectionView!
    @IBOutlet weak var chooseArticleButton: UIButton!
    @IBOutlet weak var productSearhBar: UISearchBar!
    var type : String = String()
    var FinalPrice:String! = nil
    @IBOutlet weak var button: KYButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chooseArticleButton.isHidden = false
        let nib = UINib(nibName: "ProductsCollectionViewCell", bundle: nil)
        self.updatecollectionview.register(nib, forCellWithReuseIdentifier: "ProductsCollectionViewCell")
        
        UISearchBar.appearance().tintColor = CXAppConfig.sharedInstance.getAppTheamColor()
        chooseArticleButton.imageEdgeInsets = UIEdgeInsetsMake(0, chooseArticleButton.titleLabel!.frame.size.width+55, 0, -chooseArticleButton.titleLabel!.frame.size.width)
        
        getAddtinalCategryList()
        getTheProducts()
        //setupDropDowns()
    }
    
    func openKYButton(_ button: KYButton) {
        print("> <")
    }
    
    func closeKYButton(_ button: KYButton) {
        print("= =")
    }
    
    func getAddtinalCategryList(){
        
        button.kyDelegate = self
        button.openType = .popUp
        button.plusColor = UIColor.white
        button.fabTitleColor = UIColor.white
        
        var dictcategeryadd = NSMutableArray()
        if(UserDefaults.standard.object(forKey: "CategeryAdditinal") == nil)
        {
            print("NULL")
        }else{
            dictcategeryadd = UserDefaults.standard.value(forKey: "CategeryAdditinal") as! NSMutableArray
        }
        
        if (dictcategeryadd.count == 0){
            let dataKyes = ["type":"ProductCategories","mallId":CXAppConfig.sharedInstance.getAppMallID()]
            CXDataService.sharedInstance.getTheAppDataFromServer(dataKyes as [String : AnyObject]?) { (responceDic) in
                let jobsData:NSArray = responceDic.value(forKey: "jobs")! as! NSArray
                for dictData in jobsData {
                    let dictindividual : NSDictionary =  (dictData as? NSDictionary)!
                    let name:String = (dictindividual.value(forKey: "Name") as? String)!
                    self.arrAdditinalCategery.add(name)
                    self.button.add(color: CXAppConfig.sharedInstance.getAppTheamColor(), title: name as? String)
                }
                UserDefaults.standard.set(self.arrAdditinalCategery, forKey: "CategeryAdditinal")
            }
        }else{
            for name in dictcategeryadd
            {
                self.button.add(color: CXAppConfig.sharedInstance.getAppTheamColor(), title: name as? String, image: UIImage(named: "sidePanel")!){
                    (item) in
                    print(item._titleLabel?.text! as Any)
                    self.callAddtinalCategerySevice(str: (item._titleLabel?.text!)! as String as NSString)
                }
            }
        }
    }
    
    func callAddtinalCategerySevice(str : NSString)
    {
        print(str)
        
        let dataKyes = ["type":str,"mallId":CXAppConfig.sharedInstance.getAppMallID()] as [String : Any]
        CXDataService.sharedInstance.getTheAppDataFromServer(dataKyes as [String : AnyObject]?) { (responceDic) in
            //print("Sub categery details \(responceDic)")
            //  var arrCategeryData =
            CXDataProvider.sharedInstance.saveTheProducts(responceDic, completion: { (response) in
                print(response)
                let fetchRequest :  NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CX_Products")
                
                let resultstr =  str.replacingOccurrences(of: " ", with: "")
                
                let predicate =  NSPredicate(format: "type=='\(resultstr)'", argumentArray: nil)
                fetchRequest.predicate = predicate
                self.products =  CX_Products.mr_executeFetchRequest(fetchRequest) as NSArray!
                self.updatecollectionview.reloadData()
                
            })
        }
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
    
    func getTheProductsFromLocalDB()->NSArray{
        let fetchRequest :  NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CX_Products")
        let predicate =  NSPredicate(format: "type=='\(self.type)'", argumentArray: nil)
        if type != "both"{
            fetchRequest.predicate = predicate
        }
        self.products =  CX_Products.mr_executeFetchRequest(fetchRequest) as NSArray!
        return self.products
    }
    
    func getTheProducts(){
        self.products =  CX_Products.mr_findAll() as NSArray!
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
        cell.produstimageview.setImageWith(URL(string: products.imageUrl!), usingActivityIndicatorStyle: .gray)
        
        let rupee = "\u{20B9}"
        
        //Trimming Price And Discount
        let floatPrice: Float = Float(CXDataProvider.sharedInstance.getJobID("MRP", inputDic: products.json!))!
        let finalPrice = String(format: floatPrice == floor(floatPrice) ? "%.0f" : "%.1f", floatPrice)
        
        //let floatDiscount:Float = Float(CXDataProvider.sharedInstance.getJobID("DiscountAmount", inputDic: products.json!))!
        let floatDis = CXDataProvider.sharedInstance.getJobID("DiscountAmount", inputDic: products.json!)
        
        var floatDiscount:Float = Float()
        
        if floatDis == ""{
            floatDiscount = 0.0
        }
        
        let finalDiscount = String(format: floatDiscount == floor(floatDiscount) ? "%.0f" : "%.1f", floatDiscount)
        
        
        
        //Setting AttributedPrice
        let attributeString: NSMutableAttributedString! =  NSMutableAttributedString(string: "\(rupee) \(finalPrice)")
        attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 1, range: NSMakeRange(0, attributeString.length))
        
        //FinalPrice after subtracting the discount
        let finalPriceNum:Int! = Int(finalPrice)!-Int(finalDiscount)!
        FinalPrice = String(finalPriceNum) as String
        
        if finalPrice == FinalPrice{
            cell.productpriceLabel.isHidden = true
            cell.productFinalPriceLabel.text! = "\(rupee) \(FinalPrice!)"
        }else{
            cell.productpriceLabel.isHidden = false
            cell.productpriceLabel.attributedText = attributeString
            cell.productFinalPriceLabel.text! = "\(rupee) \(FinalPrice!)"
        }
        
        cell.cartaddedbutton.tag = indexPath.row+1
        cell.likebutton.tag = indexPath.row+1
        
        cell.cartaddedbutton.addTarget(self, action: #selector(ProductsViewController.productAddedToCart(_:)), for: UIControlEvents.touchUpInside)
        cell.likebutton.addTarget(self, action: #selector(ProductsViewController.productAddedToWishList(_:)), for: UIControlEvents.touchUpInside)
        
        self.assignCartButtonWishtListProperTy(cell, indexPath: indexPath, productData: products)
        // Enhancements in nowfloats
        let MRP = FinalPrice
        if MRP == "0"{
            cell.productpriceLabel.isHidden = true
            cell.productFinalPriceLabel.isHidden = true
            cell.cartaddedbutton.isHidden = true
            
        }else{
            cell.productpriceLabel.isHidden = false
            cell.productFinalPriceLabel.isHidden = false
            cell.cartaddedbutton.isHidden = false
        }
        
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
        return CGSize(width: (updatecollectionview.bounds.size.width)/2-8, height: 222)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let products:CX_Products = (self.products[indexPath.item] as? CX_Products)!
        print(products.json!)
        
        //Trimming Price And Discount
        let floatPrice: Float = Float(CXDataProvider.sharedInstance.getJobID("MRP", inputDic: products.json!))!
        let finalPrice = String(format: floatPrice == floor(floatPrice) ? "%.0f" : "%.1f", floatPrice)
        
        let floatDiscount:Float = Float(CXDataProvider.sharedInstance.getJobID("DiscountAmount", inputDic: products.json!))!
        let finalDiscount = String(format: floatDiscount == floor(floatDiscount) ? "%.0f" : "%.1f", floatDiscount)
        
        //FinalPrice after subtracting the discount
        let finalPriceNum:Int! = Int(finalPrice)!-Int(finalDiscount)!
        let FinalPrice = String(finalPriceNum) as String
        
        let productDetails = storyBoard.instantiateViewController(withIdentifier: "PRODUCT_DETAILS") as! ProductDetailsViewController
        productDetails.productString = products.json
        let dict = CXConstant.sharedInstance.convertStringToDictionary(products.json!)
        print(dict)
        var link = Bool()
        var mrp = Bool()
        /*
         if dict.value(forKey: "BuyOnlineLink") as! String == ""{
         link = false
         }else{link = true}
         */
        
        if dict.value(forKey: "MRP") as! String == "0"{
            mrp = false
        }else{mrp = true}
        
        print(link,mrp)
        
        productDetails.isMRP = mrp
        productDetails.isLink = link
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

extension ProductsViewController:UISearchBarDelegate {
    
    func searchBarSearchButtonClicked( _ searchBar: UISearchBar) {
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
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.productSearhBar.resignFirstResponder()
    }
    
    func doSearch () {
        let productEn = NSEntityDescription.entity(forEntityName: "CX_Products", in: NSManagedObjectContext.mr_contextForCurrentThread())
        let predicate:NSPredicate =  NSPredicate(format: "name contains[c] %@",self.productSearhBar.text!)
        
        let fetchRequest = CX_Products.mr_requestAllSorted(by: "pid", ascending: false)
        fetchRequest?.predicate = predicate
        fetchRequest?.entity = productEn
        self.products = CX_Products.mr_executeFetchRequest(fetchRequest) as NSArray
        self.updatecollectionview.reloadData()
    }
}

//Droup down
extension ProductsViewController {
    
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
