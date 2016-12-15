//
//  ProductDetailsViewController.swift
//  NowFloats
//
//  Created by Manishi on 9/9/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit

class ProductDetailsViewController: CXViewController,UITextViewDelegate {
    
    @IBOutlet weak var productDetailsTableView: UITableView!
    var productString : String!
    var productDetailDic:NSDictionary!
    
    @IBOutlet weak var productImgView: UIImageView!
    @IBOutlet weak var placeOrderBtn: UIButton!
    @IBOutlet weak var addToCartBtn: UIButton!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var ratingBgView: UIView!
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var productRattingLbl: UILabel!
    
    let searchQuoteIndex:Int! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.productDetailsTableView.rowHeight = UITableViewAutomaticDimension
        self.productDetailsTableView.estimatedRowHeight = 10.0
        self.productDetailsTableView.separatorStyle = .none
        self.view.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
        productDetailDic = CXConstant.sharedInstance.convertStringToDictionary(productString)
        self.setUpRatingView()
        customisingBtns()
        
        print("\(productDetailDic)")
        
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ProductDetailsViewController.displaySearchResult(_:)), name: "", object: nil)
        /*[createdOn, hrsOfOperation, id, P3rdCategory, Name, Large_Image, publicURL, Current_Job_StatusId, Brand, jobTypeName, Category, Insights, guestUserEmail, Next_Seq_Nos, SubCategoryType, jobComments, PackageName, Image_URL, Current_Job_Status, Next_Job_Statuses, ItemCode, Description, Additional_Details, DiscountAmount, Image_Name, overallRating, CreatedSubJobs, Category_Mall, Quantity, Attachments, MRP, guestUserId, totalReviews, lastModifiedDate, createdByFullName, createdById, CategoryType, jobTypeId]*/
        
    }
    
