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

class OffersViewController: UIViewController {

    @IBOutlet weak var offersTableView: UITableView!
    @IBOutlet weak var productsSearchBar: UISearchBar!
    var products : NSArray! = nil
    var storedOffsets = [Int: CGFloat]()
    var featureProducts: NSArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(colorLiteralRed: 207.0/255.0, green: 206.0/255.0, blue: 207.0/255.0, alpha: 1)
        self.featureProducts = CXDataProvider.sharedInstance.getTheTableDataFromDataBase("CX_FeaturedProducts", predicate: NSPredicate(), ispredicate: false, orederByKey: "fID").dataArray
        CXAppConfig.sharedInstance.getAppBGColor()
        self.registerTableViewCell()
        self.getTheProducts()
   
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getTheProducts(){
        let fetchRequest : NSFetchRequest = NSFetchRequest(entityName: "CX_Products")
         self.products  = CX_Products.MR_executeFetchRequest(fetchRequest)
        self.offersTableView.reloadData()
    }


}
// CXDataProvider.sharedInstance.getTheTableDataFromDataBase("CX_FeaturedProducts", predicate: NSPredicate(), ispredicate: false)
//MARK: Featured Product Tableview

extension OffersViewController{
    
    func registerTableViewCell(){
        self.offersTableView.backgroundColor = UIColor.clearColor()
        self.offersTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.offersTableView.contentInset = UIEdgeInsetsMake(0, 0,30, 0)
        self.offersTableView.rowHeight = UITableViewAutomaticDimension
        self.offersTableView.showsVerticalScrollIndicator = false
        self.offersTableView.scrollEnabled = true

    }

}

extension OffersViewController : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return featureProducts.count+1
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        if indexPath.section == 0 {
            return self.pagerCell(tableView, indexPath: indexPath ,reuseIdentFier: "PAGER")
        }else {
            
            return self.featureProuctsCell(tableView, indexPath: indexPath, reuseIdentFier: reuseTableViewCellIdentifier)
        }
        
        return UITableViewCell()
    }
    
    
    func pagerCell(tableView: UITableView,indexPath: NSIndexPath,reuseIdentFier : String) -> UITableViewCell{
        
        tableView.registerNib(UINib(nibName: "OfferPagerCelll", bundle: nil), forCellReuseIdentifier: reuseIdentFier)
        let pagerCell = tableView.dequeueReusableCellWithIdentifier(reuseIdentFier , forIndexPath: indexPath) as! OfferPagerCelll
        pagerCell.pagerView.delegate = self
        pagerCell.pagerView.dataSource = self
        
        if CXAppConfig.sharedInstance.ispagerEnable() {
            pagerCell.pagerView.slideshowTimeInterval = 2
        }else{
            pagerCell.pagerView.slideshowTimeInterval = 0
        }
        return pagerCell
    }
    
    
    func featureProuctsCell(tableView: UITableView,indexPath: NSIndexPath,reuseIdentFier : String) -> UITableViewCell{
        
        
        var feturedProuctsCell: OfferFeaturedProductCell! = tableView.dequeueReusableCellWithIdentifier(reuseIdentFier) as? OfferFeaturedProductCell
        if feturedProuctsCell == nil {
            tableView.registerNib(UINib(nibName: "OfferFeaturedProductCell", bundle: nil), forCellReuseIdentifier: reuseIdentFier)
            feturedProuctsCell = tableView.dequeueReusableCellWithIdentifier(reuseIdentFier) as? OfferFeaturedProductCell
        }
        feturedProuctsCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.section-1)
        print("indext path tag \(indexPath.section)")
        //feturedProuctsCell.detailCollectionView.tag = indexPath.section
        feturedProuctsCell.detailCollectionView.allowsSelection = true
        let featureProducts : CX_FeaturedProducts =  (self.featureProducts[indexPath.section-1] as? CX_FeaturedProducts)!
        feturedProuctsCell.headerLbl.text = featureProducts.name
        feturedProuctsCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
        
        return feturedProuctsCell
        
    }
    
