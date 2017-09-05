//
//  CXCampaignDetailViewController.swift
//  NowFloats
//
//  Created by Rama on 04/09/17.
//  Copyright © 2017 CX. All rights reserved.
//

import UIKit

class CXCampaignDetailViewController: CXViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

    @IBOutlet var campaignDetailCollectionView: UICollectionView!
     var products =  NSMutableArray()
     var FinalPrice:String! = nil
     var arrAdditinalCategery = NSMutableArray()
     var prefferedJodIdsStr = String()
     var productString : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "ProductsCollectionViewCell", bundle: nil)
        self.campaignDetailCollectionView.register(nib, forCellWithReuseIdentifier: "ProductsCollectionViewCell")
        // Do any additional setup after loading the view.
        getMatchedProducts()
    }
    
  
   
    func getMatchedProducts(){
         print("jobs== \(String(describing: self.prefferedJodIdsStr))")
         //http://storeongo.com:8081/Services/getMasters?PrefferedJobs=49856_49855_49854_49851_49850_49849_49830&mallId=4724
        CXDataService.sharedInstance.getTheAppDataFromServer(["PrefferedJobs":self.prefferedJodIdsStr as AnyObject,"mallId":CXAppConfig.sharedInstance.getAppMallID() as AnyObject]) { (responseDict) in
            print(responseDict)
            
            let jobs : NSArray =  responseDict.value(forKey: "jobs")! as! NSArray
            
            if jobs.count == 0{
            }
            
            CXDataProvider.sharedInstance.saveTheProducts(responseDict, completion: { (responce) in
                let jobIDPreffArr = self.prefferedJodIdsStr.components(separatedBy: "_") as NSArray
                print("campjobs== \(String(describing: jobIDPreffArr))")
               
                for productID  in jobIDPreffArr {
                    
                    let predicate = NSPredicate.init(format: "pid=%@",String(describing: productID))
                    let cartlist : NSArray =  CX_Products.mr_findAll(with: predicate) as NSArray
                    if cartlist.count != 0 {
                        let product : CX_Products = (cartlist.firstObject as? CX_Products)!
                        self.products.add(product)
                    }
                    
                }
                self.campaignDetailCollectionView.reloadData()

            })
           
        }
       // let searchPredicate = NSPredicate(format: "SUBQUERY(arr.uid, $x, $x IN %@).@count = %d", ids, ids.count)

        //,49855,49854,49851,49850,49849,49830
        
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return products.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductsCollectionViewCell", for: indexPath as IndexPath)as! ProductsCollectionViewCell
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
        if products.imageUrl != nil{
            cell.produstimageview.setImageWith(URL(string: products.imageUrl!), usingActivityIndicatorStyle: .gray)
        }else{
        }
        
        let rupee = "\u{20B9}"
        
        //Trimming Price And Discount
        let floatPrice: Float = Float(CXDataProvider.sharedInstance.getJobID("MRP", inputDic: products.json!))!
        let finalPrice = String(format: floatPrice == floor(floatPrice) ? "%.0f" : "%.1f", floatPrice)
        
        let floatDiscount:Float = Float(CXDataProvider.sharedInstance.getJobID("DiscountAmount", inputDic: products.json!))!
        let finalDiscount = String(format: floatDiscount == floor(floatDiscount) ? "%.0f" : "%.1f", floatDiscount)
        //Setting AttributedPrice
        let attributeString: NSMutableAttributedString! =  NSMutableAttributedString(string: finalPrice)
        attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length))
        
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
        return cell
    }
    
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (campaignDetailCollectionView.bounds.size.width)/2-8, height: 222)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
       // self.viewAdditinalCategery.isHidden = true
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let products:CX_Products = (self.products[indexPath.item] as? CX_Products)!
        
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
        
        
        productDetails.isMRP = mrp
        productDetails.isLink = link
        self.navigationController?.pushViewController(productDetails, animated: true)
       
    }
    
    
    
    
    
    //MARK: Addtinal Data Tableview Delegate & Data Sources Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrAdditinalCategery.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        let subDict = self.arrAdditinalCategery.object(at: indexPath.row) as! NSDictionary
        cell.textLabel?.text = subDict.value(forKey: "Name") as? String
        // cell.textLabel?.text = self.arrAdditinalCategery.object(at: indexPath.row) as? String
        return cell
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: .zero)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
               
        let subDict = self.arrAdditinalCategery.object(at: indexPath.row) as! NSDictionary
        let name = subDict.value(forKey: "Name") as! String
       // self.callAddtinalCategerySevice(str: name)
        LoadingView.show("Loading", animated: true)
        //self.present(navController, animated: true, completion: nil)
        
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
    //MAR:Heder options enable
    override  func shouldShowRightMenu() -> Bool{
        return true
    }
    
    override func shouldShowNotificatoinBell() ->Bool{
        return true
    }
    
    override  func shouldShowCart() -> Bool{
        return true
    }
    
    override func headerTitleText() -> String{
        return productString
    }
    
    override func shouldShowLeftMenu() -> Bool{
        return false
    }
    
    override func shouldShowLeftMenuWithLogo() -> Bool{
        return false
    }
    
    override func showLogoForAboutUs() -> Bool{
        return false
    }
    
    override func profileDropdown() -> Bool{
        return false
    }
    
    override func profileDropdownForSignIn() -> Bool{
        return false
    }

    
}
//Cart and Wishlist functios
extension CXCampaignDetailViewController {
    
    func productAddedToCart(_ sender:UIButton){
        
        let proListData : CX_Products = self.products[sender.tag-1] as! CX_Products
        let indexPath = IndexPath(row: sender.tag-1, section: 0)
        
        if sender.isSelected {
            //Remove Item From Cart
            CXDataProvider.sharedInstance.itemAddToWishListOrCarts(proListData.json!, itemID: proListData.pid!, isAddToWishList: false, isAddToCartList: false, isDeleteFromWishList: false, isDeleteFromCartList: true, completionHandler: { (isAdded) in
                //self.updatecollectionview.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                self.campaignDetailCollectionView.reloadItems(at: [indexPath])
            })
            
        }else{
            
            CXDataProvider.sharedInstance.itemAddToWishListOrCarts(proListData.json!, itemID: proListData.pid!, isAddToWishList: false, isAddToCartList: true, isDeleteFromWishList: false, isDeleteFromCartList: false, completionHandler: { (isAdded) in
                self.campaignDetailCollectionView.reloadItems(at: [indexPath])
                
            })
        }
        
    }
    
    func productAddedToWishList(_ sender:UIButton){
        
        let proListData : CX_Products = self.products[sender.tag-1] as! CX_Products
        let indexPath = IndexPath(row: sender.tag-1, section: 0)
        
        if sender.isSelected {
            //Remove Item From WishList
            
            CXDataProvider.sharedInstance.itemAddToWishListOrCarts(proListData.json!, itemID: proListData.pid!, isAddToWishList: false, isAddToCartList: false, isDeleteFromWishList: true, isDeleteFromCartList: false, completionHandler: { (isAdded) in
            self.campaignDetailCollectionView.reloadItems(at: [indexPath])
            })
            
        }else{
            
            //Add Item to WishList
            
            CXDataProvider.sharedInstance.itemAddToWishListOrCarts(proListData.json!, itemID: proListData.pid!, isAddToWishList: true, isAddToCartList: false, isDeleteFromWishList: false, isDeleteFromCartList: false, completionHandler: { (isAdded) in
                self.campaignDetailCollectionView.reloadItems(at: [indexPath])
                
            })
        }
    }
}