//    func displaySearchResult(notification:NSNotification){
//    
//        searchQuoteIndex = (notification.object as! NSString).integerValue
//    
//    }
    
    
    
    func setUpRatingView(){
        //star
        
        // ratingView.emptyImage = UIImage(named: "star.png")
        //ratingView.fullImage = UIImage(named: "star_sel_108.png")
        // Optional params
        //ratingView.delegate = self
        ratingView.contentMode = UIViewContentMode.scaleAspectFit
        // ratingView.maxRating = 5
        //ratingView.minRating = 0
        //ratingView.rating = 0
        ratingView.editable = false
        ratingView.halfRatings = true
        ratingView.floatRatings = false
        self.ratingBgView.backgroundColor = UIColor.clear
        
    }
    
    func customisingBtns(){
        placeOrderBtn.setTitleColor(CXAppConfig.sharedInstance.getAppTheamColor(), for: UIControlState())
        placeOrderBtn.imageView?.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
        
        addToCartBtn.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
        addToCartBtn.layer.cornerRadius = 2.0
        addToCartBtn.layer.borderColor = UIColor.white.cgColor
        addToCartBtn.layer.borderWidth = 1.0
        
        //CXConstant.resultString(prod.valueForKey("id")!)
        //productDetailDic.valueForKey("id")! as! String
        if  CXDataProvider.sharedInstance.isAddToCart(CXConstant.resultString(productDetailDic.value(forKey: "id")! as AnyObject) as NSString).isAddedToCart{
            addToCartBtn.isSelected = true
        }else{
            addToCartBtn.isSelected = false
        }
    }
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int
    {
        return 4
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return 1
        
    }
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell
    {
        var cell: UITableViewCell? = nil
        
        if indexPath.section == 0{
            let imageCellIdentifier = "ImageCell"
            cell = tableView.dequeueReusableCell(withIdentifier: imageCellIdentifier)!
            cell?.selectionStyle = .none
            
            let productImageView = cell!.contentView.viewWithTag(100)! as! UIImageView
            let imgUrl = productDetailDic.value(forKey: "Image_URL") as! String
            if (productDetailDic.value(forKey: "ShipmentDuration") != nil){
                productImageView.contentMode = UIViewContentMode.scaleAspectFill
            }else{
                productImageView.contentMode = UIViewContentMode.scaleAspectFit
            }
            productImageView.sd_setImage(with: URL(string: imgUrl))
            
        }else if indexPath.section == 1{
            let headerCellIdentifier = "Headercell"
            cell = tableView.dequeueReusableCell(withIdentifier: headerCellIdentifier)!
            cell?.selectionStyle = .none
            
            let finalPriceLbl = (cell!.viewWithTag(200)! as! UILabel)
            let discountPriceLbl = cell?.viewWithTag(300)! as! UILabel
            let discountPersentageLbl = cell?.viewWithTag(400)! as! UILabel
            let favoriteBtn = cell?.viewWithTag(1000)! as! UIButton
            
            if  CXDataProvider.sharedInstance.isAddToCart(CXConstant.resultString(productDetailDic.value(forKey: "id")! as AnyObject) as NSString).isAddedToWishList{
                favoriteBtn.isSelected = true
            }else{
                favoriteBtn.isSelected = false
            }
            
            
            let rupee = "\u{20B9}"
            let price:String = productDetailDic.value(forKey: "MRP") as! String
            let discount:String = productDetailDic.value(forKey: "DiscountAmount") as! String
            
            if discount == "0"{
                discountPriceLbl.isHidden = true
                discountPersentageLbl.isHidden = true
                finalPriceLbl.text = "\(rupee) \(price)"
            }else{
                discountPriceLbl.isHidden = false
                discountPersentageLbl.isHidden = false
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "\(rupee) \(price)")
                attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 1, range: NSMakeRange(0, attributeString.length))
                discountPriceLbl.attributedText = attributeString
                
                
                let finalPriceNum:Int = Int(price)!-Int(discount)!
                finalPriceLbl.text = "\(rupee) \(String(finalPriceNum))"
                
                let discountPrice: Float = Float(discount)!
                let actualPrice: Float = Float(price)!
                let perCent = 100*(discountPrice/actualPrice)
                let perCentCGFloat =  Int(floor(CGFloat(perCent)))
                discountPersentageLbl.text = "\(perCentCGFloat)%"
            }
            
        }else if indexPath.section == 2{
            let productInfoIdentifier = "ProductInfoCell"
            cell = tableView.dequeueReusableCell(withIdentifier: productInfoIdentifier)!
            cell?.selectionStyle = .none
            let textView = (cell!.viewWithTag(600)! as! UITextView)
            textView.font = CXAppConfig.sharedInstance.appMediumFont()
            textView.text = "\(productDetailDic.value(forKey: "Description")!)"
            cell?.backgroundColor = UIColor.white
            
        }else if indexPath.section == 3{
            let footerIdentifier = "FooterCell"
            cell = tableView.dequeueReusableCell(withIdentifier: footerIdentifier)!
            cell?.selectionStyle = .none
            
            if (productDetailDic.value(forKey: "ShipmentDuration") != nil){
                
                let shipmentLbl = cell!.viewWithTag(700)! as! UILabel
                shipmentLbl.text = "Shipment Duration"
                
                let shipmentDurationLbl = cell!.viewWithTag(800)! as! UILabel
                shipmentDurationLbl.text = "\(productDetailDic.value(forKey: "ShipmentDuration")!) Days"
                
            }else if (productDetailDic.value(forKey: "Brand") != nil){
                
                let shipmentLbl = cell!.viewWithTag(700)! as! UILabel
                shipmentLbl.text = "Brand"
                
                let shipmentDurationLbl = cell!.viewWithTag(800)! as! UILabel
                shipmentDurationLbl.text = "\(productDetailDic.value(forKey: "Brand")!)"
            }
            
            
        }else if indexPath.section == 4{
            
            let footerIdentifier = "FooterCell2"
            cell = tableView.dequeueReusableCell(withIdentifier: footerIdentifier)!
            cell?.selectionStyle = .none
            let category = productDetailDic.value(forKey: "Category") as! String
            if category != ""{
                let category = cell!.viewWithTag(900)! as! UILabel
                category.text = "Category"
                
                let categoryDesc = cell!.viewWithTag(901)! as! UILabel
                categoryDesc.text = "\(productDetailDic.value(forKey: "Category")!)"
            }

        }
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: IndexPath) -> CGFloat
    {
        
        return UITableViewAutomaticDimension
        
    }
    
    @IBAction func addToCartAction(_ sender: UIButton) {
        if sender.isSelected {
            //Remove Item
            CXDataProvider.sharedInstance.itemAddToWishListOrCarts(CXConstant.sharedInstance.convertDictionayToString(productDetailDic) as String, itemID: CXConstant.resultString(productDetailDic.value(forKey: "id")! as AnyObject), isAddToWishList: false, isAddToCartList: false, isDeleteFromWishList: false, isDeleteFromCartList: true, completionHandler: { (isAdded) in
            })
            
        }else{
            //Add item
            CXDataProvider.sharedInstance.itemAddToWishListOrCarts(CXConstant.sharedInstance.convertDictionayToString(productDetailDic) as String, itemID: CXConstant.resultString(productDetailDic.value(forKey: "id")! as AnyObject), isAddToWishList: false, isAddToCartList: true, isDeleteFromWishList: false, isDeleteFromCartList: false, completionHandler: { (isAdded) in
                
            })
        }
        sender.isSelected = !sender.isSelected
        
        
    }
    @IBAction func placeOrderNowAction(_ sender: AnyObject) {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let cart = storyBoard.instantiateViewController(withIdentifier: "CART") as! CartViewController
        self.navigationController?.pushViewController(cart, animated: true)
    }
    
    @IBAction func heartAction(_ sender: UIButton) {
        
        if sender.isSelected {
            //Remove Item
            CXDataProvider.sharedInstance.itemAddToWishListOrCarts(CXConstant.sharedInstance.convertDictionayToString(productDetailDic) as String, itemID: CXConstant.resultString(productDetailDic.value(forKey: "id")! as AnyObject), isAddToWishList: false, isAddToCartList: false, isDeleteFromWishList: true, isDeleteFromCartList: false, completionHandler: { (isAdded) in
            })
            
        }else{
            //Add item
            CXDataProvider.sharedInstance.itemAddToWishListOrCarts(CXConstant.sharedInstance.convertDictionayToString(productDetailDic) as String, itemID: CXConstant.resultString(productDetailDic.value(forKey: "id")! as AnyObject), isAddToWishList: true, isAddToCartList: false, isDeleteFromWishList: false, isDeleteFromCartList: false, completionHandler: { (isAdded) in
                
            })
        }
        sender.isSelected = !sender.isSelected
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let fixedWidth = textView.frame.size.width
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = textView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        textView.frame = newFrame;
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
        return productDetailDic.value(forKey: "Name")! as! String
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