//    
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
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0{
            return CXConstant.tableViewHeigh - 75;
        }else if indexPath.section == 2{
            return CXConstant.tableViewHeigh - 5;
        }else{
            return CXConstant.tableViewHeigh - 25;
        }
    }
}


extension OffersViewController : UICollectionViewDataSource,UICollectionViewDelegate{
    
    func collectionView(collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        let featureProducts : CX_FeaturedProducts =  (self.featureProducts[collectionView.tag] as? CX_FeaturedProducts)!
 
        return CXDataProvider.sharedInstance.getTheTableDataFromDataBase("CX_FeaturedProductsJobs", predicate: NSPredicate(format: "parentID == %@",featureProducts.fID!), ispredicate: true, orederByKey: "").totalCount
    
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let featureProducts : CX_FeaturedProducts =  (self.featureProducts[collectionView.tag] as? CX_FeaturedProducts)!
        let featuredProductJobs : CX_FeaturedProductsJobs = (CXDataProvider.sharedInstance.getTheTableDataFromDataBase("CX_FeaturedProductsJobs", predicate: NSPredicate(format: "parentID == %@",featureProducts.fID!), ispredicate: true, orederByKey: "").dataArray[indexPath.row] as?CX_FeaturedProductsJobs)!
        
        let identifier = "OfferCollectionViewCell"
        let cell: OfferCollectionViewCell! = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as?OfferCollectionViewCell
        if cell == nil {
            collectionView.registerNib(UINib(nibName: "OfferCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: identifier)
        }
        
        cell.productName.text = featuredProductJobs.name
        cell.productImageView.sd_setImageWithURL(NSURL(string:featuredProductJobs.image_URL!)!)
        
        if featuredProductJobs.fDescription != nil{
            
            let rupee = "\u{20B9}"
            let price:String = CXDataProvider.sharedInstance.getJobID("MRP", inputDic: featuredProductJobs.json!)
            let discount:String = CXDataProvider.sharedInstance.getJobID("DiscountAmount", inputDic: featuredProductJobs.json!)
  
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "\(price)")
            attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length))
            cell.productPriceLbl.attributedText = attributeString
            
            
            let finalPriceNum:Int = Int(price)!-Int(discount)!
            cell.finalPriceLbl.text = "\(rupee) \(String(finalPriceNum))"
        }

        if featureProducts.name == "Brands"{
            cell.productPriceLbl.hidden = true
            cell.finalPriceLbl.hidden = true
            cell.orderNowBtn.hidden = true
            
        }

        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        // Set cell width to 100%

            return CXConstant.DetailCollectionCellSize
    }
    
    
    
}

//MARK: KIPager Delegate and Datasorce

extension OffersViewController : KIImagePagerDelegate,KIImagePagerDataSource {
    
    func arrayWithImages(pager: KIImagePager!) -> [AnyObject]! {
        
        return ["","","","",""]
    }
    
    func contentModeForImage(image: UInt, inPager pager: KIImagePager!) -> UIViewContentMode {
        
        
        return .Center
    }
    func populateTheProductData(index: UInt, inPager pager: KIImagePager!) -> ProductModelClass! {
        let productData : CX_Products = self.products.objectAtIndex(Int(index)) as! CX_Products
        let productModelData : ProductModelClass = ProductModelClass.init()
        productModelData.productName = productData.name
        productModelData.productimage = productData.imageUrl;
        //  productModelData.productimage = productData.name
        productModelData.productSubTitle = productData.name
        pager.pagerView.productNameLbl.font = CXAppConfig.sharedInstance.appLargeFont()
        pager.pagerView.orederNowBtn.setTitleColor(CXAppConfig.sharedInstance.getAppTheamColor(), forState: .Normal)
        pager.pagerView.orederNowBtn.titleLabel?.font = CXAppConfig.sharedInstance.appMediumFont()
        pager.indicatorDisabled = false
        
        pager.pageControl.currentPageIndicatorTintColor = CXAppConfig.sharedInstance.getAppTheamColor()
        pager.pageControl.pageIndicatorTintColor = UIColor.grayColor();
        
        return productModelData
        
    }
    
}
