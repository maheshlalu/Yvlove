//
//  PaymentViewController.swift
//  NeedyBee123
//
//  Created by apple on 21/03/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class PaymentViewController: UIViewController,UITextFieldDelegate,paymentDelegate {
    @IBOutlet weak var giftLabel1: UILabel!
    @IBOutlet weak var giftLabel2: UILabel!
    @IBOutlet weak var giftLabel3: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var giftBtn1: UIButton!
    @IBOutlet weak var giftBtn2: UIButton!
    @IBOutlet weak var giftBtn3: UIButton!
    
    
    @IBOutlet weak var couponDiscountLbl: UILabel!
    @IBOutlet weak var giftWrapOtinanBtn: UIButton!
    @IBOutlet weak var discountCreditDebitcardlbl: UILabel!
    @IBOutlet weak var totalPayAmountlbl: UILabel!
    @IBOutlet weak var ordersTotallbl: UILabel!
    @IBOutlet weak var couponField: UITextField!
    var amountData = NSInteger()
    var products = NSMutableArray()
    var totalFinalData = NSInteger()
    //var totalAmountDis = NSInteger()
    var standerdShipp = NSInteger()
    var last = NSInteger()
    
    var giftAmount = NSInteger()
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
        //self.navigationItem.title = "Payment"
        self.giftLabel1.textColor = UIColor.lightGray
        self.giftLabel2.textColor = UIColor.lightGray
        self.giftLabel3.textColor = UIColor.lightGray
        getTheProducts()
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.contentSize.height = 780
        standerdShipp = 0
        giftAmount = 0
    }
    func getTheProducts(){
        let cartlist : NSArray =  CX_Cart.mr_findAll(with: NSPredicate(format: "addToCart = %@", "1")) as NSArray
        for obj in cartlist {
            let data = obj as! CX_Cart
            let total = (data.quantity as? NSInteger)! * (data.productPrice as? NSInteger)!
            amountData = NSInteger(self.totalPayAmountlbl.text!)! + total
            self.totalPayAmountlbl.text = String(amountData)
            totalFinalData = amountData
            self.ordersTotallbl.text = String(amountData)
        }
    }
    @IBAction func giftBtnAction(_ sender: UIButton) {
        
        if sender.isSelected{
            self.totalPayAmountlbl.text = String(Int(self.totalPayAmountlbl.text!)! - giftAmount)
            giftAmount = 0
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
            last = Int(self.totalPayAmountlbl.text!)!
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
            last = Int(self.totalPayAmountlbl.text!)!
        }
    }
    //MARK: Gift Wrap(Optional)
    @IBAction func papaerGiftBtnTapped(_ sender: UIButton) {
       // let Totalam = totalFinalData
        
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
        
        print("gift amount \(giftAmount)")
        self.totalPayAmountlbl.text = String(describing: totalFinalData + giftAmount + standerdShipp)
        last = Int(self.totalPayAmountlbl.text!)!
//        print("papaerGiftBtnTapped \(totalFinalData)")
        
        
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
        if !(couponField.text?.isEmpty)!{
            CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+"Services/applyCoupon?", parameters: ["orgId":CXAppConfig.sharedInstance.getAppMallID() as AnyObject,"couponCode":couponField.text as AnyObject]) { (responseDict) in
                print("CouponData \(responseDict)")
                let status: Int = Int(responseDict.value(forKey: "status") as! String)!
                if status == 1{
                    let couponType = responseDict.value(forKey: "couponType") as! String
                    let couponAmount = responseDict.value(forKey: "amount") as! String
                    self.convertCoponType(type: couponType, amount: couponAmount)
                }else{
                    self.showAlertView("Please enter valide Coupon Number", status: 0)
                    print("invalide data")
                }
            }
        }else{
            self.showAlertView("Please enter Coupon Number", status: 1)
        }
    }
    //MARK: AlertView
    func showAlertView(_ message:String, status:Int) {
        let alert = UIAlertController(title: "Alert!!", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.default) {
            UIAlertAction in
            if status == 1 {
                
            }
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    //MARK: Get Percentage coupon Type
    func convertCoponType(type: String,amount: String){
        let cartlist : NSArray =  CX_Cart.mr_findAll(with: NSPredicate(format: "addToCart = %@", "1")) as NSArray
        var discountAmount = NSInteger()
        if type == "percentage"{
            for obj in cartlist {
                let data = obj as! CX_Cart
                var total = (data.quantity as? NSInteger)! * (data.productPrice as? NSInteger)!
                total = (total * Int(amount)!)/100
                discountAmount = discountAmount + total
                couponDiscountLbl.text = String(total)
            }
            self.ordersTotallbl.text = String(describing: Int(self.ordersTotallbl.text!)! - discountAmount)
            self.totalPayAmountlbl.text = String(describing: Int(self.totalPayAmountlbl.text!)! - discountAmount)
        }else if type == "amount"{
            for obje in cartlist{
                let data = obje as! CX_Cart
                let total = (data.quantity as? NSInteger)! * Int(amount)!
                discountAmount = discountAmount + total
                couponDiscountLbl.text = String(total)
            }
            self.ordersTotallbl.text = String(describing: Int(self.ordersTotallbl.text!)! - discountAmount)
            self.totalPayAmountlbl.text = String(describing: Int(self.totalPayAmountlbl.text!)! - discountAmount)
        }
    }
    //MARK: Payment Option Action
    @IBAction func paymentOptionBtnTapped(_ sender: UIButton){
      var totalAmountDis = Int(self.ordersTotallbl.text!)!
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
        self.totalPayAmountlbl.text = String(describing: last - totalAmountDis)
    }
    //MARK: Shipping Methods
    @IBAction func shippingMethodBtnTapped(_ sender: UIButton) {
        
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
            self.totalPayAmountlbl.text = String(totalFinalData + 40 + standerdShipp)
        }else{
            self.totalPayAmountlbl.text = String(totalFinalData + standerdShipp + giftAmount)
        }
       // print("shipping amount is \(standerdShipp)")
        last = Int(self.totalPayAmountlbl.text!)!
    }
    
    @IBAction func paymentBtnAction(_ sender: Any) {
    CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getTestPaymentGatewayUrl(), parameters: ["name":UserDefaults.standard.value(forKey: "FIRST_NAME")! as AnyObject,"email":UserDefaults.standard.value(forKey: "USER_EMAIL")! as AnyObject,"amount":self.totalPayAmountlbl.text! as AnyObject,"description":"NeedyBee Payment" as AnyObject, "Phone":UserDefaults.standard.value(forKey: "MOBILE") as AnyObject,"macId":UserDefaults.standard.value(forKey: "MAC_ID")! as AnyObject,"mallId":CXAppConfig.sharedInstance.getAppMallID() as AnyObject]) { (responseDict) in
    
            let payMentCntl : CXPayMentController = CXPayMentController()
            payMentCntl.paymentUrl =  NSURL(string: responseDict.value(forKey: "payment_url")! as! String)
            self.navigationController?.pushViewController(payMentCntl, animated: true)
            
            payMentCntl.paymentDelegate  = self
            payMentCntl.completion = {_ in responseDict
                print(responseDict)
               // self.showAlertView(message: "Your payment is successfull", status: 0)
                
            }
            
        }
        
        
        
    }
    
}
