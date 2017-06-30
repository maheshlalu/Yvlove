//
//  ProductDetailsViewController.swift
//  NowFloats
//
//  Created by Manishi on 9/9/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit

class ProductDetailsViewController: CXViewController,UITextViewDelegate,FloatRatingViewDelegate {
    
    
    @IBOutlet weak var productDetailsTableView: UITableView!
    var productString : String!
    var productDetailDic: NSDictionary!
    var descriptionTagsArr:NSMutableArray = NSMutableArray()
    var descriptionTagsDescArr:NSMutableArray = NSMutableArray()
    
    @IBOutlet weak var placeOrderBtn: UIButton!
    @IBOutlet weak var addToCartBtn: UIButton!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var ratingBgView: UIView!
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var productRattingLbl: UILabel!
    @IBOutlet weak var needMoreInfoBtn: UIButton!
    
    var isMRP = Bool()
    var isLink = Bool()
    
    let searchQuoteIndex:Int! = nil
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.productDetailsTableView.rowHeight = UITableViewAutomaticDimension
        self.productDetailsTableView.estimatedRowHeight = 10.0
        self.productDetailsTableView.separatorStyle = .none
        self.view.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
        productDetailDic = CXConstant.sharedInstance.convertStringToDictionary(productString)
        print(productDetailDic)
        
