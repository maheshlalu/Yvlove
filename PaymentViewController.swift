//
//  PaymentViewController.swift
//  NeedyBee123
//
//  Created by apple on 21/03/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class PaymentViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var giftLabel1: UILabel!
    @IBOutlet weak var giftLabel2: UILabel!
    @IBOutlet weak var giftLabel3: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var giftBtn1: UIButton!
    @IBOutlet weak var giftBtn2: UIButton!
    @IBOutlet weak var giftBtn3: UIButton!
    
    @IBOutlet weak var giftWrapOtinanBtn: UIButton!
    @IBOutlet weak var discountCreditDebitcardlbl: UILabel!
    @IBOutlet weak var totalPayAmountlbl: UILabel!
    @IBOutlet weak var ordersTotallbl: UILabel!
    @IBOutlet weak var couponField: UITextField!
    var amountData = NSInteger()
    var products = NSMutableArray()
    var sampleData = NSInteger()
    var totalFinalData = NSInteger()
    var deselectAmount = NSInteger()
    // payment btn
    @IBOutlet weak var cashonDeleveryBtn: UIButton!
    @IBOutlet weak var netBankingBtn: UIButton!
    @IBOutlet weak var prepaidBtn: UIButton!
    //shipping Methods
    @IBOutlet weak var standedshippinbtn: UIButton!
    @IBOutlet weak var overNightShippingBtn: UIButton!
    @IBOutlet weak var expenditeShippinBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 255/255.0, green: 145/255.0, blue: 0/255.0, alpha: 1.0)
        self.navigationItem.title = "Payment"
        self.giftLabel1.textColor = UIColor.lightGray
        self.giftLabel2.textColor = UIColor.lightGray
        self.giftLabel3.textColor = UIColor.lightGray
        getTheProducts()
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.contentSize.height = 780
    }
    
    func getTheProducts(){
        let cartlist : NSArray =  CX_Cart.mr_findAll(with: NSPredicate(format: "addToCart = %@", "1")) as NSArray
        for obj in cartlist {
            let data = obj as! CX_Cart
            let total = (data.quantity as? NSInteger)! * (data.productPrice as? NSInteger)!
            amountData = NSInteger(self.totalPayAmountlbl.text!)! + total
            self.totalPayAmountlbl.text = String(amountData)
            print("total amount \(amountData)")
            totalFinalData = amountData
            self.ordersTotallbl.text = String(amountData)
        }
        print("tot ?? \(totalFinalData)")
        
    }
    @IBAction func giftBtnAction(_ sender: UIButton) {
        print("gift data \(totalFinalData)")
        
        if sender.isSelected{
            self.giftWrapOtinanBtn.setImage(UIImage(named: "UncheckedImahe"), for: .normal)
            sender.isSelected  = false
            giftBtn1.isEnabled = false
            giftBtn2.isEnabled = false
            giftBtn3.isEnabled = false
            self.giftLabel1.textColor = UIColor.lightGray
            self.giftLabel2.textColor = UIColor.lightGray
            self.giftLabel3.textColor = UIColor.lightGray
            self.giftBtn3.setImage(UIImage(named: "UncheckedImahe"), for: .normal)
            self.giftBtn2.setImage(UIImage(named: "UncheckedImahe"), for: .normal)
            self.giftBtn1.setImage(UIImage(named: "UncheckedImahe"), for: .normal)
            self.totalPayAmountlbl.text = String(totalFinalData)
            print(" deselect gift data \(totalFinalData)")
        }
        else{
            self.giftWrapOtinanBtn.setImage(UIImage(named: "CheckedFill"), for: .normal)
            sender.isSelected  = true
            giftBtn1.isEnabled = true
            giftBtn2.isEnabled = true
            giftBtn3.isEnabled = true
            self.giftLabel1.textColor = UIColor.black
            self.giftLabel2.textColor = UIColor.black
            self.giftLabel3.textColor = UIColor.black
            totalFinalData = Int(self.totalPayAmountlbl.text!)!
            print("selected gift data \(totalFinalData)")
        }
    }
    //MARK: Gift Wrap(Optional)
    @IBAction func papaerGiftBtnTapped(_ sender: UIButton) {
        let Totalam = totalFinalData
        var giftAmount = NSInteger()
        if sender.tag == 1{
            self.giftBtn3.setImage(UIImage(named: "UncheckedImahe"), for: .normal)
            self.giftBtn2.setImage(UIImage(named: "UncheckedImahe"), for: .normal)
            self.giftBtn1.setImage(UIImage(named: "CheckedFill"), for: .normal)
            giftAmount = 40
            
        }else if sender.tag == 2 {
            self.giftBtn3.setImage(UIImage(named: "UncheckedImahe"), for: .normal)
            self.giftBtn2.setImage(UIImage(named: "CheckedFill"), for: .normal)
            self.giftBtn1.setImage(UIImage(named: "UncheckedImahe"), for: .normal)
            giftAmount = 70
        }else if sender.tag == 3{
            self.giftBtn3.setImage(UIImage(named: "CheckedFill"), for: .normal)
            self.giftBtn2.setImage(UIImage(named: "UncheckedImahe"), for: .normal)
            self.giftBtn1.setImage(UIImage(named: "UncheckedImahe"), for: .normal)
            giftAmount = 100
            
        }
        self.totalPayAmountlbl.text = String(describing: Totalam + giftAmount)
        print("papaerGiftBtnTapped \(totalFinalData)")
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        let menuItem = UIBarButtonItem(image: UIImage(named: "LeftArrow"), style: .plain, target: self, action: #selector(PaymentViewController.backBtnClicked))
        self.navigationItem.leftBarButtonItem = menuItem
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    func backBtnClicked()
    {
        self.dismiss(animated: true, completion: nil)
    }
    //MARK: TextField Delegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    //MARK: Coupon Button action
    @IBAction func couponCheckBtnTapped(_ sender: Any) {
        // http://apps.storeongo.com:8081/Services/applyCoupon?orgId=4&couponCode=MARCH0618
        //var couponData = NSDictionary()
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+"Services/applyCoupon?", parameters: ["orgId":CXAppConfig.sharedInstance.getAppMallID() as AnyObject,"couponCode":"SALE10P" as AnyObject]) { (responseDict) in
            print("CouponData \(responseDict)")
            let status: Int = Int(responseDict.value(forKey: "status") as! String)!
            if status == 1{
                let couponType = responseDict.value(forKey: "couponType") as! String
                let couponAmount = responseDict.value(forKey: "amount") as! String
                self.convertCoponType(type: couponType, amount: couponAmount)
            }else{
                print("invalide data")
            }
        }
    }
    
    //MARK: Get Percentage coupon Type
    func convertCoponType(type: String,amount: String){
        print("typpe :\(type) Amount :\(amount)")
        let cartlist : NSArray =  CX_Cart.mr_findAll(with: NSPredicate(format: "addToCart = %@", "1")) as NSArray
        var discountAmount = NSInteger()
        if type == "percentage"{
            for obj in cartlist {
                let data = obj as! CX_Cart
                var total = (data.quantity as? NSInteger)! * (data.productPrice as? NSInteger)!
                // print("data amount is \(total)")
                total = (total * Int(amount)!)/100
                // print("Discount Price \(total)")
                discountAmount = discountAmount + total
            }
            // print("total Dis \(discountAmount)")
            self.ordersTotallbl.text = String(describing: Int(self.ordersTotallbl.text!)! - discountAmount)
            self.totalPayAmountlbl.text = String(describing: Int(self.totalPayAmountlbl.text!)! - discountAmount)
            
           // totalFinalData = NSInteger(self.totalPayAmountlbl.text!)!
            
        }else if type == "Amount"{
            for obje in cartlist{
                let data = obje as! CX_Cart
                let total = (data.quantity as? NSInteger)! * Int(amount)!
                // print("data amount is \(total)")
                //amount = total - Int(amount)!
                //print("Discount Price \(Int(amount)!)")
                discountAmount = discountAmount + total
            }
            
            // print("total Dis \(discountAmount)")
            self.ordersTotallbl.text = String(describing: Int(self.ordersTotallbl.text!)! - discountAmount)
            self.totalPayAmountlbl.text = String(describing: Int(self.totalPayAmountlbl.text!)! - discountAmount)
           // totalFinalData = NSInteger(self.totalPayAmountlbl.text!)!
        }
        
        
    }
    //MARK: Payment Option Action
    @IBAction func paymentOptionBtnTapped(_ sender: UIButton){
        var totalAmountDis = totalFinalData
         print("papaerGiftBtnTapped \(totalFinalData)")
        //  print("totalData \(totalAmountDis)")
        if sender.tag == 1{
            self.cashonDeleveryBtn.setImage(UIImage(named: "CheckedFill"), for: .normal)
            self.prepaidBtn.setImage(UIImage(named: "UncheckedImahe"), for: .normal)
            self.netBankingBtn.setImage(UIImage(named: "UncheckedImahe"), for: .normal)
            totalAmountDis = 0
            self.discountCreditDebitcardlbl.text = "0.00"
        }else if sender.tag == 2 {
            self.cashonDeleveryBtn.setImage(UIImage(named: "UncheckedImahe"), for: .normal)
            self.prepaidBtn.setImage(UIImage(named: "CheckedFill"), for: .normal)
            self.netBankingBtn.setImage(UIImage(named: "UncheckedImahe"), for: .normal)
            totalAmountDis = (totalAmountDis * 3)/100
            self.discountCreditDebitcardlbl.text = String(totalAmountDis)
            
        }else if sender.tag == 3{
            self.cashonDeleveryBtn.setImage(UIImage(named: "UncheckedImahe"), for: .normal)
            self.prepaidBtn.setImage(UIImage(named: "UncheckedImahe"), for: .normal)
            self.netBankingBtn.setImage(UIImage(named: "CheckedFill"), for: .normal)
            totalAmountDis = (totalAmountDis * 3)/100
            self.discountCreditDebitcardlbl.text = String(totalAmountDis)
        }
        print("discount Data is \(totalAmountDis)")
       // self.totalPayAmountlbl.text = String(describing: Int(self.totalPayAmountlbl.text!)! - totalAmountDis)
        
    }
    //MARK: Shipping Methods
    
    @IBAction func shippingMethodBtnTapped(_ sender: UIButton) {
        var standerdShipp = NSInteger()
         print("shippingMethodBtnTapped \(totalFinalData)")
        if sender.tag == 1{
            self.standedshippinbtn.setImage(UIImage(named: "CheckedFill"), for: .normal)
            self.expenditeShippinBtn.setImage(UIImage(named: "UncheckedImahe"), for: .normal)
            self.overNightShippingBtn.setImage(UIImage(named: "UncheckedImahe"), for: .normal)
            
            standerdShipp = 0
        }else if sender.tag == 2{
            
            self.standedshippinbtn.setImage(UIImage(named: "UncheckedImahe"), for: .normal)
            self.expenditeShippinBtn.setImage(UIImage(named: "CheckedFill"), for: .normal)
            self.overNightShippingBtn.setImage(UIImage(named: "UncheckedImahe"), for: .normal)
            standerdShipp = 40
        }else if sender.tag == 3{
            self.standedshippinbtn.setImage(UIImage(named: "UncheckedImahe"), for: .normal)
            self.expenditeShippinBtn.setImage(UIImage(named: "UncheckedImahe"), for: .normal)
            self.overNightShippingBtn.setImage(UIImage(named: "CheckedFill"), for: .normal)
            standerdShipp = 280
        }
        
        if totalFinalData < 350{
        self.totalPayAmountlbl.text = String(totalFinalData + 40)
        
        }else{
        
            self.totalPayAmountlbl.text = String(totalFinalData + standerdShipp)
        
        }
        print("shippingMethodBtnTapped lbl \(self.totalPayAmountlbl.text)")
        deselectAmount = amountData
        
    }
    
    
    
    
}
