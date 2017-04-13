//
//  PaymentViewController.swift
//  NeedyBee123
//
//  Created by apple on 21/03/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit
class PaymentViewController: UIViewController,UITextFieldDelegate,paymentDelegate,PGTransactionDelegate,PayPalPaymentDelegate {
    var environment:String = PayPalEnvironmentNoNetwork {
        willSet(newEnvironment) {
            if (newEnvironment != environment) {
                PayPalMobile.preconnect(withEnvironment: newEnvironment)
            }
        }
    }
    var payPalConfig = PayPalConfiguration() // default
    
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
    
    var totalFinalData = Float()
    var standerdShipp = Float()
    var giftAmount = Float()
    
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
        self.title = "Payment"
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
        self.totalPayAmountlbl.text = String(Float(self.totalPayAmountlbl.text!)! - giftAmount)
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
            let total = (data.quantity as? Float)! * (data.productPrice as? Float)!
            totalFinalData = Float(self.totalPayAmountlbl.text!)! + total
            self.totalPayAmountlbl.text = String(totalFinalData)
            self.ordersTotallbl.text = String(totalFinalData)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let menuItem = UIBarButtonItem(image: UIImage(named: "LeftArrow"), style: .plain, target: self, action: #selector(PaymentViewController.backBtnClicked))
        self.navigationItem.leftBarButtonItem = menuItem
        self.navigationController?.navigationBar.tintColor = UIColor.white
        PayPalMobile.preconnect(withEnvironment: environment)
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
        var discountAmount = Float()
        if type == "Percentage(%)"{
            for obj in cartlist {
                let data = obj as! CX_Cart
                var total = (data.quantity as? Float)! * (data.productPrice as? Float)!
                total = (total * Float(amount)!)/100
                discountAmount = discountAmount + total
                couponDiscountLbl.text = String(discountAmount)
            }
            self.ordersTotallbl.text = String(describing: Float(self.ordersTotallbl.text!)! - discountAmount)
            self.totalPayAmountlbl.text = String(describing: Float(self.totalPayAmountlbl.text!)! - discountAmount)
        }else if type == "Amount"{
            for obje in cartlist{
                let data = obje as! CX_Cart
                let total = (data.quantity as? Float)! * Float(amount)!
                couponDiscountLbl.text = String(total)
                discountAmount = total
                
            }
            self.ordersTotallbl.text = String(describing: Float(self.ordersTotallbl.text!)! - Float(couponDiscountLbl.text!)!)
            self.totalPayAmountlbl.text = String(describing: Float(self.totalPayAmountlbl.text!)! - Float(couponDiscountLbl.text!)!)
        }
        totalFinalData = totalFinalData - discountAmount
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
            self.totalPayAmountlbl.text = String(Float(self.totalPayAmountlbl.text!)! - giftAmount)
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
            self.startPayment()
        })
        let amezonAction = UIAlertAction(title: "Amazon Pay", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.showAlertViewWithTitle(title: "Alert", message: "under construction ")
        })
        let PaypalAction = UIAlertAction(title: "Paypal", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.paypalbtnTapped()
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
        let mc: PGMerchantConfiguration = PGMerchantConfiguration.default()
        mc.checksumGenerationURL = "https://pguat.paytm.com/paytmchecksum/paytmCheckSumGenerator.jsp"
        mc.checksumValidationURL = "https://pguat.paytm.com/paytmchecksum/paytmCheckSumVerify.jsp"
        let orderDict = NSMutableDictionary()
        orderDict["MID"] = "WorldP64425807474247"
        orderDict["CHANNEL_ID"] = "WAP"
        orderDict["INDUSTRY_TYPE_ID"] = "Retail"
        orderDict["WEBSITE"] = "worldpressplg"
        orderDict["TXN_AMOUNT"] = "100"
        orderDict["ORDER_ID"] = "TestMerchant000111008"
        orderDict["REQUEST_TYPE"] = "DEFAULT"
        orderDict["CUST_ID"] = "1234567890"
        orderDict["CALLBACK_URL"] = "https://pguat.paytm.com/paytmchecksum/paytmCheckSumVerify.jsp"
        orderDict["CHECKSUMHASH"] = "o3ARWrsxEfuJwDhkG7/m57ZU+YpHJWNVOTqJb9kfp0fbioRG/lsn1ReNBPUr0UKMMB5Iq4e/JUVSHrbFl9g1VyCyQqcHl/jPOqNvYHVE4Ko="
        let order: PGOrder = PGOrder(params: orderDict as[NSObject : AnyObject])
        print("oder list is \(order)")
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
    }
    func didCancelTrasaction(_ controller: PGTransactionViewController!) {
        print("Cancel procees")
        self.removeController(controller: controller)
    }
    func errorMisssingParameter(_ controller: PGTransactionViewController!, error: Error!) {
        print("error data \(error)")
    }
    //MARK: PayU integration
    func startPayment() -> Void {
        params.amount = self.totalPayAmountlbl.text!
        params.environment = PUMEnvironment.test;
        params.firstname = dataDict.value(forKey: "name") as! String!
        params.key = "40747T"
        params.merchantid = "396132";  //Merchant merchantid
        params.logo_url = ""; //Merchant logo_url
        params.productinfo = "NeedyBee";
        params.email =  dataDict.value(forKey: "email") as! String! //user email
        params.phone = dataDict.value(forKey: "mobile") as! String! //user phone
        params.txnid = utils.getRandomString(2);  //set your correct transaction id here
        params.surl = "https://www.payumoney.com/mobileapp/payumoney/success.php";
        params.furl = "https://www.payumoney.com/mobileapp/payumoney/failure.php";
        params.udf1 = "";
        params.udf2 = "";
        params.udf3 = "";
        params.udf4 = "";
        params.udf5 = "";
        params.udf6 = "";
        params.udf7 = "";
        params.udf8 = "";
        params.udf9 = "";
        params.udf10 = "";
        if(params.environment == PUMEnvironment.production){
            generateHashForProdAndNavigateToSDK()
        }
        else{
            calculateHashFromServer()
        }
        params.delegate = self;
    }
    func generateHashForProdAndNavigateToSDK() -> Void {
        let txnid = params.txnid!
        let hashSequence : NSString = "\(params.key)|\(txnid)|\(params.amount)|\(params.productinfo)|\(params.firstname)|\(params.email)|||||||||||salt" as NSString
        let data :NSString = utils.createSHA512(hashSequence as String!) as NSString
        params.hashValue = data as String!;
        startPaymentFlow();
    }
    func transactinCanceledByUser() -> Void {
        self.dismiss(animated: true){
            self.showAlertViewWithTitle(title: "Message", message: "Payment Cancelled ")
        }
    }
    func startPaymentFlow() -> Void {
        let paymentVC : PUMMainVController = PUMMainVController()
        var paymentNavController : UINavigationController;
        paymentNavController = UINavigationController(rootViewController: paymentVC);
        self.present(paymentNavController, animated: true, completion: nil)
    }
    func transactionCompleted(withResponse response : NSDictionary,errorDescription error:NSError) -> Void {
        self.dismiss(animated: true){
            self.showAlertViewWithTitle(title: "Message", message: "congrats! Payment is Successful")
        }
    }
    func transactinFailed(withResponse response : NSDictionary,errorDescription error:NSError) -> Void {
        self.dismiss(animated: true){
            self.showAlertViewWithTitle(title: "Message", message: "Oops!!! Payment Failed")
        }
    }
    func showAlertViewWithTitle(title : String,message:String) -> Void {
        let alertController : UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            NSLog("OK Pressed")
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    // MARK:HASH CALCULATION
    
    func prepareHashBody()->NSString{
        return "key=\(params.key!)&amount=\(params.amount!)&txnid=\(params.txnid!)&productinfo=\(params.productinfo!)&email=\(params.email!)&firstname=\(params.firstname!)" as NSString;
    }
    func calculateHashFromServer(){
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        let url = URL(string: "https://test.payumoney.com/payment/op/v1/calculateHashForTest")!
        var request = URLRequest(url: url)
        request.httpBody = prepareHashBody().data(using: String.Encoding.utf8.rawValue)
        request.httpMethod = "POST"
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]{
                        //Implement your logic
                        print(json)
                        let status : NSNumber = json["status"] as! NSNumber
                        if(status.intValue == 0)
                        {
                            self.params.hashValue = json["result"] as! String!
                            OperationQueue.main.addOperation {
                                self.startPaymentFlow()
                            }
                        }
                        else{
                            OperationQueue.main.addOperation {
                                self.showAlertViewWithTitle(title: "Message", message: json["message"] as! String)
                            }
                        }
                    }
                } catch {
                    print("error in JSONSerialization")
                }
            }
        })
        task.resume()
    }
    //MARK: PayPal integration
    func paypalbtnTapped()
    {
        self.paypaldata()
        //print("PayPal iOS SDK Version: \(PayPalMobile.libraryVersion())")
        //let item1 = PayPalItem(name: "Old jeans with holes", withQuantity: 2, withPrice: NSDecimalNumber(string: "84.99"), withCurrency: "USD", withSku: "Hip-0037")
        //let item2 = PayPalItem(name: "Free rainbow patch", withQuantity: 1, withPrice: NSDecimalNumber(string: "0.00"), withCurrency: "USD", withSku: "Hip-00066")
        let item3 = PayPalItem(name: "Needybee", withQuantity: 1, withPrice: NSDecimalNumber(string: "37.99"), withCurrency: "USD", withSku: "IND-00291")
        let items = [item3]
        let subtotal = PayPalItem.totalPrice(forItems: items)
        let shipping = NSDecimalNumber(string: "5.99")
        let tax = NSDecimalNumber(string: "2.50")
        let paymentDetails = PayPalPaymentDetails(subtotal: subtotal, withShipping: shipping, withTax: tax)
        let total = subtotal.adding(shipping).adding(tax)
        let payment = PayPalPayment(amount: total, currencyCode: "USD", shortDescription: "NeedyBee products", intent: .sale)
        payment.items = items
        payment.paymentDetails = paymentDetails
        if (payment.processable) {
            let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
            print("Payment processalbe: \(payment)")
            present(paymentViewController!, animated: true, completion: nil)
        }
        else {
            print("Payment not processalbe: \(payment)")
        }
    }
    
    func paypaldata(){
        payPalConfig.acceptCreditCards = true
        payPalConfig.languageOrLocale = "en"
        payPalConfig.alwaysDisplayCurrencyCodes = true
        payPalConfig.defaultUserPhoneCountryCode = "(91+)"
        payPalConfig.defaultUserPhoneNumber = "8297211777"
        payPalConfig.defaultUserEmail = "challasrinu.mca@gmail.com"
        payPalConfig.merchantName = "Awesome Shirts, Inc."
        payPalConfig.merchantPrivacyPolicyURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
        payPalConfig.merchantUserAgreementURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")
        payPalConfig.languageOrLocale = Locale.preferredLanguages[0]
        payPalConfig.payPalShippingAddressOption = .payPal;
    }
    //MARK: PayPalPaymentDelegate
    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
        print("PayPal Payment Cancelled")
        paymentViewController.dismiss(animated: true, completion: nil)
    }
    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
        print("PayPal Payment Success !")
        paymentViewController.dismiss(animated: true, completion: { () -> Void in
            // send completed confirmaion to your server
            print("Here is your proof of payment:\n\n\(completedPayment.confirmation)\n\nSend this to your server for confirmation and fulfillment.")
        })
    }
}