        self.productDetailsTableView?.register(UINib(nibName: "NeedyBeeDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "NeedyBeeDetailTableViewCell")
        setUpRatingView()
        customisingBtns()
        getDescriptionTags()
        self.ratingBgView.backgroundColor = UIColor.clear
        //self.ratingView.backgroundColor = UIColor.white
        
    }
    
    func getDescriptionTags(){
        
        if productDetailDic.value(forKey: "Name") as! String != ""{
            descriptionTagsArr.add("Name")
            descriptionTagsDescArr.add("Name")
        }
        
        if productDetailDic.value(forKey: "Description") as! String != ""{
            descriptionTagsArr.add("Description")
            descriptionTagsDescArr.add("Description")
        }
        //        if productDetailDic.value(forKey: "Widget_Type") as! String != ""{
        //            descriptionTagsArr.add("Widget_Type")
        //            descriptionTagsDescArr.add("Widget_Type")
        //        }
        
        //        if productDetailDic.value(forKey: "overallRating") as! String != ""{
        //            descriptionTagsArr.add("overallRating")
        //            descriptionTagsDescArr.add("overallRating")
        //        }
        
        //        if productDetailDic.value(forKey: "DiscountAmount") as! String != ""{
        //            descriptionTagsArr.add("DiscountAmount")
        //            descriptionTagsDescArr.add("DiscountAmount")
        //        }
        //
        //        if productDetailDic.value(forKey: "totalReviews") as! String != ""{
        //            descriptionTagsArr.add("totalReviews")
        //            descriptionTagsDescArr.add("totalReviews")
        //        }
        //
        //        if productDetailDic.value(forKey: "color") as! String != ""{
        //            descriptionTagsArr.add("Color")
        //            descriptionTagsDescArr.add("color")
        //        }
        //
        //        if productDetailDic.value(forKey: "weight") as! String != ""{
        //            descriptionTagsArr.add("Weight")
        //            descriptionTagsDescArr.add("weight")
        //        }
        //
        //        if productDetailDic.value(forKey: "recommended_age") as! String != ""{
        //            descriptionTagsArr.add("Recommended Age")
        //            descriptionTagsDescArr.add("recommended_age")
        //        }
    }
    
    func setUpRatingView(){
        self.ratingView.contentMode = UIViewContentMode.scaleAspectFit
        ratingView.delegate = self
        ratingView.editable = true
        ratingView.halfRatings = true
        ratingView.floatRatings = false
        self.ratingBgView.backgroundColor = UIColor.clear
        //        self.ratingView.backgroundColor = UIColor.clear
        //        self.ratingView.editable = false
    }
    
    //   func setUpRatingView(){
    ////
    ////
    //          //self.ratingView.delegate = self
    ////
    ////        ratingView.contentMode = UIViewContentMode.scaleAspectFit
    ////        ratingView.editable = true
    ////        ratingView.maxRating = 5
    ////        ratingView.minRating = 1
    ////        ratingView.rating = 2.5
    ////        ratingView.isUserInteractionEnabled = true
    ////        ratingView.backgroundColor = UIColor.white
    ////        ratingView.halfRatings = false
    ////        ratingView.floatRatings = true
    //////
    ////////        ratingView.contentMode = UIViewContentMode.scaleAspectFit
    ////////        ratingView.editable = false
    ////////        ratingView.halfRatings = true
    ////////        ratingView.floatRatings = false
    //
    //
    //        self.ratingBgView.backgroundColor = UIColor.clear
    //  }
    
    func customisingBtns(){
        
        placeOrderBtn.setTitleColor(CXAppConfig.sharedInstance.getAppTheamColor(), for: UIControlState())
        placeOrderBtn.imageView?.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
        
        addToCartBtn.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
        addToCartBtn.layer.cornerRadius = 2.0
        addToCartBtn.layer.borderColor = UIColor.white.cgColor
        addToCartBtn.layer.borderWidth = 1.0
        
        needMoreInfoBtn.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
        needMoreInfoBtn.layer.cornerRadius = 2.0
        needMoreInfoBtn.layer.borderColor = UIColor.white.cgColor
        needMoreInfoBtn.layer.borderWidth = 1.0
        
        if CXDataProvider.sharedInstance.isAddToCart(CXConstant.resultString(productDetailDic.value(forKey: "id")! as AnyObject) as NSString).isAddedToCart{
            addToCartBtn.isSelected = true
        }else{
            addToCartBtn.isSelected = false
        }
        
        
        /*
         //MRP is False and Link is False
         if !isMRP && !isLink {
         
         needMoreInfoBtn.isHidden = false
         placeOrderBtn.isHidden = true
         addToCartBtn.isHidden = true
         needMoreInfoBtn.setTitle("Ask For A Quote", for: .normal)
         needMoreInfoBtn.titleLabel?.font = UIFont(name: "Roboto-Regular", size:13)
         needMoreInfoBtn.setImage(nil, for: .normal)
         
         //MRP is False and Link is True
         }else if !isMRP && isLink {
         placeOrderBtn.isHidden = true
         needMoreInfoBtn.isHidden = false
         addToCartBtn.isHidden = false
         needMoreInfoBtn.setTitle("Need More Info", for: .normal)
         needMoreInfoBtn.titleLabel?.font = UIFont(name: "Roboto-Regular", size:13)
         needMoreInfoBtn.setImage(nil, for: .normal)
         addToCartBtn.setTitle("Proceed To Online Store", for: .normal)
         addToCartBtn.titleLabel?.font = UIFont(name: "Roboto-Regular", size:13)
         addToCartBtn.setImage(nil, for: .normal)
         
         //MRP is True and Link is True
         }else if isMRP && isLink {
         placeOrderBtn.isHidden = false
         needMoreInfoBtn.isHidden = false
         addToCartBtn.isHidden = false
         needMoreInfoBtn.setTitle("Need More Info", for: .normal)
         needMoreInfoBtn.titleLabel?.font = UIFont(name: "Roboto-Regular", size:13)
         needMoreInfoBtn.setImage(nil, for: .normal)
         }
         */
        
    }
    
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int{
        return 2 + descriptionTagsArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell{
        var cell: UITableViewCell? = nil
        let needyBeeDetailCell:NeedyBeeDetailTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "NeedyBeeDetailTableViewCell") as? NeedyBeeDetailTableViewCell
        
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
            discountPriceLbl.textColor = CXAppConfig.sharedInstance.getAppTheamColor()
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
            if price == "0"{
                discountPriceLbl.isHidden = true
                discountPersentageLbl.isHidden = true
                finalPriceLbl.isHidden = true
            }else{
                finalPriceLbl.isHidden = false
                discountPriceLbl.isHidden = false
                discountPersentageLbl.isHidden = false
                finalPriceLbl.text = "\(rupee) \(price)"
            }
            
            if discount == "0" || discount == "" {
                discountPriceLbl.isHidden = true
                discountPersentageLbl.isHidden = true
                finalPriceLbl.text = "\(rupee) \(price)"
            }else{
                discountPriceLbl.isHidden = false
                discountPersentageLbl.isHidden = false
                let attributeString: NSMutableAttributedString! =  NSMutableAttributedString(string: price)
                attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 1, range: NSMakeRange(0, attributeString.length))
                discountPriceLbl.attributedText = attributeString
                
                var finalPriceNum:Int = Int()
                var discountPrice: Float = Float()
                if discount == ""{
                    finalPriceNum = Int(price)!
                }else{
                    finalPriceNum = Int(price)!-Int(discount)!
                    discountPrice = Float(discount)!
                }
                finalPriceLbl.text = "\(rupee) \(String(finalPriceNum))"
                let actualPrice: Float = Float(price)!
                let perCent = 100*(discountPrice/actualPrice)
                let perCentCGFloat =  Int(floor(CGFloat(perCent)))
                discountPersentageLbl.text = "\(perCentCGFloat)%"
            }
            
        }else{
            needyBeeDetailCell.titleLbl.text = descriptionTagsArr[indexPath.section - 2] as? String
            let str = productDetailDic.value(forKey: descriptionTagsDescArr[indexPath.section - 2] as! String) as? String
            let desclimeStr = str?.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            needyBeeDetailCell.decriptionLbl.text = desclimeStr
            return needyBeeDetailCell
        }
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat{
        if indexPath.section == 1{
            return 62
        }else{
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: IndexPath) -> CGFloat{
        if indexPath.section == 1{
            return 62
        }else{
            return UITableViewAutomaticDimension
        }
    }
    
    @IBAction func addToCartAction(_ sender: UIButton) {
        
        if addToCartBtn.titleLabel?.text == "Proceed To Online Store"{
            
            let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let online = storyBoard.instantiateViewController(withIdentifier: "BuyOnlineWebViewController") as! BuyOnlineWebViewController
            online.url = productDetailDic.value(forKey: "BuyOnlineLink") as! String!
            online.productName = productDetailDic.value(forKey: "Name") as! String!
            self.navigationController?.pushViewController(online, animated: true)
            
        }else{
            
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
    }
    @IBAction func placeOrderNowAction(_ sender: AnyObject) {
        
        //        if UserDefaults.standard.value(forKey: "USER_EMAIL") == nil
        //        {
        //            let name = CXSignInSignUpViewController()
        //            self.navigationController?.pushViewController(name, animated: true)
        //        }
        
        getValue()
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let cart = storyBoard.instantiateViewController(withIdentifier: "CART") as! CartViewController
        self.navigationController?.pushViewController(cart, animated: true)
        
    }
    
    func getValue() {
        CXDataProvider.sharedInstance.itemAddToWishListOrCarts(productString, itemID: CXConstant.resultString(productDetailDic.value(forKey: "id")! as AnyObject), isAddToWishList: false, isAddToCartList: true, isDeleteFromWishList: false, isDeleteFromCartList: false, completionHandler: { (isAdded) in
            
        })
        
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
    
    @IBAction func needMoreAction(_ sender: Any) {
        if UserDefaults.standard.value(forKey: "USER_ID") == nil{
            let signInViewCnt : CXSignInSignUpViewController = CXSignInSignUpViewController()
            self.navigationController?.pushViewController(signInViewCnt, animated: true)
            return
            
        }else{
            let popup = PopupController
                .create(self)
                .customize(
                    [
                        .animation(.slideUp),
                        .scrollable(false),
                        .layout(.center),
                        .backgroundStyle(.blackFilter(alpha: 0.7))
                    ]
                )
                .didShowHandler { popup in
                    
                }
                .didCloseHandler { _ in
            }
            let container = InfoQueryViewController.instance()
            
            if (sender as! UIButton).titleLabel?.text == "Need More Info" {
                container.textViewString = "Hi, I am interested in \"\(productDetailDic.value(forKey: "Name") as! String)\" and need more information on the same. Please contact me."
            }
            
            container.closeHandler = { _ in
                popup.dismiss()
            }
            popup.show(container)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let fixedWidth = textView.frame.size.width
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = textView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        textView.frame = newFrame;
    }
    
    // MARK: FloatRatingViewDelegate
    //    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float)
    //    {
    //
    //        self.productRattingLbl.text = NSString(format: "%.2f", self.ratingView.rating) as String
    //
    //    }
    //    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Float){
    //        self.productRattingLbl.text = NSString(format: "%.2f", self.ratingView.rating) as String
    //
    //
    //        self.setUpRatingView()
    //    }
    
    
    
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating:Float) {
        self.productRattingLbl.text = NSString(format: "%.2f", ratingView.rating) as String
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float) {
        self.productRattingLbl.text = NSString(format: "%.2f", ratingView.rating) as String
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
    
    //MARK : ViewWillAppera
    override func viewWillAppear(_ animated: Bool) {
        
        if CXDataProvider.sharedInstance.isAddToCart(CXConstant.resultString(productDetailDic.value(forKey: "id")! as AnyObject) as NSString).isAddedToCart{
            addToCartBtn.isSelected = true
        }else{
            addToCartBtn.isSelected = false
        }
        super.viewWillAppear(animated)
    }
}
