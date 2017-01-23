//
//  ViewController.swift
//  Nowfloatwishlist
//
//  Created by apple on 13/09/16.
//  Copyright © 2016 apple. All rights reserved.
//

import UIKit

class NowfloatWishlistViewController: CXViewController,UICollectionViewDataSource,UICollectionViewDelegate{
    @IBOutlet weak var emptyWishlistLbl: UILabel!
    
    @IBOutlet var wishlistcollectionView: UICollectionView!
    var products: NSMutableArray!
    var screenwidth = [String]()

   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.wishlistcollectionView.backgroundColor = CXAppConfig.sharedInstance.getAppBGColor()
        let nib = UINib(nibName: "WishlistCollectionViewCell", bundle: nil)
        self.wishlistcollectionView.register(nib, forCellWithReuseIdentifier: "WishlistCollectionViewCell")
        emptyWishlistLbl.textColor = CXAppConfig.sharedInstance.getAppTheamColor()
        getTheProducts()
        
        if products.count == 0{
            emptyWishlistLbl.isHidden = false
            wishlistcollectionView.isHidden = true
            
        }else{
            emptyWishlistLbl.isHidden = false
            wishlistcollectionView.isHidden = false
        }
        
    }
    func getTheProducts(){
        
        let cartlist : NSArray =  CX_Cart.mr_findAll(with: NSPredicate(format: "addToWishList = %@", "1")) as NSArray
        self.products  = NSMutableArray(array: cartlist)
        self.wishlistcollectionView.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return  self.products.count

    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {

        let cell = wishlistcollectionView.dequeueReusableCell(withReuseIdentifier: "WishlistCollectionViewCell", for: indexPath)as! WishlistCollectionViewCell
        cell.imagetitleLabel.text = self.products[indexPath.item] as? String
        let products:CX_Cart = (self.products[indexPath.item]as?
            CX_Cart)!
        
        cell.imagetitleLabel.text = products.name
        cell.imagetitleLabel.font = CXAppConfig.sharedInstance.appMediumFont()
        cell.wishlistimageview.sd_setImage(with: URL(string: products.imageUrl!))
        
        cell.wishlistaddtocartbutton.tag = indexPath.row+1
        cell.wishlistdeletebutton.tag = indexPath.row+1
        cell.onlineStoreBtn.tag = indexPath.row+1
        
        cell.wishlistaddtocartbutton.addTarget(self, action: #selector(NowfloatWishlistViewController.addTocartBtnAction(_:)), for: .touchUpInside)
        cell.wishlistdeletebutton.addTarget(self, action: #selector(NowfloatWishlistViewController.deleteWishListButtonAction(_:)), for: .touchUpInside)
        cell.onlineStoreBtn.addTarget(self, action: #selector(NowfloatWishlistViewController.sendToOnlineTab(_:)), for: .touchUpInside)
        
        let rupee = "\u{20B9}"
        
        //Trimming Price And Discount
        let floatPrice: Float = Float(CXDataProvider.sharedInstance.getJobID("MRP", inputDic: products.json!))!
        let finalPrice = String(format: floatPrice == floor(floatPrice) ? "%.0f" : "%.1f", floatPrice)
        
        let floatDiscount:Float = Float(CXDataProvider.sharedInstance.getJobID("DiscountAmount", inputDic: products.json!))!
        let finalDiscount = String(format: floatDiscount == floor(floatDiscount) ? "%.0f" : "%.1f", floatDiscount)
        
        //Setting AttributedPrice
        let attributeString: NSMutableAttributedString! =  NSMutableAttributedString(string: "\(rupee) \(finalPrice)")
        attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 1, range: NSMakeRange(0, attributeString.length))
        
        //FinalPrice after subtracting the discount
        let finalPriceNum:Int! = Int(finalPrice)!-Int(finalDiscount)!
        let FinalPrice = String(finalPriceNum) as String
        
        if finalPrice == FinalPrice{
            cell.mrpLbl.isHidden = true
            cell.discountBdgeLb.isHidden = true
            cell.wishlistpricelabel.text = "\(rupee) \(FinalPrice)"
        }else{
            cell.mrpLbl.isHidden = false
            cell.discountBdgeLb.isHidden = false
            cell.mrpLbl.attributedText = attributeString
            cell.discountBdgeLb.text = "\(finalDiscount)"
            cell.wishlistpricelabel.text = "\(rupee) \(FinalPrice))"
            
        }
        
        cell.mrpLbl.font =  CXAppConfig.sharedInstance.appMediumFont()
        cell.mrpLbl.textColor = CXAppConfig.sharedInstance.getAppTheamColor()
        cell.wishlistpricelabel.font =  CXAppConfig.sharedInstance.appMediumFont()
  
        
        let MRP = CXDataProvider.sharedInstance.getJobID("MRP", inputDic: products.json!)
        let Link = CXDataProvider.sharedInstance.getJobID("BuyOnlineLink", inputDic: products.json!)
        
        print(MRP,Link)
        
        if CXDataProvider.sharedInstance.getJobID("MRP", inputDic: products.json!) == "0"{
            
            cell.mrpLbl.isHidden = true
            cell.discountBdgeLb.isHidden = true
            cell.wishlistpricelabel.isHidden = true
            
        }else{
            cell.mrpLbl.isHidden = false
            cell.discountBdgeLb.isHidden = false
            cell.wishlistpricelabel.isHidden = false
        }
   
        if MRP == "0" && Link == "" {
            
            cell.wishlistaddtocartbutton.setTitle("ASK FOR A QUOTE", for: .normal)
            cell.wishlistaddtocartbutton.setImage(nil, for: .normal)
            cell.onlineStoreBtn.isHidden = true

        }else if MRP == "0" && Link != "" {
            
            cell.onlineStoreBtn.isHidden = false
            
            cell.wishlistaddtocartbutton.setTitle("MORE INFO", for: .normal)
            cell.wishlistaddtocartbutton.setImage(nil, for: .normal)
            cell.onlineStoreBtn.setTitle("ONLINE STORE", for: .normal)
            
        }
        
        /*else if MRP != "0" && Link != "" {
            
            cell.onlineStoreBtn.isHidden = true
            
        }*/
        
        /*
        let price:String = CXDataProvider.sharedInstance.getJobID("MRP", inputDic: products.json!)
        let discount:String = CXDataProvider.sharedInstance.getJobID("DiscountAmount", inputDic: products.json!)
        
        if discount == "0"{
            cell.mrpLbl.isHidden = true
            cell.discountBdgeLb.isHidden = true
            cell.wishlistpricelabel.text = "\(rupee) \(price)"
            
        }else{
            cell.mrpLbl.isHidden = false
            cell.discountBdgeLb.isHidden = false
            
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "\(rupee) \(price)")
            attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 1, range: NSMakeRange(0, attributeString.length))
            cell.mrpLbl.attributedText = attributeString
            
            cell.discountBdgeLb.text = "\(discount)"
            let finalPriceNum:Int = Int(price)!-Int(discount)!
            cell.wishlistpricelabel.text = "\(rupee) \(String(finalPriceNum))"
        }
        cell.mrpLbl.font =  CXAppConfig.sharedInstance.appMediumFont()
        cell.mrpLbl.textColor = CXAppConfig.sharedInstance.getAppTheamColor()
        cell.wishlistpricelabel.font =  CXAppConfig.sharedInstance.appMediumFont()

*/
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let flow = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flow.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5)
        //let width = UIScreen.mainScreen().bounds.size.width - 6
        //flow.itemSize = CGSizeMake(width, 150)
        return CGSize(width: collectionView.bounds.size.width-10, height: 150)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5
    }
    
    
    func addTocartBtnAction(_ button : UIButton!){
        #if MyLabs
            
        #else
            let proListData : CX_Cart = self.products[button.tag-1] as! CX_Cart
            
            if (button.titleLabel?.text == "MORE INFO") || (button.titleLabel?.text == "ASK FOR A QUOTE") {
                
                let productsList : NSArray =  CX_Products.mr_findAll(with: NSPredicate(format: "pid = %@",proListData.pID!)) as NSArray
                let products  = NSMutableArray(array: productsList)
                let storesEntity : CX_Products = products.lastObject as! CX_Products
                let productDic = CXConstant.sharedInstance.convertStringToDictionary(storesEntity.json!)
                print(productDic)
                
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
                
                if button.titleLabel?.text == "ASK FOR A QUOTE"{
                    container.textViewString = "Hi, I am interested in \"\(productDic.value(forKey: "Name") as! String)\" and need pricing regarding same. Please contact me."
                }
                
                if UserDefaults.standard.value(forKey: "USER_ID") != nil{
                    
                    if button.titleLabel?.text == "MORE INFO" {
                        
                        container.textViewString = "Hi, I am interested in \"\(productDic.value(forKey: "Name") as! String)\" and need more information on the same. Please contact me."
                    }
                    
                }else{
                    let signInViewCnt : CXSignInSignUpViewController = CXSignInSignUpViewController()
                    self.navigationController?.pushViewController(signInViewCnt, animated: true)
                    return
                }
                
                container.closeHandler = { _ in
                    popup.dismiss()
                }
                
                popup.show(container)
                
            }else{
                
                self.products.removeObject(at: button.tag-1)
                self.wishlistcollectionView.reloadData()
                CXDataProvider.sharedInstance.itemAddToWishListOrCarts(proListData.json!, itemID: proListData.pID!, isAddToWishList: false, isAddToCartList: true, isDeleteFromWishList: true, isDeleteFromCartList: false, completionHandler: { (isAdded) in
                    
                })
                
                print("delete the cell")
                
            }

        #endif
            }
    
    func deleteWishListButtonAction(_ button : UIButton!){
        //Add to wishList
        
        // let updateDic : NSDictionary = self.p[button.tag-1] as! NSDictionary
        //   (indexPath.section)
        //self.collectionview.deleteItemsAtIndexPaths([indexPath])
        let proListData : CX_Cart = self.products[button.tag-1] as! CX_Cart
        self.products.removeObject(at: button.tag-1)
        self.wishlistcollectionView.reloadData()

       // self.wishlistcollectionView.deleteItemsAtIndexPaths([NSIndexPath(forItem: button.tag-1, inSection: 0)])
       // self.wishlistcollectionView.reloadItemsAtIndexPaths([NSIndexPath(forItem: button.tag-1, inSection: 0)])
       // print(proListData.pID)
        CXDataProvider.sharedInstance.itemAddToWishListOrCarts(proListData.json!, itemID: proListData.pID!, isAddToWishList: false, isAddToCartList: false, isDeleteFromWishList: true, isDeleteFromCartList: false, completionHandler: { (isAdded) in
            
        })
        
        print("delete the cell");
        
    }
    
    
    func sendToOnlineTab(_ button : UIButton!){
        #if MyLabs
            
        #else
            let proListData : CX_Cart = self.products[button.tag-1] as! CX_Cart
            
            let productsList : NSArray =  CX_Products.mr_findAll(with: NSPredicate(format: "pid = %@",proListData.pID!)) as NSArray
            let products  = NSMutableArray(array: productsList)
            let storesEntity : CX_Products = products.lastObject as! CX_Products
            let productDic = CXConstant.sharedInstance.convertStringToDictionary(storesEntity.json!)
            print(productDic)
            
            
            let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let online = storyBoard.instantiateViewController(withIdentifier: "BuyOnlineWebViewController") as! BuyOnlineWebViewController
            online.url = productDic.value(forKey: "BuyOnlineLink") as! String!
            online.productName = productDic.value(forKey: "Name") as! String!
            self.navigationController?.pushViewController(online, animated: true)
        #endif

        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    override func shouldShowLeftMenu() -> Bool{
        
        return true
    }
    override func shouldShowLeftMenuWithLogo() -> Bool{
        
        return false
    }
    
    override func showLogoForAboutUs() -> Bool{
        return false
    }
    
    override func headerTitleText() -> String{
        return "Wishlist"
    }
    override func profileDropdown() -> Bool{
        return false
    }
    
    override func profileDropdownForSignIn() -> Bool{
        return false
    }


}

