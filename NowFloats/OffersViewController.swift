//
//  OffersViewController.swift
//  NowFloats
//
//  Created by apple on 30/08/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit
let reuseTableViewCellIdentifier = "OfferTableViewCell"
let reuseCollectionViewCellIdentifier = "OfferCollectionViewCell"

class OffersViewController: CXViewController{
    @IBOutlet weak var offersNotAvailLbl: UILabel!
    
    @IBOutlet weak var offersTableView: UITableView!
    @IBOutlet weak var productsSearchBar: UISearchBar!
    
    var products : NSArray! = nil
    var storedOffsets = [Int: CGFloat]()
    var featureProducts: NSArray!
    var search:ProductSearchViewController! = nil
    var FinalPrice:String! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.featureProducts = CXDataProvider.sharedInstance.getTheTableDataFromDataBase("CX_FeaturedProducts", predicate: NSPredicate(), ispredicate: false, orederByKey: "fID").dataArray
        self.registerTableViewCell()
        self.getTheProducts()

    }
    
    func getTheProducts(){
        let fetchRequest : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CX_Products")
        self.products  = CX_Products.mr_executeFetchRequest(fetchRequest) as NSArray
        
        self.offersTableView.reloadData()
    }
}

//MARK: Featured Product Tableview
extension OffersViewController{
    
    func registerTableViewCell(){
        self.offersTableView.backgroundColor = UIColor.clear
        self.offersTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.offersTableView.contentInset = UIEdgeInsetsMake(0, 0,30, 0)
        self.offersTableView.rowHeight = UITableViewAutomaticDimension
        self.offersTableView.showsVerticalScrollIndicator = false
        self.offersTableView.isScrollEnabled = true
    }
}

extension OffersViewController : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return featureProducts.count+1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return self.pagerCell(tableView, indexPath: indexPath ,reuseIdentFier: "PAGER")
        }else {
            return self.featureProuctsCell(tableView, indexPath: indexPath, reuseIdentFier: reuseTableViewCellIdentifier)
        }
    }
    
    func pagerCell(_ tableView: UITableView,indexPath: IndexPath,reuseIdentFier : String) -> UITableViewCell{
        
        tableView.register(UINib(nibName: "OfferPagerCelll", bundle: nil), forCellReuseIdentifier: reuseIdentFier)
        let pagerCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentFier , for: indexPath) as! OfferPagerCelll
        pagerCell.pagerView.delegate = self
        pagerCell.pagerView.dataSource = self
        if CXAppConfig.sharedInstance.ispagerEnable() {
            pagerCell.pagerView.slideshowTimeInterval = 2
        }else{
            pagerCell.pagerView.slideshowTimeInterval = 0
        }
        return pagerCell
    }
    
    func featureProuctsCell(_ tableView: UITableView,indexPath: IndexPath,reuseIdentFier : String) -> UITableViewCell{
        
        var feturedProuctsCell: OfferFeaturedProductCell! = tableView.dequeueReusableCell(withIdentifier: reuseIdentFier) as? OfferFeaturedProductCell
        if feturedProuctsCell == nil {
            tableView.register(UINib(nibName: "OfferFeaturedProductCell", bundle: nil), forCellReuseIdentifier: reuseIdentFier)
            feturedProuctsCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentFier) as? OfferFeaturedProductCell
        }
        feturedProuctsCell.setCollectionViewDataSourceDelegate(dataSource: self, delegate: self, forRow: indexPath.row)
        //feturedProuctsCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.section-1)
        print("indext path tag \(indexPath.section)")
        //feturedProuctsCell.detailCollectionView.tag = indexPath.section
        feturedProuctsCell.detailCollectionView.allowsSelection = true
        let featureProducts : CX_FeaturedProducts =  (self.featureProducts[indexPath.section-1] as? CX_FeaturedProducts)!
        let str = featureProducts.name! as String
       // let str1 = str.trimmingCharacters(in: CharacterSet.init(charactersIn: "_"))
        let strRemove =  str.replacingOccurrences(of: "_", with: " ")
        
        feturedProuctsCell.headerLbl.text = "\(strRemove)"
        feturedProuctsCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
        return feturedProuctsCell
    }
    
    func removeSpecialCharsFromString(_ text: String) -> String {
        let okayChars : Set<Character> =
            Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890+-*=(),.:!_".characters)
        return String(text.characters.filter {okayChars.contains($0) })
    }
    
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
//        let arr:Array = ["Suresh","Mahesh","Balu"]
//        
//        if section < arr.count {
//            return arr[section]
//        }
//        
//        return nil
//    
//    }
    
    /*func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 200
        }else {
            
        }
        return 150
    }
    */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return CXConstant.tableViewHeigh - 75;
        }else if indexPath.section == 2{
            return CXConstant.tableViewHeigh - 5;
        }else{
            return CXConstant.tableViewHeigh - 25;
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}

