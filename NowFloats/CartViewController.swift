//
//  ViewController.swift
//  CartView
//
//  Created by Rama kuppa on 12/09/16.
//  Copyright © 2016 Mahesh. All rights reserved.
//

import UIKit

class CartViewController: CXViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    
    @IBOutlet weak var checkOutNowBtn: UIButton!
    @IBOutlet weak var productsCountLbl: UILabel!
    @IBOutlet weak var totalPriceLbl: UILabel!
    var totalPriceString:NSString!
    
    @IBOutlet var collectionview: UICollectionView!
    var products: NSMutableArray!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "NowfloatscartViewCollectionViewCell", bundle: nil)
        self.collectionview.registerNib(nib, forCellWithReuseIdentifier: "NowfloatscartViewCollectionViewCell")
        getTheProducts()
        self.checkOutNowBtn.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
        self.productsCountLbl.text = "\(self.products.count) Products"
        self.view.backgroundColor = CXAppConfig.sharedInstance.getAppBGColor()
        self.collectionview.backgroundView?.backgroundColor = UIColor.clearColor()
    }
    
    
    func updateProductsPriceLabel(){
        
        let cartlist : NSArray =  CX_Cart.MR_findAllWithPredicate(NSPredicate(format: "addToCart = %@", "1"))
        var productPrice : Int = 0
        
        for (index, element) in cartlist.enumerate() {
            let cart : CX_Cart = element as! CX_Cart
            let price : Int = cart.quantity!.integerValue * cart.productPrice!.integerValue
            productPrice =  price + productPrice
            
        }
         let rupee = "\u{20B9}"
        self.totalPriceLbl.text = "\(rupee)\(String(productPrice))"
         self.productsCountLbl.text = "\(cartlist.count) Products"
    }
    
    func getTheProducts(){
       // let fetchRequest : NSFetchRequest = NSFetchRequest(format: "addToCart = %@", "1")
        
     let cartlist : NSArray =  CX_Cart.MR_findAllWithPredicate(NSPredicate(format: "addToCart = %@", "1"))
        self.products  = NSMutableArray(array: cartlist)
        self.collectionview.reloadData()
        self.updateProductsPriceLabel()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        
      return self.products.count
        
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        
        let flow = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flow.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5)
        let width = UIScreen.mainScreen().bounds.size.width - 6
        flow.itemSize = CGSizeMake(width, 189)
        
        let cell = collectionview.dequeueReusableCellWithReuseIdentifier("NowfloatscartViewCollectionViewCell", forIndexPath: indexPath)as! NowfloatscartViewCollectionViewCell
        
        cell.cartviewminusbutton.backgroundColor = UIColor.lightGrayColor()
        cell.cartviewminusbutton.layer.cornerRadius = 10
        cell.cartviewminusbutton.layer.borderWidth = 1
        cell.cartviewminusbutton.layer.borderColor = UIColor.clearColor().CGColor
        
        
        
        cell.cartviewplusbutton.backgroundColor = UIColor.lightGrayColor()
        cell.cartviewplusbutton.layer.cornerRadius = 10
        cell.cartviewplusbutton.layer.borderWidth = 1
        cell.cartviewplusbutton.layer.borderColor = UIColor.clearColor().CGColor
        
        cell.cartviewLabel.layer.cornerRadius = 5.0
        cell.cartviewLabel.layer.borderWidth=1
        cell.cartviewLabel.layer.borderColor = UIColor.lightGrayColor().CGColor
        var products:CX_Cart = (self.products[indexPath.item]as?
            CX_Cart)!
        let cartlist : NSArray =  CX_Cart.MR_findAllWithPredicate(NSPredicate(format: "pID = %@", products.pID!))
        products =  (cartlist.lastObject as? CX_Cart)!

        //let products:CX_Cart = (self.products[indexPath.item]as?
          //  CX_Cart)!
        
        cell.cartviewimagetitlelabel.text = products.name
        
        cell.cartviewimage.sd_setImageWithURL(NSURL(string: products.imageUrl!))
        
        cell.cartviewimagetitlelabel.font = CXAppConfig.sharedInstance.appMediumFont()
        cell.cartviewpricelabel.font = CXAppConfig.sharedInstance.appMediumFont()
        let rupee = "\u{20B9}"
        cell.cartviewpricelabel.text = "\(rupee)\(products.productPrice!)"
        cell.cartviewLabel.text = String(products.quantity!)
        
        cell.cartviewminusbutton.tag = indexPath.row+1
        cell.cartviewplusbutton.tag = indexPath.row+1
        
        cell.cartdeletebutton.tag = indexPath.row+1
        cell.cartwishlistbutton.tag = indexPath.row+1
        
        cell.cartdeletebutton.addTarget(self, action: #selector(CartViewController.cartDeleteBtnAction(_:)), forControlEvents: .TouchUpInside)
        cell.cartwishlistbutton.addTarget(self, action: #selector(CartViewController.cartWishListButtonAction(_:)), forControlEvents: .TouchUpInside)
        
        cell.cartviewplusbutton.addTarget(self, action: #selector(CartViewController.quntityPlusButtonAction(_:)), forControlEvents: .TouchUpInside)
        cell.cartviewminusbutton.addTarget(self, action: #selector(CartViewController.quantityMinusButtonAction(_:)), forControlEvents: .TouchUpInside)
        
        

    return cell
  
    }
    func cartDeleteBtnAction(button : UIButton!){
        print(button.tag-1)
        let proListData : CX_Cart = self.products[button.tag-1] as! CX_Cart
        self.products.removeObjectAtIndex(button.tag-1)
        self.collectionview.reloadData()
        CXDataProvider.sharedInstance.itemAddToWishListOrCarts(proListData.json!, itemID: proListData.pID!, isAddToWishList: false, isAddToCartList: false, isDeleteFromWishList: false, isDeleteFromCartList: true, completionHandler: { (isAdded) in
            
        })
       // print("delete the cell");
        self.updateProductsPriceLabel()

    
    }
    
    func cartWishListButtonAction(button : UIButton!){
        //Add to wishList
        let proListData : CX_Cart = self.products[button.tag-1] as! CX_Cart
        self.products.removeObjectAtIndex(button.tag-1)
        self.collectionview.reloadData()
        CXDataProvider.sharedInstance.itemAddToWishListOrCarts(proListData.json!, itemID: proListData.pID!, isAddToWishList: true, isAddToCartList: false, isDeleteFromWishList: false, isDeleteFromCartList: true, completionHandler: { (isAdded) in
            
        })
        self.updateProductsPriceLabel()

        
    }

    func quntityPlusButtonAction(button : UIButton!){
        
        let proListData : CX_Cart = self.products[button.tag-1] as! CX_Cart
        var mybalance = proListData.quantity! as NSNumber
        print(proListData.json!)
        mybalance = mybalance.integerValue + 1
        proListData.quantity = mybalance
        NSManagedObjectContext.MR_contextForCurrentThread().MR_saveToPersistentStoreAndWait()
        self.collectionview.reloadData()
        self.updateProductsPriceLabel()

    }
    
    func quantityMinusButtonAction(button : UIButton!){
        
        let proListData : CX_Cart = self.products[button.tag-1] as! CX_Cart
        var mybalance = proListData.quantity! as NSNumber
        if mybalance.integerValue > 1 {
            mybalance = mybalance.integerValue - 1
            proListData.quantity = mybalance
            NSManagedObjectContext.MR_contextForCurrentThread().MR_saveToPersistentStoreAndWait()
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

    @IBAction func checkoutNowBtn(sender: UIButton) {
        
        let popup = PopupController
            .create(self)
            .customize(
                [
                    .Animation(.SlideUp),
                    .Scrollable(false),
                    .Layout(.Center),
                    .BackgroundStyle(.BlackFilter(alpha: 0.7))
                ]
            )
            .didShowHandler { popup in
            }
            .didCloseHandler { _ in
        }
        let container = DemoPopupViewController2.instance()
        container.closeHandler = { _ in
            popup.dismiss()
            CXAppDataManager.sharedInstance.placeOder(container.nameTxtField.text!, email: container.emailTxtField.text!, address1: container.addressLine1TxtField.text!, address2: container.addressLine2TxtField.text!, number: container.mobileNoTxtField.text!,subTotal:self.totalPriceLbl.text! ,completion: { (isDataSaved) in
                self.navController.popViewControllerAnimated(true)
            })
        }
        popup.show(container)
        
    }
    
    

}