////////////////////////// modifying ////////////////
/*{
 
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
 self.navigationController?.title = "Payment"
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
 var discountAmount = Float()
 if type == "Percentage(%)"{
 for obj in cartlist {
 let data = obj as! CX_Cart
 var total = (data.quantity as? Float)! * (data.productPrice as? Float)!
 total = (total * Float(amount)!)/100
 discountAmount = discountAmount + total
 couponDiscountLbl.text = String(discountAmount)
 }
 self.ordersTotallbl.text = String(describing: Float(self.ordersTotallbl.text!)! - discountAmount)
 self.totalPayAmountlbl.text = String(describing: Float(self.totalPayAmountlbl.text!)! - discountAmount)
 }else if type == "Amount"{
 for obje in cartlist{
 let data = obje as! CX_Cart
 let total = (data.quantity as? Float)! * Float(amount)!
 couponDiscountLbl.text = String(total)
 discountAmount = total
 
 }
 self.ordersTotallbl.text = String(describing: Float(self.ordersTotallbl.text!)! - Float(couponDiscountLbl.text!)!)
 self.totalPayAmountlbl.text = String(describing: Float(self.totalPayAmountlbl.text!)! - Float(couponDiscountLbl.text!)!)
 // totalFinalData = totalFinalData - Int(couponDiscountLbl.text!)!
 // print("totla data \(NSInteger(self.totalPayAmountlbl!.text!)!)")
 
 
 }
 
 print("after discount \(totalFinalData - Int(discountAmount))")
 totalFinalData = totalFinalData - Int(discountAmount)
 //print("totla data \(Int(self.totalPayAmountlbl.text!)!)")
 //self.totalFinalData = Int(self.totalPayAmountlbl.text!)!
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
 }*/
