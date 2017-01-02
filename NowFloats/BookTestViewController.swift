//
//  BookTestViewController.swift
//  NowFloats
//
//  Created by Manishi on 12/13/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit

class BookTestViewController: CXViewController ,UITextFieldDelegate,UIScrollViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource{
    
    @IBOutlet weak var fullNameTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var add1TxtField: UITextField!
    @IBOutlet weak var add2TxtField: UITextField!
    @IBOutlet weak var mobileTxtField: UITextField!
    @IBOutlet weak var chooseTimeTxtField: UITextField!
    @IBOutlet weak var chooseDateTxtField: UITextField!
    @IBOutlet weak var bookNowBt: UIButton!
    @IBOutlet weak var cScrollView: UIScrollView!
    
    let toolBar:UIToolbar! = UIToolbar()
    var isDatePicker:Bool = false
    let limitLength = 10
    var productDetails:NSDictionary!
    
    var pickOption = ["6:00AM - 6:30AM","6:30AM - 7:00AM","7:00AM - 7:30AM","7:30 AM - 8:00AM","8:00 AM - 8:30AM","8:30 AM - 9:00AM","9:00 AM - 9:30AM","9:30 AM - 10:00AM", "10:00 AM - 10:30AM", "10:30 AM - 11:00AM", "11:00 AM - 11:30AM", "11:30 AM - 12:00PM","12:00 PM - 12:30PM", "12:30 PM - 1:00PM", "1:00 PM - 1:30PM", "1:30 PM - 2:00PM", "2:00 PM - 2:30PM","2:30 PM - 3:00PM", "3:00 PM - 3:30PM","3:30 PM - 4:00PM", "4:00 PM - 4:30PM","4:30 PM - 5:00PM", "5:00 PM - 5:30PM"]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.dataIntegration()
        self.timePicker()
        self.datePicker()
        
        self.bookNowBt.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
        