extension OffersViewController : UICollectionViewDataSource,UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        let featureProducts : CX_FeaturedProducts =  (self.featureProducts[collectionView.tag] as? CX_FeaturedProducts)!
 
        return CXDataProvider.sharedInstance.getTheTableDataFromDataBase("CX_FeaturedProductsJobs", predicate: NSPredicate(format: "parentID == %@",featureProducts.fID!), ispredicate: true, orederByKey: "").totalCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        
        let featureProducts : CX_FeaturedProducts =  (self.featureProducts[collectionView.tag] as? CX_FeaturedProducts)!
        let featuredProductJobs : CX_FeaturedProductsJobs = (CXDataProvider.sharedInstance.getTheTableDataFromDataBase("CX_FeaturedProductsJobs", predicate: NSPredicate(format: "parentID == %@",featureProducts.fID!), ispredicate: true, orederByKey: "").dataArray[indexPath.row] as?CX_FeaturedProductsJobs)!
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OfferCollectionViewCell", for: indexPath)as? OfferCollectionViewCell
        DispatchQueue.main.async(execute: { () -> Void in
            cell?.productName.text = featuredProductJobs.name
        })
        
        
//        let identifier = "OfferCollectionViewCell"
//        let cell: OfferCollectionViewCell! = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as?OfferCollectionViewCell
//        if cell == nil {
//            collectionView.register(UINib(nibName: "OfferCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: identifier)
////            let nib = UINib(nibName: "OfferCollectionViewCell", bundle: nil)
////            self.offersTableView.register(nib, forCellReuseIdentifier: "OfferCollectionViewCell")
//                    }
        
        
        
        cell?.layer.borderWidth = 1.0
        cell?.layer.borderColor = UIColor.lightGray.cgColor
        cell?.layer.cornerRadius = 10.0
        
        // productsSearchBar.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
       // print(featuredProductJobs.name!)
        
       // cell.productImageView.sd_setImage(with: URL(string:featuredProductJobs.image_URL!)!)
        
        cell?.productImageView.setImageWith(NSURL(string: featuredProductJobs.image_URL!) as URL!, usingActivityIndicatorStyle: .gray)
        
        
        if featuredProductJobs.fDescription != nil{
            
            let rupee = "\u{20B9}"
            
            //Trimming Price And Discount
            let floatPrice: Float = Float(CXDataProvider.sharedInstance.getJobID("MRP", inputDic: featuredProductJobs.json!))!
            let finalPrice = String(format: floatPrice == floor(floatPrice) ? "%.0f" : "%.1f", floatPrice)
            
            let floatDis = CXDataProvider.sharedInstance.getJobID("DiscountAmount", inputDic: featuredProductJobs.json!)
            
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
                //cell.productPriceLbl.isHidden = true
                cell?.finalPriceLbl.text! = "\(rupee) \(FinalPrice!)"
            }else{
               // cell.productPriceLbl.isHidden = false
               // cell.productPriceLbl.attributedText = attributeString
                cell?.finalPriceLbl.text! = "\(rupee) \(FinalPrice!)"
            }
        }

        if featureProducts.name == "Brands"{
            
            //cell.productPriceLbl.isHidden = true
            cell?.finalPriceLbl.isHidden = true
            cell?.orderNowBtn.isHidden = true
            
        }
        
        let fId = Int(featuredProductJobs.fID! as String)
        cell?.orderNowBtn.tag = fId!

        cell?.orderNowBtn.addTarget(self, action: #selector(OffersViewController.orderNowBtnAction(_:)), for: UIControlEvents.touchUpInside)
        //self.productsSearchBar.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        // Set cell width to 100%

            return CXConstant.DetailCollectionCellSize
    }
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        print("\(indexPath.row)")
        //
        //        let fID = String(indexPath.row)
        let featureProducts : CX_FeaturedProducts =  (self.featureProducts[collectionView.tag] as? CX_FeaturedProducts)!
        let featuredProductJobs : CX_FeaturedProductsJobs = (CXDataProvider.sharedInstance.getTheTableDataFromDataBase("CX_FeaturedProductsJobs", predicate: NSPredicate(format: "parentID == %@",featureProducts.fID!), ispredicate: true, orederByKey: "").dataArray[indexPath.row] as?CX_FeaturedProductsJobs)!
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        print(featuredProductJobs.json!)
        
        let dict = CXDataService.sharedInstance.convertStringToDictionary(featuredProductJobs.json! as String) as NSDictionary
        
        //Trimming Price And Discount
        let floatPrice: Float = Float(CXDataProvider.sharedInstance.getJobID("MRP", inputDic: featuredProductJobs.json!))!
        let finalPrice = String(format: floatPrice == floor(floatPrice) ? "%.0f" : "%.1f", floatPrice)
        
        //let floatDiscount:Float = Float(CXDataProvider.sharedInstance.getJobID("DiscountAmount", inputDic: featuredProductJobs.json!))!
        
        let floatDis = CXDataProvider.sharedInstance.getJobID("DiscountAmount", inputDic: featuredProductJobs.json!)
        
        var floatDiscount:Float = Float()
        
        if floatDis == ""{
            floatDiscount = 0.0
        }
        
        let finalDiscount = String(format: floatDiscount == floor(floatDiscount) ? "%.0f" : "%.1f", floatDiscount)
        
        //FinalPrice after subtracting the discount
        let finalPriceNum:Int! = Int(finalPrice)!-Int(finalDiscount)!
        let FinalPrice = String(finalPriceNum) as String!
        
        let productDetails = storyBoard.instantiateViewController(withIdentifier: "PRODUCT_DETAILS") as! ProductDetailsViewController
        productDetails.productString = featuredProductJobs.json
        self.navigationController?.pushViewController(productDetails, animated: true)
        
    }

  
}


