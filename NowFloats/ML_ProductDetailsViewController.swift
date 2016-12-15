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
    
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var categoryTxtView: UITextView!
    
    @IBOutlet weak var collectionViewHeaderLbl: UILabel!
    @IBOutlet weak var testsCollectionView: UICollectionView!
    
    @IBOutlet weak var bookTestBtn: UIButton!
    
    var productString : String!
    var productDetailDic:NSDictionary!
    var products:NSArray!
    var type : String = String()
    var isFromOffersView:Bool = false
    var FinalPrice:String!
    var featureProducts: NSArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        productDetailDic = CXConstant.sharedInstance.convertStringToDictionary(productString)
        
        let nib = UINib(nibName: "ML_ProductDetailCollectionViewCell", bundle: nil)
        testsCollectionView.register(nib, forCellWithReuseIdentifier: "ML_ProductDetailCollectionViewCell")
        
        self.viewCustomizations()
        self.getProducts()
        
        self.featureProducts = CXDataProvider.sharedInstance.getTheTableDataFromDataBase("CX_FeaturedProducts", predicate: NSPredicate(), ispredicate: false, orederByKey: "fID").dataArray

    }
    
    func viewCustomizations(){
        
        self.topView.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
        self.descriptionLbl.textColor = CXAppConfig.sharedInstance.getAppTheamColor()
        self.categoryLbl.textColor = CXAppConfig.sharedInstance.getAppTheamColor()
        self.bookTestBtn.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
                
        let descriptionString = productDetailDic.value(forKey:"Description") as! String
        let str = descriptionString.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        print(str)
        
        if str == ""{
            self.descriptionLbl.isHidden = true
            self.descriptionTextTestView.isHidden = true
        }else{
            self.descriptionTextTestView.text = str
        }
        
        let categoryString = productDetailDic.value(forKey: "Category") as! String
        if categoryString == ""{
            self.categoryLbl.isHidden = true
            self.categoryTxtView.isHidden = true
        }else{
            self.categoryTxtView.text = categoryString
        }
  
        
        self.productNameLbl.text! = (productDetailDic.value(forKey:"Name") as? String)!
        self.testTypeLbl.text! = "Test Type: "+"\(productDetailDic.value(forKey:"jobTypeName") as! String)"
        self.testCodeLbl.text! = "Test Code: "+"\(productDetailDic.value(forKey:"TestCode") as! String)"
        self.testPriceLbl.text! = "₹ "+"\(FinalPrice!)"
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
        if isFromOffersView{
            let featureProducts : CX_FeaturedProducts =  (self.featureProducts[collectionView.tag] as? CX_FeaturedProducts)!
            return CXDataProvider.sharedInstance.getTheTableDataFromDataBase("CX_FeaturedProductsJobs", predicate: NSPredicate(format: "parentID == %@",featureProducts.fID!), ispredicate: true, orederByKey: "").totalCount
        }else{
               return self.products.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ML_ProductDetailCollectionViewCell", for: indexPath) as! ML_ProductDetailCollectionViewCell
        cell.priceLbl.textColor = CXAppConfig.sharedInstance.getAppTheamColor()
        
        if isFromOffersView{
            let featureProducts : CX_FeaturedProducts =  (self.featureProducts[collectionView.tag] as? CX_FeaturedProducts)!
            let featuredProductJobs : CX_FeaturedProductsJobs = (CXDataProvider.sharedInstance.getTheTableDataFromDataBase("CX_FeaturedProductsJobs", predicate: NSPredicate(format: "parentID == %@",featureProducts.fID!), ispredicate: true, orederByKey: "").dataArray[indexPath.row] as?CX_FeaturedProductsJobs)!
            
            let rupee = "\u{20B9}"
            
            //Trimming Price And Discount
            let floatPrice: Float = Float(CXDataProvider.sharedInstance.getJobID("MRP", inputDic: featuredProductJobs.json!))!
            let finalPrice = String(format: floatPrice == floor(floatPrice) ? "%.0f" : "%.1f", floatPrice)
            
            let floatDiscount:Float = Float(CXDataProvider.sharedInstance.getJobID("DiscountAmount", inputDic: featuredProductJobs.json!))!
            let finalDiscount = String(format: floatDiscount == floor(floatDiscount) ? "%.0f" : "%.1f", floatDiscount)
            
            //Setting AttributedPrice
            let attributeString: NSMutableAttributedString! =  NSMutableAttributedString(string: "\(rupee) \(finalPrice)")
            attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 1, range: NSMakeRange(0, attributeString.length))
            
            //FinalPrice after subtracting the discount
            let finalPriceNum:Int! = Int(finalPrice)!-Int(finalDiscount)!
            FinalPrice = String(finalPriceNum) as String
            
            if finalPrice == FinalPrice{
                cell.priceLbl.isHidden = true
                cell.finalPriceLbl.text! = "\(rupee) \(FinalPrice!)"
            }else{
                cell.priceLbl.isHidden = false
                cell.priceLbl.attributedText = attributeString
    
                cell.finalPriceLbl.text! = "\(rupee) \(FinalPrice!)"
            }
            
            cell.collectionViewImg.sd_setImage(with: URL(string: featuredProductJobs.image_URL!))
            cell.collectionViewLbl.text = featuredProductJobs.name
    
            
        }else{
            let products:CX_Products = (self.products[indexPath.item] as? CX_Products)!
            
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
            FinalPrice = String(finalPriceNum) as String
            
            if finalPrice == FinalPrice{
                cell.priceLbl.isHidden = true
                cell.finalPriceLbl.text! = "\(rupee) \(FinalPrice!)"
            }else{
                cell.priceLbl.isHidden = false
                cell.priceLbl.attributedText = attributeString
                cell.finalPriceLbl.text! = "\(rupee) \(FinalPrice!)"
            }
            cell.collectionViewImg.sd_setImage(with: URL(string: products.imageUrl!))
            cell.collectionViewLbl.text = products.name
        }
        

        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if isFromOffersView{
            
            let featureProducts : CX_FeaturedProducts =  (self.featureProducts[collectionView.tag] as? CX_FeaturedProducts)!
            let FeaturedProductJobs : CX_FeaturedProductsJobs = (CXDataProvider.sharedInstance.getTheTableDataFromDataBase("CX_FeaturedProductsJobs", predicate: NSPredicate(format: "parentID == %@",featureProducts.fID!), ispredicate: true, orederByKey: "").dataArray[indexPath.row] as?CX_FeaturedProductsJobs)!

            let featuredProductJobs : CX_FeaturedProductsJobs = (CXDataProvider.sharedInstance.getTheTableDataFromDataBase("CX_FeaturedProductsJobs", predicate: NSPredicate(format: "fID == %@",FeaturedProductJobs.fID!), ispredicate: true, orederByKey: "").dataArray[0] as?CX_FeaturedProductsJobs)!
            
            self.productString = featuredProductJobs.json
            self.type = productDetailDic.value(forKey: "jobTypeName") as! String
            
            let floatPrice: Float = Float(CXDataProvider.sharedInstance.getJobID("MRP", inputDic: featuredProductJobs.json!))!
            let finalPrice = String(format: floatPrice == floor(floatPrice) ? "%.0f" : "%.1f", floatPrice)
            
            let floatDiscount:Float = Float(CXDataProvider.sharedInstance.getJobID("DiscountAmount", inputDic: featuredProductJobs.json!))!
            let finalDiscount = String(format: floatDiscount == floor(floatDiscount) ? "%.0f" : "%.1f", floatDiscount)
            
            //FinalPrice after subtracting the discount
            let finalPriceNum:Int = Int(finalPrice)!-Int(finalDiscount)!
            let FinalPrice = String(finalPriceNum) as String
            
            self.FinalPrice = FinalPrice
            
        }else{
            
            let products:CX_Products = (self.products[indexPath.item] as? CX_Products)!
            self.productString = products.json
            //Trimming Price And Discount
            let floatPrice: Float = Float(CXDataProvider.sharedInstance.getJobID("MRP", inputDic: products.json!))!
            let finalPrice = String(format: floatPrice == floor(floatPrice) ? "%.0f" : "%.1f", floatPrice)
            
            let floatDiscount:Float = Float(CXDataProvider.sharedInstance.getJobID("DiscountAmount", inputDic: products.json!))!
            let finalDiscount = String(format: floatDiscount == floor(floatDiscount) ? "%.0f" : "%.1f", floatDiscount)
            
            //FinalPrice after subtracting the discount
            let finalPriceNum:Int! = Int(finalPrice)!-Int(finalDiscount)!
            let FinalPrice = String(finalPriceNum) as String
            
            self.FinalPrice = FinalPrice
            self.type = productDetailDic.value(forKey:"jobTypeName") as! String
            
        }
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
            print(productDetailDic)
            orders.productDetails = self.productDetailDic
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
