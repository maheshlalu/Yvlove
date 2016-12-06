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
        self.view.backgroundColor = UIColor.white;
        self.customizeMainView()
        
        
        // Do any additional setup after loading the view.
    }
    
    func customizeMainView() {
        let signUpLbl = UILabel.createHeaderLabel(CGRect(x: 20,y: 80, width: self.view.frame.size.width-40, height: 50), text: "Forgot password",font:UIFont.init(name: "Roboto-Regular", size: 30)!)
        self.view.addSubview(signUpLbl)
        
        let signUpSubLbl = UILabel.createHeaderLabel(CGRect(x: 20, y: signUpLbl.frame.origin.y+signUpLbl.frame.size.height-10, width: self.view.frame.size.width-40, height: 40), text: "Get your password",font:UIFont.init(name: "Roboto-Regular", size: 14)!)
        self.view.addSubview(signUpSubLbl)
        
        self.emailAddressField = self.createField(CGRect(x: 30, y: signUpSubLbl.frame.size.height+signUpSubLbl.frame.origin.y+30, width: self.view.frame.size.width-60, height: 40), tag: 1, placeHolder: "Email address")
        self.view.addSubview(self.emailAddressField)
        
        
        self.sendBtn = self.createButton(CGRect(x: 25, y: self.emailAddressField.frame.size.height+self.emailAddressField.frame.origin.y+30, width: self.view.frame.size.width-50, height: 40), title: "SEND", tag: 3, bgColor: UIColor.signUpColor())
        self.sendBtn.addTarget(self, action: #selector(CXForgotPassword.sendButtonAction), for: .touchUpInside)
        self.view.addSubview(self.sendBtn)
        
    }
    
    func showAlert(_ message:String) {
        let alert = UIAlertController(title: "Alert!!!", message:message , preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func sendButtonAction() {//"Please enter valid email address."
        self.view.endEditing(true)
        print("Send button")
        if self.isValidEmail(self.emailAddressField.text!) {
            CXAppDataManager.sharedInstance.forgotPassword(self.emailAddressField.text!, completion: { (responseDict) in
                print(responseDict)
                let message = responseDict.value(forKey: "result") as? String
                self.showAlert(message!)
            })
        } else {
            self.showAlert("Please enter valid email address.")
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createField(_ frame:CGRect, tag:Int, placeHolder:String) -> UITextField {
        let txtField : UITextField = UITextField()
        txtField.frame = frame;
        txtField.delegate = self
        txtField.tag = tag
        txtField.placeholder = placeHolder
        txtField.font = UIFont.init(name:"Roboto-Regular", size: 15)
        txtField.autocapitalizationType = .none
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: txtField.frame.size.height - width, width:  txtField.frame.size.width, height: txtField.frame.size.height)
        
        border.borderWidth = width
        txtField.layer.addSublayer(border)
        txtField.layer.masksToBounds = true
        
        return txtField
    }
    
    
    func createButton(_ frame:CGRect,title: String,tag:Int, bgColor:UIColor) -> UIButton {
        let button: UIButton = UIButton()
        button.frame = frame
        button.setTitle(title, for: UIControlState())
        button.titleLabel?.font = UIFont.init(name:"Roboto-Regular", size: 15)
        button.layer.cornerRadius = 5.0
        button.layer.masksToBounds = true
        button.backgroundColor = bgColor
        button.setTitleColor(UIColor.white, for: UIControlState())
        return button
    }
    
    
    func isValidEmail(_ email: String) -> Bool {
        //print("validate email: \(email)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if emailTest.evaluate(with: email) {
            return true
        }
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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
    
    override func showLogoForAboutUs() -> Bool{
        return false
    }
    
    override func headerTitleText() -> String{
        return "Forgot password"
    }
    override func shouldShowLeftMenuWithLogo() -> Bool{
        
        return false
    }

}