extension OffersViewController :UISearchBarDelegate{
    
    
    func searchBarSearchButtonClicked( _ searchBar: UISearchBar)
    {
        self.productsSearchBar.resignFirstResponder()
        self.doSearch()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if (self.productsSearchBar.text!.characters.count > 0) {
        } else if self.productsSearchBar.text!.characters.count == 0{
            print("inMethodCharectersCount0")
        }else if searchText.isEmpty{
            print("SearchTextEmptyMethod")
        }
    }
    
    func loadDefaultList (){
        self.getTheProducts()
    }
    
    func refreshSearchBar (){
        //self.productsSearchBar.resignFirstResponder()
        // Clear search bar text
        self.productsSearchBar.text = "";
        // Hide the cancel button
        self.productsSearchBar.showsCancelButton = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.refreshSearchBar()
        self.loadDefaultList()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    }
    
    func removeSearch(){
    }
    
    func doSearch () {
        
        self.search = self.storyboard?.instantiateViewController(withIdentifier: "ProductSearchViewController") as! ProductSearchViewController
        search.view.frame = CGRect(x: 0,y: self.productsSearchBar.frame.size.height, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.view.addSubview(search.view)
        addChildViewController(search)
        search.didMove(toParentViewController: self)
        
        
        let productEn = NSEntityDescription.entity(forEntityName: "CX_Products", in: NSManagedObjectContext.mr_contextForCurrentThread())
        let predicate:NSPredicate =  NSPredicate(format: "name contains[c] %@",self.productsSearchBar.text!)
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CX_Products.mr_requestAllSorted(by: "pid", ascending: false)
        fetchRequest.predicate = predicate
        fetchRequest.entity = productEn
        self.search.products = CX_Products.mr_executeFetchRequest(fetchRequest) as NSArray
        self.search.updatecollectionview.reloadData()
    }
    
}

//MARK: KIPager Delegate and Datasorce
extension OffersViewController : KIImagePagerDelegate,KIImagePagerDataSource {
    
    public func array(withImages pager: KIImagePager!) -> [Any]! {
        return ["" as AnyObject,"" as AnyObject,"" as AnyObject,"" as AnyObject,"" as AnyObject]
    }
    
    func contentMode(forImage image: UInt, in pager: KIImagePager!) -> UIViewContentMode {
        return .center
    }
    
    func populateTheProductData(inPager index: UInt, in pager: KIImagePager!) {
        
    }
    
