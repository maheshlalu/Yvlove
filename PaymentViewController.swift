//
//  PaymentViewController.swift
//  NeedyBee123
//
//  Created by apple on 21/03/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class PaymentViewController: UIViewController,UITextFieldDelegate,paymentDelegate,PGTransactionDelegate {
    
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
    @IBOutlet weak var otherPaymenOtionBtn: UIButton!
    
    var totalFinalData = NSInteger()
    var standerdShipp = NSInteger()
    var giftAmount = NSInteger()
    
    var products = NSMutableArray()
    var dataDict:NSMutableDictionary = NSMutableDictionary()
    
    // payment btn
    @IBOutlet weak var cashonDeleveryBtn: UIButton!
    @IBOutlet weak var netBankingBtn: UIButton!
    @IBOutlet weak var prepaidBtn: UIButton!
    
    //shipping Methods
    @IBOutlet weak var standedshippinbtn: UIButton!
    @IBOutlet weak var overNightShippingBtn: UIButton!
    @IBOutlet weak var expenditeShippinBtn: UIButton!
   
    //PayU
    var params : PUMRequestParams = PUMRequestParams.shared()
    var utils : Utils = Utils()
    
    var isCOD = false
    var isCreditOrDebit = false
    var isNetBanking = false
    var isPayTm = false
    var isPayPal = false
    var isPayUBiz = false
    var isAmazonPay = false
    var isOtherOptions = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 255/255.0, green: 145/255.0, blue: 0/255.0, alpha: 1.0)
        self.giftLabel1.textColor = UIColor.lightGray
        self.giftLabel2.textColor = UIColor.lightGray
        self.giftLabel3.textColor = UIColor.lightGray
        getTheProducts()
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.contentSize.height = 780
        standerdShipp = 0
        giftAmount = 0
        makeStangeredShippingBtn()
    }
    
    func makeStangeredShippingBtn(){
        self.standedshippinbtn.setImage(UIImage(named: "CheckedFill"), for: .normal)
        self.expenditeShippinBtn.setImage(UIImage(named: "UncheckedImahe"), for: .normal)
        self.overNightShippingBtn.setImage(UIImage(named: "UncheckedImahe"), for: .normal)
        standerdShipp = 0
        
        if totalFinalData < 350{
            self.totalPayAmountlbl.text = String(totalFinalData + 40 + standerdShipp + giftAmount)
            print(self.totalPayAmountlbl.text!)
            standerdShipp = 40 + standerdShipp
            print(standerdShipp)
        }else{
            self.totalPayAmountlbl.text = String(totalFinalData + standerdShipp + giftAmount)
        }
    }
    
    func uncheckingThePaymentMethodButtons(){
        self.cashonDeleveryBtn.setImage(UIImage(named: "UncheckedImahe"), for: .normal)
        self.prepaidBtn.setImage(UIImage(named: "UncheckedImahe"), for: .normal)
        self.netBankingBtn.setImage(UIImage(named: "UncheckedImahe"), for: .normal)
        self.otherPaymenOtionBtn.setImage(UIImage(named: "UncheckedImahe"), for: .normal)
        self.discountCreditDebitcardlbl.text = "0.00"
        let total = String(Float(totalPayAmountlbl.text!)! - 0)
        self.totalPayAmountlbl.text = total
    }
    
    func uncheckingGiftOptions(){
        self.totalPayAmountlbl.text = String(Int(Float(self.totalPayAmountlbl.text!)!) - giftAmount)
        giftAmount = 0
        self.giftWrapOtinanBtn.setImage(UIImage(named: "UncheckedImahe"), for: .normal)
        giftWrapOtinanBtn.isSelected = false
        giftBtn1.isEnabled = false
        giftBtn2.isEnabled = false
        giftBtn3.isEnabled = false
        self.giftLabel1.textColor = UIColor.lightGray
        self.giftLabel2.textColor = UIColor.lightGray
        self.giftLabel3.textColor = UIColor.lightGray
        self.giftBtn3.setImage(UIImage(named: "UncheckedImahe"), for: .normal)
        self.giftBtn2.setImage(UIImage(named: "UncheckedImahe"), for: .normal)
        self.giftBtn1.setImage(UIImage(named: "UncheckedImahe"), for: .normal)
    
    }
    
    func forApplyingCoupon(){
        uncheckingThePaymentMethodButtons()
        makeStangeredShippingBtn()
        uncheckingGiftOptions()
        
    }
    
    func getTheProducts(){
        let cartlist : NSArray =  CX_Cart.mr_findAll(with: NSPredicate(format: "addToCart = %@", "1")) as NSArray
        for obj in cartlist {
            let data = obj as! CX_Cart
            let total = (data.quantity as? NSInteger)! * (data.productPrice as? NSInteger)!
            totalFinalData = NSInteger(self.totalPayAmountlbl.text!)! + total
            self.totalPayAmountlbl.text = String(totalFinalData)
            self.ordersTotallbl.text = String(totalFinalData)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let menuItem = UIBarButtonItem(image: UIImage(named: "LeftArrow"), style: .plain, target: self, action: #selector(PaymentViewController.backBtnClicked))
        self.navigationItem.leftBarButtonItem = menuItem
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    func backBtnClicked(){
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: TextField Delegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
    
    //########################################################### COUPON ####################################################################
    //MARK: Coupon Button action
    @IBAction func couponCheckBtnTapped(_ sender: Any) {
        self.forApplyingCoupon()
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
    //########################################################### COUPON ###################################################################
    
    //########################################################### SHIPPING OPTIONS ###################################################################
    //MARK: Shipping Methods
    @IBAction func shippingMethodBtnTapped(_ sender: UIButton) {
        uncheckingThePaymentMethodButtons()
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
            self.totalPayAmountlbl.text = String(totalFinalData + 40 + standerdShipp + giftAmount)
            print(self.totalPayAmountlbl.text!)
            standerdShipp = 40 + standerdShipp
            print(standerdShipp)
        }else{
            self.totalPayAmountlbl.text = String(totalFinalData + standerdShipp + giftAmount)
        }
    }
    //########################################################### SHIPPING OPTIONS ###################################################################
    
    //########################################################### GIFT OPTIONS ###################################################################
    @IBAction func giftBtnAction(_ sender: UIButton) {
        uncheckingThePaymentMethodButtons()
        if sender.isSelected{
            //let totalPayAmount:Int = Int(self.totalPayAmountlbl.text!)!
            self.totalPayAmountlbl.text = String(Int(Float(self.totalPayAmountlbl.text!)!) - giftAmount)
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
        }
    }
    
    //MARK: Gift Wrap(Optional)
    @IBAction func papaerGiftBtnTapped(_ sender: UIButton) {
        // let Totalam = totalFinalData
        uncheckingThePaymentMethodButtons()
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
        self.totalPayAmountlbl.text = String(totalFinalData + standerdShipp + giftAmount)
    }
    //########################################################### GIFT OPTIONS ###################################################################
    
    //########################################################### PAYMENT OPTIONS ###################################################################
    //MARK: Payment Option Action
    @IBAction func paymentOptionBtnTapped(_ sender: UIButton){
        let totalAmountDis = Float(self.ordersTotallbl.text!)!
        print(self.totalPayAmountlbl.text!)
        var discountPrice:Float = Float()
        //  print("totalData \(totalAmountDis)")
        if sender.tag == 1 || sender.tag == 5 {
            let total = String(Float(totalPayAmountlbl.text!)! + Float(self.discountCreditDebitcardlbl.text!)!)
            self.totalPayAmountlbl.text = total
            if sender.tag == 1{
                self.cashonDeleveryBtn.setImage(UIImage(named: "CheckedFill"), for: .normal)
                self.prepaidBtn.setImage(UIImage(named: "UncheckedImahe"), for: .normal)
                self.netBankingBtn.setImage(UIImage(named: "UncheckedImahe"), for: .normal)
                self.otherPaymenOtionBtn.setImage(UIImage(named: "UncheckedImahe"), for: .normal)
                self.discountCreditDebitcardlbl.text = "0.00"
                discountPrice = 0
                isCOD = true
            }else if sender.tag == 5{
                self.cashonDeleveryBtn.setImage(UIImage(named: "UncheckedImahe"), for: .normal)
                self.prepaidBtn.setImage(UIImage(named: "UncheckedImahe"), for: .normal)
                self.netBankingBtn.setImage(UIImage(named: "UncheckedImahe"), for: .normal)
                self.otherPaymenOtionBtn.setImage(UIImage(named: "CheckedFill"), for: .normal)
                discountPrice = 0
                self.discountCreditDebitcardlbl.text = "0.00"
                isOtherOptions = true
            }
        }else if sender.tag == 2 || sender.tag == 3{
            let total = String(Float(totalPayAmountlbl.text!)! + Float(self.discountCreditDebitcardlbl.text!)!)
            self.totalPayAmountlbl.text = total
            if sender.tag == 2{
                self.cashonDeleveryBtn.setImage(UIImage(named: "UncheckedImahe"), for: .normal)
                self.prepaidBtn.setImage(UIImage(named: "CheckedFill"), for: .normal)
                self.netBankingBtn.setImage(UIImage(named: "UncheckedImahe"), for: .normal)
                self.otherPaymenOtionBtn.setImage(UIImage(named: "UncheckedImahe"), for: .normal)
                isCreditOrDebit = true
            }else if sender.tag == 3{
                self.cashonDeleveryBtn.setImage(UIImage(named: "UncheckedImahe"), for: .normal)
                self.prepaidBtn.setImage(UIImage(named: "UncheckedImahe"), for: .normal)
                self.netBankingBtn.setImage(UIImage(named: "CheckedFill"), for: .normal)
                self.otherPaymenOtionBtn.setImage(UIImage(named: "UncheckedImahe"), for: .normal)
                isNetBanking = true
            }
            discountPrice = totalAmountDis * 0.03
            self.discountCreditDebitcardlbl.text = String(discountPrice)
        }
        
        let total = String(Float(totalPayAmountlbl.text!)! - discountPrice)
        self.totalPayAmountlbl.text = total
    }
    //########################################################### PAYMENT OPTIONS ###################################################################
}

extension PaymentViewController{
    
    @IBAction func paymentBtnAction(_ sender: Any) {
        
        print("\(standerdShipp) \(giftAmount) \(discountCreditDebitcardlbl.text)")
        print(dataDict)
        
        let name = dataDict.value(forKey: "name")
        let email = dataDict.value(forKey: "email")
        let address1 = dataDict.value(forKey: "addressLine1")
        let address2 = dataDict.value(forKey: "addressLine2")
        let mobile = dataDict.value(forKey: "mobile")
        
        /*PlaceOrder_COD
         PlaceOrder_AmazonPay
         PlaceOrder_Paytm
         PlaceOrder_Instamojo
         PlaceOrder_Paypal
         PlaceOrder_PayUBiz
         PlaceOrder_BankTransfer*/
        
        if isCOD{
            CXAppDataManager.sharedInstance.placeOder(name as! String, email:email as! String, address1:address1 as! String, address2:address2 as! String, number: mobile as! String ,subTotal:self.totalPayAmountlbl.text!,orderType:"PlaceOrder_COD" ,completion: { (isDataSaved) in
                self.dismiss(animated: true, completion: {self.view.makeToast(message: "Product Ordered Successfully!!!")})
            })
        }else if isCreditOrDebit || isNetBanking{
            CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getTestPaymentGatewayUrl(), parameters: ["name":name as AnyObject,"email":email as AnyObject,"amount":self.totalPayAmountlbl.text! as AnyObject,"description":"NeedyBee Payment" as AnyObject, "Phone":mobile as AnyObject,"macId":UserDefaults.standard.value(forKey: "MAC_ID")! as AnyObject,"mallId":CXAppConfig.sharedInstance.getAppMallID() as AnyObject]) { (responseDict) in
                
                let payMentCntl : CXPayMentController = CXPayMentController()
                payMentCntl.paymentUrl =  NSURL(string: responseDict.value(forKey: "payment_url")! as! String)
                self.navigationController?.pushViewController(payMentCntl, animated: true)
                
                payMentCntl.paymentDelegate  = self
                payMentCntl.completion = {_ in responseDict
                    print(responseDict)
                    CXAppDataManager.sharedInstance.placeOder(name as! String, email:email as! String, address1:address1 as! String, address2:address2 as! String, number: mobile as! String ,subTotal:self.totalPayAmountlbl.text!,orderType:"PlaceOrder_Instamojo" ,completion: { (isDataSaved) in
                        self.dismiss(animated: true, completion: {self.view.makeToast(message: "Product Ordered Successfully!!!")})
                    })
                }
            }
        }else if isNetBanking{
            CXAppDataManager.sharedInstance.placeOder(name as! String, email:email as! String, address1:address1 as! String, address2:address2 as! String, number: mobile as! String ,subTotal:self.totalPayAmountlbl.text!,orderType:"PlaceOrder_BankTransfer" ,completion: { (isDataSaved) in
                self.dismiss(animated: true, completion: {self.view.makeToast(message: "Product Ordered Successfully!!!")})
            })
        }else if isOtherOptions{
            self.otherPaymentListAlert()
        }
    }
    
    //MARK: Other payment Otions (AlertView)
    func otherPaymentListAlert(){
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Paytm", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Paytm clicked")
            self.paytmOptionTapped()
            
        })
        let saveAction = UIAlertAction(title: "PayU Biz", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.payUstartPayment()
            
        })
        let amezonAction = UIAlertAction(title: "Amazon Pay", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.showAlertViewWithTitle(title: "Alert", message: "under construction ")
        })
        let PaypalAction = UIAlertAction(title: "Paypal", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.showAlertViewWithTitle(title: "Alert", message: "under construction ")
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(amezonAction)
        optionMenu.addAction(PaypalAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
        
        
    }
    
    func paytmOptionTapped(){
        //Step 1: Create a default merchant config object
        let mc: PGMerchantConfiguration = PGMerchantConfiguration.default()
        
        //Step 2: If you have your own checksum generation and validation url set this here. Otherwise use the default Paytm urls
        
        mc.checksumGenerationURL = "https://pguat.paytm.com/paytmchecksum/paytmCheckSumGenerator.jsp"
        mc.checksumValidationURL = "https://pguat.paytm.com/paytmchecksum/paytmCheckSumVerify.jsp"
        
        //Step 3: Create the order with whatever params you want to add. But make sure that you include the merchant mandatory params
        let orderDict = NSMutableDictionary()
        
        orderDict["MID"] = "WorldP64425807474247"
        //Merchant configuration in the order object
        orderDict["CHANNEL_ID"] = "WAP"
        orderDict["INDUSTRY_TYPE_ID"] = "Retail"
        orderDict["WEBSITE"] = "worldpressplg"
        //Order configuration in the order object
        orderDict["TXN_AMOUNT"] = "100"
        orderDict["ORDER_ID"] = "TestMerchant000111008"
        orderDict["REQUEST_TYPE"] = "DEFAULT"
        orderDict["CUST_ID"] = "1234567890"
        orderDict["CALLBACK_URL"] = "https://pguat.paytm.com/paytmchecksum/paytmCheckSumVerify.jsp"
        orderDict["CHECKSUMHASH"] = "o3ARWrsxEfuJwDhkG7/m57ZU+YpHJWNVOTqJb9kfp0fbioRG/lsn1ReNBPUr0UKMMB5Iq4e/JUVSHrbFl9g1VyCyQqcHl/jPOqNvYHVE4Ko="
        
        let order: PGOrder = PGOrder(params: orderDict as[NSObject : AnyObject])
        
        print("oder list is \(order)")
        //Step 4: Choose the PG server. In your production build dont call selectServerDialog. Just create a instance of the
        //PGTransactionViewController and set the serverType to eServerTypeProduction
        PGServerEnvironment.selectServerDialog(self.view, completionHandler: {(type: ServerType) -> Void in
            
            let txnController = PGTransactionViewController.init(transactionFor: order)
            
            if type != eServerTypeNone {
                txnController?.serverType = type
                txnController?.merchant = mc
                txnController?.delegate = self
                self.showController(controller: txnController!)
            }
        })
        
    }
    //MARK : paytm integration
    func showController(controller: PGTransactionViewController) {
        
        if self.navigationController != nil {
            self.navigationController!.pushViewController(controller, animated: true)
        }
        else {
            self.present(controller, animated: true, completion: {() -> Void in
            })
        }
    }
    
    func removeController(controller: PGTransactionViewController) {
        if self.navigationController != nil {
            self.navigationController!.popViewController(animated: true)
        }
        else {
            controller.dismiss(animated: true, completion: {() -> Void in
            })
        }
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    // MARK: Delegate methods of Payment SDK.
    func didFinishedResponse(_ controller: PGTransactionViewController!, response responseString: String!) {
        print("response data is \(responseString.description)")
        let dict = convertToDictionary(text: responseString)
        print("Dict values \(dict)")
        //let respons
        
        
    }
    func didCancelTrasaction(_ controller: PGTransactionViewController!) {
        print("Cancel procees")
        self.removeController(controller: controller)
    }
    func errorMisssingParameter(_ controller: PGTransactionViewController!, error: Error!) {
        
        print("error data \(error)")
        
    }
}