        //  let tap = UITapGestureRecognizer(target: self, action: #selector(BookTestViewController.handleTap(sender:)))
        // self.view.addGestureRecognizer(tap)
    }
    
    func dataIntegration(){
        fullNameTxtField.text = UserDefaults.standard.value(forKey: "FULL_NAME") as? String
        mobileTxtField.text = UserDefaults.standard.value(forKey: "MOBILE") as? String
        emailTxtField.text = UserDefaults.standard.value(forKey: "USER_EMAIL") as? String
        add1TxtField.isEnabled = true
    }
    
    func timePicker(){

        let pickerView = UIPickerView()
        self.toolBarView()
        pickerView.delegate = self
        chooseTimeTxtField.inputView = pickerView
        chooseTimeTxtField.inputAccessoryView = toolBar
    }
    
    func datePicker(){
        
        let currentDate: NSDate = NSDate()
        let datePickerView  : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        let gregorian: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let components: NSDateComponents = NSDateComponents()
        
        components.day = 0
        let minDate: NSDate = gregorian.date(byAdding: components as DateComponents, to: currentDate as Date, options: NSCalendar.Options(rawValue: 0))! as NSDate
        
        components.day = 7
        let maxDate: NSDate = gregorian.date(byAdding: components as DateComponents, to: currentDate as Date, options: NSCalendar.Options(rawValue: 0))! as NSDate
        
        datePickerView.minimumDate = minDate as Date
        datePickerView.maximumDate = maxDate as Date
        
        self.toolBarView()
        
        chooseDateTxtField.inputView = datePickerView
        chooseDateTxtField.inputAccessoryView = toolBar
        
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
    }
    
    func toolBarView(){
        
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = CXAppConfig.sharedInstance.getAppTheamColor()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action:  #selector(BookTestViewController.cancelPicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
    }
    
    func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        chooseDateTxtField.text = dateFormatter.string(from: sender.date)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.cScrollView.endEditing(true)
    }
    
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        // handling code
        
        self.view.endEditing(true)
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickOption.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        chooseTimeTxtField.text =  pickOption[row]
        return pickOption[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        chooseTimeTxtField.text =  pickOption[row]
    }
    
    func cancelPicker() {
        chooseTimeTxtField.resignFirstResponder()
        chooseDateTxtField.resignFirstResponder()
    }
    
    //    func cancelForDate(){
    //        let dateFormatter = DateFormatter()
    //        let currentDate: NSDate = NSDate()
    //        dateFormatter.dateFormat = "dd/MM/yyyy"
    //        chooseDateTxtField.text = dateFormatter.string(from: currentDate as Date)
    //        chooseDateTxtField.resignFirstResponder()
    //    }
    
    @IBAction func bookNowAction(_ sender: Any) {
        
        self.view.endEditing(true)
        
        if (self.fullNameTxtField.text?.characters.count)! > 0
            && (self.add1TxtField.text?.characters.count)! > 0
            && (self.emailTxtField.text?.characters.count)! > 0
            && (self.chooseTimeTxtField.text?.characters.count)! > 0 &&
            (self.mobileTxtField.text?.characters.count)! > 0 && (chooseDateTxtField.text?.characters.count)! > 0 {
            
            if !self.isValidEmail(self.emailTxtField.text!) {
                let alert = UIAlertController(title: "Alert!!!", message: "Please enter valid email address.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }
            
            if (self.mobileTxtField.text?.characters.count)! < 10 {
                let alert = UIAlertController(title: "Alert!!!", message: "Please enter valid Phone number.", preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    //self.navigationController?.popViewControllerAnimated(true)
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
            self.bookTestCall()
            
        } else {
            let alert = UIAlertController(title: "Alert!!!", message: "All fields are mandatory. Please enter all fields.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func isValidEmail(_ email: String) -> Bool {
        // print("validate email: \(email)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if emailTest.evaluate(with: email) {
            return true
        }
        return false
    }
    
    func bookTestCall(){
        
        
        let name = self.fullNameTxtField.text! as String
        let mobile = self.mobileTxtField.text! as String
        let address = (self.add1TxtField.text! + self.add2TxtField.text!) as String
        let email = self.emailTxtField.text! as String
        let orderItemId = self.productDetails.value(forKey: "id")!
        let orderItemQuantity = "1"
        
        
        
        let floatPrice: Float = Float(CXAppConfig.sharedInstance.getTheDataInDictionaryFromKey(sourceDic: self.productDetails, sourceKey: "MRP"))!
        
        let finalPrice = String(format: floatPrice == floor(floatPrice) ? "%.0f" : "%.1f", floatPrice)
        //DiscountAmount
        let floatDiscount:Float = Float(CXAppConfig.sharedInstance.getTheDataInDictionaryFromKey(sourceDic: self.productDetails, sourceKey: "DiscountAmount"))!
        let finalDiscount = String(format: floatDiscount == floor(floatDiscount) ? "%.0f" : "%.1f", floatDiscount)
        
        //FinalPrice after subtracting the discount
        let finalPriceNum:Int! = Int(finalPrice)!-Int(finalDiscount)!
        let FinalPrice = String(finalPriceNum) as String
        
        
        let orderItemName = (productDetails.value(forKey:"Name") as? String)!
        let orderItemMRP = FinalPrice
        let orderItemSubTotal = FinalPrice
        let diagnosticCenter = "MyLabz"
        let SampleCollectionTime = (self.chooseDateTxtField.text! as String)+" "+(self.chooseTimeTxtField.text! as String)
        
        let populatedDictionary : NSMutableDictionary = NSMutableDictionary(objects: [name,address,mobile,orderItemId,orderItemQuantity,orderItemName,orderItemMRP,orderItemSubTotal,diagnosticCenter,SampleCollectionTime],
                                                                            
                                                                            forKeys: ["Name" as NSCopying,"Address" as NSCopying,"Contact_Number" as NSCopying,"OrderItemId" as NSCopying,"OrderItemQuantity" as NSCopying,"OrderItemName" as NSCopying,"OrderItemMRP" as NSCopying,"OrderItemSubTotal" as NSCopying,"Diagnostic_Centre" as NSCopying,"Sample_Collection_Time" as NSCopying])
        
        //        let populatedDictionary = ["Name":name,"Contact_Number":mobile,"Address":address,"OrderItemId":orderItemId,"OrderItemQuantity":orderItemQuantity,"OrderItemName":orderItemName,"OrderItemMRP":orderItemMRP,"OrderItemSubTotal":orderItemSubTotal,"Diagnostic_Centre":diagnosticCenter,"Sample_Collection_Time":SampleCollectionTime] as NSMutableDictionary
        
        print(populatedDictionary)
        /*    Address = hgggtest;
         "Contact_Number" = 9640339556;
         "Diagnostic_Centre" = MyLabz;
         Name = "mahesh y";
         OrderItemId = 25614;
         OrderItemMRP = "150.0";
         OrderItemName = "Blood Urea";
         OrderItemQuantity = 1;
         OrderItemSubTotal = "150.0";
         "Sample_Collection_Time" = "16/12/2016 9:30 AM - 10:00AM";*/
        
        let listArray : NSMutableArray = NSMutableArray()
        listArray.add(populatedDictionary)
        
        let cartJsonDict :NSMutableDictionary = NSMutableDictionary()
        cartJsonDict.setObject(listArray, forKey: "list" as NSCopying)
        
        var jsonData : Data = Data()
        do {
            jsonData = try JSONSerialization.data(withJSONObject: cartJsonDict, options: JSONSerialization.WritingOptions.prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
        } catch let error as NSError {
            print(error)
        }
        let jsonStringFormat = String(data: jsonData, encoding: String.Encoding.utf8)
        
        LoadingView.show("Processing Your Order", animated: true)
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getPlaceOrderUrl(), parameters: ["type":"PlaceOrder" as AnyObject,"json":jsonStringFormat as AnyObject,"dt":"CAMPAIGNS" as AnyObject,"category":"Services" as AnyObject,"userId":CXAppConfig.sharedInstance.getAppMallID() as AnyObject,"consumerEmail":email as AnyObject]) { (responseDict) in
            
            print(responseDict)
            LoadingView.hide()
            
            let string = responseDict.value(forKeyPath: "myHashMap.status") as! String
            if (string.contains("1")){
                print("successfully ordered!!!")
                self.showAlertView("Your order is successfull!! Please check your mail.", status: 1)
                
            }else{
                self.showAlertView("Something went wrong!!! Please check you mail and order again.", status: 1)

            }
        }
    }
    
    func showAlertView(_ message:String, status:Int) {
        let alert = UIAlertController(title: "My Labz", message: message, preferredStyle: UIAlertControllerStyle.alert)
        //alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        let okAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.default) {
            UIAlertAction in
            if status == 1 {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //MAR:Heder options enable
    override  func shouldShowRightMenu() -> Bool{
        
        return false
    }
    
    override func shouldShowNotificatoinBell() ->Bool{
        
        return false
    }
    
    override  func shouldShowCart() -> Bool{
        
        return false
    }
    
    override func headerTitleText() -> String{
        return ""
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let scrollPoint = CGPoint(x: 0, y: textField.frame.origin.y)
        self.cScrollView.setContentOffset(scrollPoint, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.cScrollView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.tag == 100{
            guard let text = mobileTxtField.text else { return true }
            
            let newLength = text.characters.count + string.characters.count - range.length
            return newLength <= 10 // Bool
        }else{ return true }
        
    }
    
}
