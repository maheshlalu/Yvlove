//
//  ViewController.swift
//  CartView
//
//  Created by Rama kuppa on 12/09/16.
//  Copyright © 2016 Mahesh. All rights reserved.
//

import UIKit

class CartViewController: CXViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var emptyCartLbl: UILabel!
    @IBOutlet weak var checkOutNowBtn: UIButton!
    @IBOutlet weak var productsCountLbl: UILabel!
    @IBOutlet weak var totalPriceLbl: UILabel!
    var totalPriceString:NSString!
    
    @IBOutlet var collectionview: UICollectionView!
    var products: NSMutableArray!
    override func viewDidLoad() {
        super.viewDidLoad()
        CXMixpanel.sharedInstance.mixelCartTrack()

        let nib = UINib(nibName: "NowfloatscartViewCollectionViewCell", bundle: nil)
        self.collectionview.register(nib, forCellWithReuseIdentifier: "NowfloatscartViewCollectionViewCell")
        getTheProducts()
        self.emptyCartLbl.textColor = CXAppConfig.sharedInstance.getAppTheamColor()
        
        if products.count == 0{
            emptyCartLbl.isHidden = false
            bottomView.isHidden = true
            collectionview.isHidden = true
            
        }else{
            emptyCartLbl.isHidden = true
            bottomView.isHidden = false
            collectionview.isHidden = false
        }
        
        self.checkOutNowBtn.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
        self.productsCountLbl.text = "\(self.products.count) Products"
        self.view.backgroundColor = CXAppConfig.sharedInstance.getAppBGColor()
        self.collectionview.backgroundView?.backgroundColor = UIColor.clear
    }
    
    
    func updateProductsPriceLabel(){
        
        let cartlist : NSArray =  CX_Cart.mr_findAll(with: NSPredicate(format: "addToCart = %@", "1")) as NSArray
        var productPrice : Int = 0
        
        for (index, element) in cartlist.enumerated() {
            let cart : CX_Cart = element as! CX_Cart
            let price : Int = cart.quantity!.intValue * cart.productPrice!.intValue
            productPrice =  price + productPrice
            
        }
        let rupee = "\u{20B9}"
        self.totalPriceLbl.text = "\(rupee)\(String(productPrice))"
        self.productsCountLbl.text = "\(cartlist.count) Products"
        
        if (self.totalPriceLbl.text == "\(rupee)0"){
            emptyCartLbl.isHidden = false
            bottomView.isHidden = true
            collectionview.isHidden = true
        }else{
            emptyCartLbl.isHidden = true
            bottomView.isHidden = false
            collectionview.isHidden = false
        }
        
    }
    
    func getTheProducts(){
       // let fetchRequest : NSFetchRequest = NSFetchRequest(format: "addToCart = %@", "1")
        
     let cartlist : NSArray =  CX_Cart.mr_findAll(with: NSPredicate(format: "addToCart = %@", "1")) as NSArray
        self.products  = NSMutableArray(array: cartlist)
        self.collectionview.reloadData()
        self.updateProductsPriceLabel()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        
      return self.products.count
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        let flow = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flow.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5)
        let width = UIScreen.main.bounds.size.width - 6
        flow.itemSize = CGSize(width: width, height: 189)
        
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: "NowfloatscartViewCollectionViewCell", for: indexPath)as! NowfloatscartViewCollectionViewCell
        
        cell.cartviewminusbutton.backgroundColor = UIColor.lightGray
        cell.cartviewminusbutton.layer.cornerRadius = 10
        cell.cartviewminusbutton.layer.borderWidth = 1
        cell.cartviewminusbutton.layer.borderColor = UIColor.clear.cgColor
        
        
        
        cell.cartviewplusbutton.backgroundColor = UIColor.lightGray
        cell.cartviewplusbutton.layer.cornerRadius = 10
        cell.cartviewplusbutton.layer.borderWidth = 1
        cell.cartviewplusbutton.layer.borderColor = UIColor.clear.cgColor
        
        cell.cartviewLabel.layer.cornerRadius = 5.0
        cell.cartviewLabel.layer.borderWidth=1
        cell.cartviewLabel.layer.borderColor = UIColor.lightGray.cgColor
        var products:CX_Cart = (self.products[indexPath.item]as?
            CX_Cart)!
        let cartlist : NSArray =  CX_Cart.mr_findAll(with: NSPredicate(format: "pID = %@", products.pID!)) as NSArray
        products =  (cartlist.lastObject as? CX_Cart)!

        //let products:CX_Cart = (self.products[indexPath.item]as?
          //  CX_Cart)!
        
        cell.cartviewimagetitlelabel.text = products.name
        
        cell.cartviewimage.sd_setImage(with: URL(string: products.imageUrl!))
        
        cell.cartviewimagetitlelabel.font = CXAppConfig.sharedInstance.appMediumFont()
        cell.cartviewpricelabel.font = CXAppConfig.sharedInstance.appMediumFont()
        let rupee = "\u{20B9}"
        cell.cartviewpricelabel.text = "\(rupee)\(products.productPrice!)"
        cell.cartviewLabel.text = String(describing: products.quantity!)
        
        cell.cartviewminusbutton.tag = indexPath.row+1
        cell.cartviewplusbutton.tag = indexPath.row+1
        
        cell.cartdeletebutton.tag = indexPath.row+1
        cell.cartwishlistbutton.tag = indexPath.row+1
        
        cell.cartdeletebutton.addTarget(self, action: #selector(CartViewController.cartDeleteBtnAction(_:)), for: .touchUpInside)
        cell.cartwishlistbutton.addTarget(self, action: #selector(CartViewController.cartWishListButtonAction(_:)), for: .touchUpInside)
        
        cell.cartviewplusbutton.addTarget(self, action: #selector(CartViewController.quntityPlusButtonAction(_:)), for: .touchUpInside)
        cell.cartviewminusbutton.addTarget(self, action: #selector(CartViewController.quantityMinusButtonAction(_:)), for: .touchUpInside)
        
        

    return cell
  
    }
    func cartDeleteBtnAction(_ button : UIButton!){
        print(button.tag-1)
        let proListData : CX_Cart = self.products[button.tag-1] as! CX_Cart
        self.products.removeObject(at: button.tag-1)
        self.collectionview.reloadData()
        CXDataProvider.sharedInstance.itemAddToWishListOrCarts(proListData.json!, itemID: proListData.pID!, isAddToWishList: false, isAddToCartList: false, isDeleteFromWishList: false, isDeleteFromCartList: true, completionHandler: { (isAdded) in
            
        })
        self.updateProductsPriceLabel()

    
    }
    
    func cartWishListButtonAction(_ button : UIButton!){
        //Add to wishList
        let proListData : CX_Cart = self.products[button.tag-1] as! CX_Cart
        self.products.removeObject(at: button.tag-1)
        self.collectionview.reloadData()
        CXDataProvider.sharedInstance.itemAddToWishListOrCarts(proListData.json!, itemID: proListData.pID!, isAddToWishList: true, isAddToCartList: false, isDeleteFromWishList: false, isDeleteFromCartList: true, completionHandler: { (isAdded) in
            
        })
        self.updateProductsPriceLabel()

        
    }

    func quntityPlusButtonAction(_ button : UIButton!){
        
        let proListData : CX_Cart = self.products[button.tag-1] as! CX_Cart
        var mybalance = proListData.quantity! as NSInteger
        print(proListData.json!)
        
        //TODo work
        mybalance += 1
      //  mybalance = mybalance.toIntMax() + 1
        
        proListData.quantity = mybalance as NSNumber? // mybalance
        NSManagedObjectContext.mr_contextForCurrentThread().mr_saveToPersistentStoreAndWait()
        self.collectionview.reloadData()
        self.updateProductsPriceLabel()

    }
    
    func quantityMinusButtonAction(_ button : UIButton!){
        
        let proListData : CX_Cart = self.products[button.tag-1] as! CX_Cart
        var mybalance = proListData.quantity! as NSInteger
        if mybalance > 1 {
            
            //TODo work

            mybalance -= 1
            
            proListData.quantity = mybalance as NSNumber? //mybalance
            NSManagedObjectContext.mr_contextForCurrentThread().mr_saveToPersistentStoreAndWait()
            self.collectionview.reloadData()
            self.updateProductsPriceLabel()

        }
      
      //  self.collectionview.reloadItemsAtIndexPaths(NSIndexPath(forItem: button.tag-1, inSection: 0))

        
    }
    
    func updateQuantityItems(){
        
        
    }
    
    //MAR:Heder options enable
    override  func shouldShowRightMenu() -> Bool{
        
        return true
    }
    
    override func shouldShowNotificatoinBell() ->Bool{
        
        return false
    }
    
    override  func shouldShowCart() -> Bool{
        
        return false
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
    
    override func headerTitleText() -> String{
        return "Your Cart"
    }
    override func profileDropdown() -> Bool{
        return false
    }
    
    override func profileDropdownForSignIn() -> Bool{
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func checkoutNowBtn(_ sender: UIButton) {
        
        if UserDefaults.standard.value(forKey: "USER_EMAIL") == nil
        {
            let name = CXSignInSignUpViewController()
            self.navigationController?.pushViewController(name, animated: true)
        }
        else
        {
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
            let container = DemoPopupViewController2.instance() 
            container.closeHandler = { _ in
                popup.dismiss()
            }
            container.sendDetails = { _ in
                let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let paymentcontroller : PaymentViewController = (storyBoard.instantiateViewController(withIdentifier: "PaymentViewController") as? PaymentViewController)!
                let navController = UINavigationController(rootViewController: paymentcontroller)
                navController.navigationItem.hidesBackButton = true
                self.present(navController, animated: true, completion: nil)
                
             /*
                  CXAppDataManager.sharedInstance.placeOder(container.nameTxtField.text!, email: container.emailTxtField.text!, address1: container.addressLine1TxtField.text!, address2: container.addressLine2TxtField.text!, number: container.mobileNoTxtField.text!,subTotal:self.totalPriceLbl.text! ,completion: { (isDataSaved) in
                    //self.view.makeToast(message: "Product Ordered Successfully!!!")
                    //self.navController.popViewController(animated: true)
                    
                   /* let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    let paymentcontroller : PaymentViewController = (storyBoard.instantiateViewController(withIdentifier: "PaymentViewController") as? PaymentViewController)!
                    let navController = UINavigationController(rootViewController: paymentcontroller)
                    navController.navigationItem.hidesBackButton = true
                    self.present(navController, animated: true, completion: nil)
                    */
                })
 */
 
            }
            popup.show(container)
            
        }
            
    }
    

}