    func populateTheProductData(_ index: UInt, in pager: KIImagePager!) -> ProductModelClass! {
        let productModelData : ProductModelClass = ProductModelClass.init()
        let productData : CX_Products = self.products.object(at: Int(index)) as! CX_Products
        productModelData.productName = productData.name
        productModelData.productimage = productData.imageUrl;
        productModelData.productSubTitle = productData.name
        pager.pagerView.productNameLbl.font = CXAppConfig.sharedInstance.appLargeFont()
        pager.pagerView.orederNowBtn.setTitleColor(CXAppConfig.sharedInstance.getAppTheamColor(), for: UIControlState())
        pager.pagerView.orederNowBtn.titleLabel?.font = CXAppConfig.sharedInstance.appMediumFont()
        pager.indicatorDisabled = false
        
        pager.pageControl.currentPageIndicatorTintColor = CXAppConfig.sharedInstance.getAppTheamColor()
        pager.pageControl.pageIndicatorTintColor = UIColor.gray;
        
        pager.pagerView.orederNowBtn.tag = Int(index+1)
        pager.pagerView.orederNowBtn.addTarget(self, action: #selector(OffersViewController.pagerOrderNowBtnAction(_:)), for: UIControlEvents.touchUpInside)
        
        return productModelData
    }
    
    func pagerOrderNowBtnAction(_ sender:UIButton){
        print("\(sender.tag)")
        let proListData : CX_Products = self.products[sender.tag-1] as! CX_Products
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)

        CXDataProvider.sharedInstance.itemAddToWishListOrCarts(proListData.json!, itemID: proListData.pid!, isAddToWishList: false, isAddToCartList: true, isDeleteFromWishList: false, isDeleteFromCartList: false, completionHandler: { (isAdded) in

            let cart = storyBoard.instantiateViewController(withIdentifier: "CART") as! CartViewController
            self.navigationController?.pushViewController(cart, animated: true)
        })
        
        
//       // let storyBoard1 = UIStoryboard(name: "Main", bundle: Bundle.main)
//        let cart = storyBoard.instantiateViewController(withIdentifier: "CART") as! CartViewController
//        self.navigationController?.pushViewController(cart, animated: true)
//        //self.navigationController?.pushViewController(productDetails, animated: true)
        
        
    }
    
    
    
}

func gettingDate() {
    
    let report = ProductDetailsViewController()
    
     report.getValue()
    
}

extension OffersViewController {
    
   func orderNowBtnAction(_ sender:UIButton){
            print("\(sender.tag)")
            
            let fID = String(sender.tag)
            let featuredProductJobs : CX_FeaturedProductsJobs = (CXDataProvider.sharedInstance.getTheTableDataFromDataBase("CX_FeaturedProductsJobs", predicate: NSPredicate(format: "fID == %@",fID), ispredicate: true, orederByKey: "").dataArray[0] as?CX_FeaturedProductsJobs)!
            let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
            print(featuredProductJobs.json!)
            
            CXDataProvider.sharedInstance.itemAddToWishListOrCarts(featuredProductJobs.json!, itemID: fID, isAddToWishList: false, isAddToCartList: true, isDeleteFromWishList: false, isDeleteFromCartList: false, completionHandler: { (isAdded) in
                
                let cart = storyBoard.instantiateViewController(withIdentifier: "CART") as! CartViewController
                self.navigationController?.pushViewController(cart, animated: true)
            })
            
            
            /*
             let dict = CXDataService.sharedInstance.convertStringToDictionary(featuredProductJobs.json! as String) as NSDictionary
             
             //Trimming Price And Discount
             let floatPrice: Float = Float(CXDataProvider.sharedInstance.getJobID("MRP", inputDic: featuredProductJobs.json!))!
             let finalPrice = String(format: floatPrice == floor(floatPrice) ? "%.0f" : "%.1f", floatPrice)
             
             //let floatDiscount:Float = Float(CXDataProvider.sharedInstance.getJobID("DiscountAmount", inputDic: featuredProductJobs.json!))!
             
             let floatDis = CXDataProvider.sharedInstance.getJobID("DiscountAmount", inputDic: featuredProductJobs.json!)
             
             var floatDiscount:Float = Float()
             
             if floatDis == ""{
             floatDiscount = 0.0
             }
             
             let finalDiscount = String(format: floatDiscount == floor(floatDiscount) ? "%.0f" : "%.1f", floatDiscount)
             
             //FinalPrice after subtracting the discount
             let finalPriceNum:Int! = Int(finalPrice)!-Int(finalDiscount)!
             let FinalPrice = String(finalPriceNum) as String!
             
             let productDetails = storyBoard.instantiateViewController(withIdentifier: "PRODUCT_DETAILS") as! ProductDetailsViewController
             productDetails.productString = featuredProductJobs.json
             self.navigationController?.pushViewController(productDetails, animated: true)
             */
    
    }
}
