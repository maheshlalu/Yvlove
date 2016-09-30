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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.productDetailsTableView.rowHeight = UITableViewAutomaticDimension
        self.productDetailsTableView.estimatedRowHeight = 10.0
        self.productDetailsTableView.separatorStyle = .None
        self.view.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
        print(CXConstant.sharedInstance.convertStringToDictionary(productString))
        productDetailDic = CXConstant.sharedInstance.convertStringToDictionary(productString)
        self.setUpRatingView()
        customisingBtns()
        
        print("\(productDetailDic)")
        /*[createdOn, hrsOfOperation, id, P3rdCategory, Name, Large_Image, publicURL, Current_Job_StatusId, Brand, jobTypeName, Category, Insights, guestUserEmail, Next_Seq_Nos, SubCategoryType, jobComments, PackageName, Image_URL, Current_Job_Status, Next_Job_Statuses, ItemCode, Description, Additional_Details, DiscountAmount, Image_Name, overallRating, CreatedSubJobs, Category_Mall, Quantity, Attachments, MRP, guestUserId, totalReviews, lastModifiedDate, createdByFullName, createdById, CategoryType, jobTypeId]*/
        
    }
    
    func setUpRatingView(){
        //star
        
        // ratingView.emptyImage = UIImage(named: "star.png")
        //ratingView.fullImage = UIImage(named: "star_sel_108.png")
        // Optional params
        //ratingView.delegate = self
        ratingView.contentMode = UIViewContentMode.ScaleAspectFit
        // ratingView.maxRating = 5
        //ratingView.minRating = 0
        //ratingView.rating = 0
        ratingView.editable = false
        ratingView.halfRatings = true
        ratingView.floatRatings = false
        self.ratingBgView.backgroundColor = UIColor.clearColor()
        
    }
    
    func customisingBtns(){
        placeOrderBtn.setTitleColor(CXAppConfig.sharedInstance.getAppTheamColor(), forState: .Normal)
        placeOrderBtn.imageView?.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
        
        addToCartBtn.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
        addToCartBtn.layer.cornerRadius = 2.0
        addToCartBtn.layer.borderColor = UIColor.whiteColor().CGColor
        addToCartBtn.layer.borderWidth = 1.0
        
        //CXConstant.resultString(prod.valueForKey("id")!)
        //productDetailDic.valueForKey("id")! as! String
        if  CXDataProvider.sharedInstance.isAddToCart(CXConstant.resultString(productDetailDic.valueForKey("id")!)).isAddedToCart{
            addToCartBtn.selected = true
        }else{
            addToCartBtn.selected = false
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 4
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return 1
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell: UITableViewCell? = nil
        
        if indexPath.section == 0{
            let imageCellIdentifier = "ImageCell"
            cell = tableView.dequeueReusableCellWithIdentifier(imageCellIdentifier)!
            cell?.selectionStyle = .None
            
            let productImageView = cell!.contentView.viewWithTag(100)! as! UIImageView
            let imgUrl = productDetailDic.valueForKey("Image_URL") as! String
            if (productDetailDic.valueForKey("ShipmentDuration") != nil){
                productImageView.contentMode = UIViewContentMode.ScaleAspectFill
            }else{
                productImageView.contentMode = UIViewContentMode.ScaleAspectFit
            }
            productImageView.sd_setImageWithURL(NSURL(string: imgUrl))
            
        }else if indexPath.section == 1{
            let headerCellIdentifier = "Headercell"
            cell = tableView.dequeueReusableCellWithIdentifier(headerCellIdentifier)!
            cell?.selectionStyle = .None
            
            let finalPriceLbl = (cell!.viewWithTag(200)! as! UILabel)
            let discountPriceLbl = cell?.viewWithTag(300)! as! UILabel
            let discountPersentageLbl = cell?.viewWithTag(400)! as! UILabel
            let favoriteBtn = cell?.viewWithTag(1000)! as! UIButton
            
            if  CXDataProvider.sharedInstance.isAddToCart(CXConstant.resultString(productDetailDic.valueForKey("id")!)).isAddedToWishList{
                favoriteBtn.selected = true
            }else{
                favoriteBtn.selected = false
            }
            
            
            let rupee = "\u{20B9}"
            let price:String = productDetailDic.valueForKey("MRP") as! String
            let discount:String = productDetailDic.valueForKey("DiscountAmount") as! String
            
            if discount == "0"{
                discountPriceLbl.hidden = true
                discountPersentageLbl.hidden = true
                finalPriceLbl.text = "\(rupee) \(price)"
            }else{
                discountPriceLbl.hidden = false
                discountPersentageLbl.hidden = false
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
            cell = tableView.dequeueReusableCellWithIdentifier(productInfoIdentifier)!
            cell?.selectionStyle = .None
            let textView = (cell!.viewWithTag(600)! as! UITextView)
            textView.font = CXAppConfig.sharedInstance.appMediumFont()
            textView.text = "\(productDetailDic.valueForKey("Description")!)"
            cell?.backgroundColor = UIColor.whiteColor()
            
        }else if indexPath.section == 3{
            let footerIdentifier = "FooterCell"
            cell = tableView.dequeueReusableCellWithIdentifier(footerIdentifier)!
            cell?.selectionStyle = .None
            
            if (productDetailDic.valueForKey("ShipmentDuration") != nil){
                
                let shipmentLbl = cell!.viewWithTag(700)! as! UILabel
                shipmentLbl.text = "Shipment Duration"
                
                let shipmentDurationLbl = cell!.viewWithTag(800)! as! UILabel
                shipmentDurationLbl.text = "\(productDetailDic.valueForKey("ShipmentDuration")!) Days"
                
            }else if (productDetailDic.valueForKey("Brand") != nil){
                
                let shipmentLbl = cell!.viewWithTag(700)! as! UILabel
                shipmentLbl.text = "Brand"
                
                let shipmentDurationLbl = cell!.viewWithTag(800)! as! UILabel
                shipmentDurationLbl.text = "\(productDetailDic.valueForKey("Brand")!)"
            }
            
            
        }else if indexPath.section == 4{
            
            let footerIdentifier = "FooterCell2"
            cell = tableView.dequeueReusableCellWithIdentifier(footerIdentifier)!
            cell?.selectionStyle = .None
            let category = productDetailDic.valueForKey("Category") as! String
            if category != ""{
                let category = cell!.viewWithTag(900)! as! UILabel
                category.text = "Category"
                
                let categoryDesc = cell!.viewWithTag(901)! as! UILabel
                categoryDesc.text = "\(productDetailDic.valueForKey("Category")!)"
            }
            
            
        }
        return cell!
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        
        return UITableViewAutomaticDimension
        
    }
    
    @IBAction func addToCartAction(sender: UIButton) {
        if sender.selected {
            //Remove Item
            CXDataProvider.sharedInstance.itemAddToWishListOrCarts(CXConstant.sharedInstance.convertDictionayToString(productDetailDic) as String, itemID: CXConstant.resultString(productDetailDic.valueForKey("id")!), isAddToWishList: false, isAddToCartList: false, isDeleteFromWishList: false, isDeleteFromCartList: true, completionHandler: { (isAdded) in
            })
            
        }else{
            //Add item
            CXDataProvider.sharedInstance.itemAddToWishListOrCarts(CXConstant.sharedInstance.convertDictionayToString(productDetailDic) as String, itemID: CXConstant.resultString(productDetailDic.valueForKey("id")!), isAddToWishList: false, isAddToCartList: true, isDeleteFromWishList: false, isDeleteFromCartList: false, completionHandler: { (isAdded) in
                
            })
        }
        sender.selected = !sender.selected
        
        
    }
    @IBAction func placeOrderNowAction(sender: AnyObject) {
        let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let cart = storyBoard.instantiateViewControllerWithIdentifier("CART") as! CartViewController
        self.navigationController?.pushViewController(cart, animated: true)
    }
    
    @IBAction func heartAction(sender: UIButton) {
        
        if sender.selected {
            //Remove Item
            CXDataProvider.sharedInstance.itemAddToWishListOrCarts(CXConstant.sharedInstance.convertDictionayToString(productDetailDic) as String, itemID: CXConstant.resultString(productDetailDic.valueForKey("id")!), isAddToWishList: false, isAddToCartList: false, isDeleteFromWishList: true, isDeleteFromCartList: false, completionHandler: { (isAdded) in
            })
            
        }else{
            //Add item
            CXDataProvider.sharedInstance.itemAddToWishListOrCarts(CXConstant.sharedInstance.convertDictionayToString(productDetailDic) as String, itemID: CXConstant.resultString(productDetailDic.valueForKey("id")!), isAddToWishList: true, isAddToCartList: false, isDeleteFromWishList: false, isDeleteFromCartList: false, completionHandler: { (isAdded) in
                
            })
        }
        sender.selected = !sender.selected
        
    }
    
    func textViewDidChange(textView: UITextView) {
        let fixedWidth = textView.frame.size.width
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
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
        return productDetailDic.valueForKey("Name")! as! String
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
