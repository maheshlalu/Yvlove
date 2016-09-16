//
//  CXForgotPassword.swift
//  StoreOnGoApp
//
//  Created by CX_One on 8/18/16.
//  Copyright © 2016 CX. All rights reserved.
//

import Foundation
import UIKit

class CXForgotPassword: CXViewController,UITextFieldDelegate {
    
    var emailAddressField: UITextField!
    var sendBtn:UIButton!
    var heder: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor();
        self.customizeMainView()
        
        
        // Do any additional setup after loading the view.
    }
    
    func customizeMainView() {
        let signUpLbl = UILabel.createHeaderLabel(CGRectMake(20,80, self.view.frame.size.width-40, 50), text: "Forgot password",font:UIFont.init(name: "Roboto-Regular", size: 30)!)
        self.view.addSubview(signUpLbl)
        
        let signUpSubLbl = UILabel.createHeaderLabel(CGRectMake(20, signUpLbl.frame.origin.y+signUpLbl.frame.size.height-10, self.view.frame.size.width-40, 40), text: "Get your password",font:UIFont.init(name: "Roboto-Regular", size: 14)!)
        self.view.addSubview(signUpSubLbl)
        
        self.emailAddressField = self.createField(CGRectMake(30, signUpSubLbl.frame.size.height+signUpSubLbl.frame.origin.y+30, self.view.frame.size.width-60, 40), tag: 1, placeHolder: "Email address")
        self.view.addSubview(self.emailAddressField)
        
        
        self.sendBtn = self.createButton(CGRectMake(25, self.emailAddressField.frame.size.height+self.emailAddressField.frame.origin.y+30, self.view.frame.size.width-50, 40), title: "SEND", tag: 3, bgColor: UIColor.signUpColor())
        //self.sendBtn.addTarget(self, action: #selector(CXForgotPassword.sendButtonAction), forControlEvents: .TouchUpInside)
        self.view.addSubview(self.sendBtn)
        
    }
    
    func showAlert(message:String) {
        let alert = UIAlertController(title: "Alert!!!", message:message , preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
//    func sendButtonAction() {//"Please enter valid email address."
//        self.view.endEditing(true)
//        print("Send button")
//        if self.isValidEmail(self.emailAddressField.text!) {
//            let forgotUrl = "http://storeongo.com:8081/MobileAPIs/forgotpwd?email="+self.emailAddressField.text!
//            SMSyncService.sharedInstance.startSyncProcessWithUrl(forgotUrl) { (responseDict) in
//                // print("Forgot mail response \(responseDict)")
//                let message = responseDict.valueForKey("result") as? String
//                self.showAlert(message!)
//            }
//        } else {
//            self.showAlert("Please enter valid email address.")
//        }
//    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createField(frame:CGRect, tag:Int, placeHolder:String) -> UITextField {
        let txtField : UITextField = UITextField()
        txtField.frame = frame;
        txtField.delegate = self
        txtField.tag = tag
        txtField.placeholder = placeHolder
        txtField.font = UIFont.init(name:"Roboto-Regular", size: 15)
        txtField.autocapitalizationType = .None
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.darkGrayColor().CGColor
        border.frame = CGRect(x: 0, y: txtField.frame.size.height - width, width:  txtField.frame.size.width, height: txtField.frame.size.height)
        
        border.borderWidth = width
        txtField.layer.addSublayer(border)
        txtField.layer.masksToBounds = true
        
        return txtField
    }
    
    
    func createButton(frame:CGRect,title: String,tag:Int, bgColor:UIColor) -> UIButton {
        let button: UIButton = UIButton()
        button.frame = frame
        button.setTitle(title, forState: .Normal)
        button.titleLabel?.font = UIFont.init(name:"Roboto-Regular", size: 15)
        button.layer.cornerRadius = 5.0
        button.layer.masksToBounds = true
        button.backgroundColor = bgColor
        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        return button
    }
    
    
    func isValidEmail(email: String) -> Bool {
        //print("validate email: \(email)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if emailTest.evaluateWithObject(email) {
            return true
        }
        return false
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
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
    
    override func shouldShowLeftMenu() -> Bool{
        
        return false
    }
    
    override func headerTitleText() -> String{
        return ""
    }

}
