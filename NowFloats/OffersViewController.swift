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
    override func viewDidLoad() {
        super.viewDidLoad()
        CXAppDataManager.sharedInstance.getTheFeaturedProduct()
        CXAppConfig.sharedInstance.getAppBGColor()
        self.registerTableViewCell()
        self.getTheProducts()
        // Do any additional setup after loading the view.
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


}

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
        
        return 3
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
        feturedProuctsCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        feturedProuctsCell.detailCollectionView.allowsSelection = true
        feturedProuctsCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
        return feturedProuctsCell
        
    }
    
    
    /*func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 200
        }else {
            
        }
        return 150
    }
    */
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CXConstant.tableViewHeigh - 25;
    }
}

extension OffersViewController : UICollectionViewDataSource,UICollectionViewDelegate{
    
    func collectionView(collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        let cell: UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseCollectionViewCellIdentifier, forIndexPath: indexPath)
//        //let collectionViewArray = sourceArray[collectionView.tag] as! Array<AnyObject>
//        cell.backgroundColor = UIColor.blueColor()
//        return cell
//        
        let identifier = "OfferCollectionViewCell"
        let cell: OfferCollectionViewCell! = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as?OfferCollectionViewCell
        if cell == nil {
            collectionView.registerNib(UINib(nibName: "OfferCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: identifier)
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
        
        return productModelData
        
    }
    func constructTheProductsForPager(){
    }
}
