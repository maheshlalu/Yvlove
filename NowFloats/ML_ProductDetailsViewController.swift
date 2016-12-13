//
//  ML_ProductDetailsViewController.swift
//  NowFloats
//
//  Created by Manishi on 12/12/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit

class ML_ProductDetailsViewController: CXViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var productImgView: UIImageView!
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var testTypeLbl: UILabel!
    @IBOutlet weak var testCodeLbl: UILabel!
    @IBOutlet weak var testPriceLbl: UILabel!
    
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var descriptionTextTestView: UITextView!
    
    @IBOutlet weak var collectionViewHeaderLbl: UILabel!
    @IBOutlet weak var testsCollectionView: UICollectionView!
    
    @IBOutlet weak var bookTestBtn: UIButton!
    
    var productString : String!
    var productDetailDic:NSDictionary!
    var products:NSArray!
    var type : String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productDetailDic = CXConstant.sharedInstance.convertStringToDictionary(productString)
        
        let nib = UINib(nibName: "ML_ProductDetailCollectionViewCell", bundle: nil)
        testsCollectionView.register(nib, forCellWithReuseIdentifier: "ML_ProductDetailCollectionViewCell")
        
        self.viewCustomizations()
        self.getProducts()
    }
    
    func viewCustomizations(){
        
        self.topView.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
        self.descriptionLbl.textColor = CXAppConfig.sharedInstance.getAppTheamColor()
        self.bookTestBtn.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
                
        let string = productDetailDic.value(forKey:"Description") as! String
        let str = string.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        print(str)
        self.descriptionTextTestView.text = str
        self.productNameLbl.text! = (productDetailDic.value(forKey:"Name") as? String)!
        self.testTypeLbl.text! = "Test Type: "+"\(productDetailDic.value(forKey:"jobTypeName") as! String)"
        self.testCodeLbl.text! = "Test Code: "+"\(productDetailDic.value(forKey:"Test Code") as! String)"
        self.testPriceLbl.text! = "₹ "+"\(productDetailDic.value(forKey:"MRP") as! String)"
        self.collectionViewHeaderLbl.text! = "More From "+"\(productDetailDic.value(forKey:"jobTypeName") as! String)"
    }
    
    func getProducts(){
        let fetchRequest :  NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CX_Products")
        let predicate =  NSPredicate(format: "type=='\(self.type)'", argumentArray: nil)
        fetchRequest.predicate = predicate
        self.products =  CX_Products.mr_executeFetchRequest(fetchRequest) as NSArray!
        
    }
    
    // CollectionView Delegate Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ML_ProductDetailCollectionViewCell", for: indexPath) as! ML_ProductDetailCollectionViewCell
        let products:CX_Products = (self.products[indexPath.item] as? CX_Products)!
        cell.collectionViewImg.sd_setImage(with: URL(string: products.imageUrl!))
        cell.collectionViewLbl.text = products.name
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let products:CX_Products = (self.products[indexPath.item] as? CX_Products)!
        self.productString = products.json
        self.type = productDetailDic.value(forKey:"jobTypeName") as! String
        self.viewDidLoad()
    }
    
    @IBAction func bookTestAction(_ sender: Any) {
        if UserDefaults.standard.value(forKey: "USER_ID") == nil{
            print("no userid")
            NotificationCenter.default.post(name: Notification.Name(rawValue: "SignInNotification"), object: nil)
        }else{
            print("has userid")
            let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let orders = storyBoard.instantiateViewController(withIdentifier: "BookTestViewController") as! BookTestViewController
            self.navigationController?.pushViewController(orders, animated: true)
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
