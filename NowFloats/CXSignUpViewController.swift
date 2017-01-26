//
//  CXSignUpViewController.swift
//  NV Agencies
//
//  Created by NUNC on 5/19/16.
//  Copyright © 2016 Sarath. All rights reserved.
//

import UIKit
import FBSDKCoreKit

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


enum SignUpMembers {
    case first_NAME
    case last_NAME
    case mobile_NUMBER
    case email_ADDRESS
    case password
}


class CXSignUpViewController: CXViewController,UITextFieldDelegate,UIScrollViewDelegate {
    
    var cScrollView:UIScrollView!
    var firstNameField: UITextField!
    var lastNameField: UITextField!
    var mobileNumField: UITextField!
    var emailAddressField: UITextField!
    var passwordField:UITextField!
    
    var signInBtn:UIButton!
    var signUpBtn: UIButton!
    var heder: UIView!
    var orgID:String!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.customizeMainView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func customizeMainView() {
        self.cScrollView = UIScrollView.init(frame: CGRect(x: 0,y: 20, width: self.view.frame.size.width, height: (self.view.frame.size.height)))
        self.cScrollView.backgroundColor = UIColor.clear
        // self.cScrollView.contentSize = CGSizeMake(self.view.frame.size.width,600)
        self.view.addSubview(self.cScrollView)
        
        let signUpLbl = UILabel.createHeaderLabel(CGRect(x: 20, y: 0, width: self.cScrollView.frame.size.width-40, height: 50), text: "Sign Up",font:UIFont.init(name: "Roboto-Regular", size: 40)!)
        self.cScrollView.addSubview(signUpLbl)
        let signUpSubLbl = UILabel.createHeaderLabel(CGRect(x: 20, y: signUpLbl.frame.origin.y+signUpLbl.frame.size.height-10, width: self.cScrollView.frame.size.width-40, height: 40), text: "Sign up with email address",font:UIFont.init(name: "Roboto-Regular", size: 14)!)
        self.cScrollView.addSubview(signUpSubLbl)
        
        self.firstNameField = self.createField(CGRect(x: 30, y: signUpSubLbl.frame.size.height+signUpSubLbl.frame.origin.y+20, width: self.cScrollView.frame.size.width-60, height: 40), tag: 1, placeHolder: "First Name")
        self.cScrollView.addSubview(self.firstNameField)
        
        self.lastNameField = self.createField(CGRect(x: 30, y: self.firstNameField.frame.size.height+self.firstNameField.frame.origin.y+5, width: self.cScrollView.frame.size.width-60, height: 40), tag: 2, placeHolder: "Last Name")
        self.cScrollView.addSubview(self.lastNameField)
        
        self.mobileNumField = self.createField(CGRect(x: 30, y: self.lastNameField.frame.size.height+self.lastNameField.frame.origin.y+5, width: self.cScrollView.frame.size.width-60, height: 40), tag: 3, placeHolder: "Mobile Number")
        self.mobileNumField.keyboardType = UIKeyboardType.numberPad
        self.addAccessoryViewToField(self.mobileNumField)
        self.cScrollView.addSubview(self.mobileNumField)
        
        self.emailAddressField = self.createField(CGRect(x: 30, y: self.mobileNumField.frame.size.height+self.mobileNumField.frame.origin.y+5, width: self.cScrollView.frame.size.width-60, height: 40), tag: 4, placeHolder: "Email Address")
        self.emailAddressField.keyboardType = UIKeyboardType.emailAddress
        self.cScrollView.addSubview(self.emailAddressField)
        
        self.passwordField = self.createField(CGRect(x: 30, y: self.emailAddressField.frame.size.height+self.emailAddressField.frame.origin.y+5, width: self.cScrollView.frame.size.width-60, height: 40), tag: 5, placeHolder: "Password")
        self.passwordField.isSecureTextEntry = true
        self.cScrollView.addSubview(self.passwordField)
        
        self.signUpBtn = self.createButton(CGRect(x: 25, y: self.passwordField.frame.size.height+self.passwordField.frame.origin.y+30, width: self.view.frame.size.width-50, height: 50), title: "SIGN UP", tag: 3, bgColor: UIColor.signUpColor())
        self.signUpBtn.setTitleColor(UIColor.white, for: UIControlState())
        self.signUpBtn.addTarget(self, action: #selector(CXSignUpViewController.signUpBtnAction), for: .touchUpInside)
        self.cScrollView.addSubview(self.signUpBtn)
        
        self.signInBtn = self.createButton(CGRect(x: 25, y: self.signUpBtn.frame.size.height+self.signUpBtn.frame.origin.y+20, width: self.view.frame.size.width-50, height: 50), title: "SIGN IN", tag: 3, bgColor:CXAppConfig.sharedInstance.getAppTheamColor())
        self.signInBtn.setTitleColor(UIColor.white, for: UIControlState())
        self.signInBtn.addTarget(self, action: #selector(CXSignUpViewController.signInBtnAction), for: .touchUpInside)
        self.cScrollView.addSubview(self.signInBtn)
        
    }
    func clearNumPadAction() {
        self.mobileNumField.text = nil
        self.view.endEditing(true)
    }
    
    func doneNumberPadAction() {
        self.view.endEditing(true)
    }
    func alertWithMessage(_ alertMessage:String){
        
        let alert = UIAlertController(title: "Alert!!!", message:alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    func addAccessoryViewToField(_ mTextField:UITextField) {
        let numToolBar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        numToolBar.barStyle = UIBarStyle.blackTranslucent
        let clearBtn = UIBarButtonItem.init(title: "Clear", style: UIBarButtonItemStyle.bordered, target: self, action: #selector(CXSignUpViewController.clearNumPadAction))
        let flexSpace = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action:nil)
        let doneBtn = UIBarButtonItem.init(title:"Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(CXSignUpViewController.doneNumberPadAction))
        
        numToolBar.items = [clearBtn,flexSpace,doneBtn]
        numToolBar.sizeToFit()
        mTextField.inputAccessoryView = numToolBar
    }
    
    func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func showAlertView(_ message:String, status:Int) {
        DispatchQueue.main.async(execute: {
            let alert = UIAlertController(title: "Alert!!!", message: message, preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.default) {
                UIAlertAction in
                if status == 1 {
                    //It should leads to Profile Screen
                    //self.navigationController?.popViewControllerAnimated(true)
                    
                    let viewController: UIViewController = self.navigationController!.viewControllers[1]
                    self.navigationController!.popToViewController(viewController, animated: true)
                }
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        })
    }
    
    func sendSignUpDetails() {
        CXAppDataManager.sharedInstance.signUpWithUserDetails(self.firstNameField.text!, lastName:self.lastNameField.text!, mobileNumber: self.mobileNumField.text!, email: self.emailAddressField.text!, password: self.passwordField.text!) { (responseDict) in
            let status: Int = Int(responseDict.value(forKey: "status") as! String)!
            if status == 1{
                UserDefaults.standard.set(responseDict.value(forKey: "state"), forKey: "STATE")
                UserDefaults.standard.set(responseDict.value(forKey: "emailId"), forKey: "USER_EMAIL")
                UserDefaults.standard.set(responseDict.value(forKey: "firstName"), forKey: "FIRST_NAME")
                UserDefaults.standard.set(responseDict.value(forKey: "lastName"), forKey: "LAST_NAME")
                UserDefaults.standard.set(responseDict.value(forKey: "userBannerPath"), forKey: "USER_BANNER_PATH")
                UserDefaults.standard.set(responseDict.value(forKey: "gender"), forKey: "GENDER")
                UserDefaults.standard.set(responseDict.value(forKey: "userImagePath"), forKey: "USER_IMAGE_PATH")
                UserDefaults.standard.set(responseDict.value(forKey: "UserId"), forKey: "USER_ID")
                UserDefaults.standard.set(responseDict.value(forKey: "macId"), forKey: "MAC_ID")
                UserDefaults.standard.set(responseDict.value(forKey: "mobile"), forKey: "MOBILE")
                UserDefaults.standard.set(responseDict.value(forKey: "address"), forKey: "ADDRESS")
                UserDefaults.standard.set(responseDict.value(forKey: "fullName"), forKey: "FULL_NAME")
                UserDefaults.standard.set(responseDict.value(forKey: "city"), forKey: "CITY")
                UserDefaults.standard.set(responseDict.value(forKey: "orgId"), forKey: "ORG_ID")
                UserDefaults.standard.set(responseDict.value(forKey: "macIdJobId"), forKey: "MACID_JOBID")
                UserDefaults.standard.set(responseDict.value(forKey: "organisation"), forKey: "ORGANIZATION")
                UserDefaults.standard.set(responseDict.value(forKey: "msg"), forKey: "MESSAGE")
                UserDefaults.standard.set(responseDict.value(forKey: "status"), forKey: "STATUS")
                UserDefaults.standard.set(responseDict.value(forKey: "country"), forKey: "COUNTRY")
                UserDefaults.standard.synchronize()
                
                self.showAlertView("User Registered Successfully", status: status)
                
                CXFBEvents.sharedInstance.logCompletedRegistrationEvent("Email")
            }
            
            let message = responseDict.value(forKey: "msg") as? String
            DispatchQueue.main.async(execute: {
                let alert = UIAlertController(title: "Alert!!!", message: message, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
                    //self.moveBackView()
                    self.navController.popViewController(animated: true)
                    
                }))
                self.present(alert, animated: true, completion: nil)
            })
        }
    }
    
    func moveBackView() {
        let navControllers:NSArray = (self.navigationController?.viewControllers)! as NSArray
        let prevController = navControllers.object(at: navControllers.count-3)
        self.navigationController?.popToViewController(prevController as! UIViewController, animated: true)
    }
    
    func signUpBtnAction() {
        self.view.endEditing(true)
        if self.firstNameField.text?.characters.count > 0
            && self.lastNameField.text?.characters.count > 0
            && self.emailAddressField.text?.characters.count > 0
            && self.passwordField.text?.characters.count > 0 &&
            self.mobileNumField.text?.characters.count > 0 {
            if !self.isValidEmail(self.emailAddressField.text!) {
                let alert = UIAlertController(title: "Alert!!!", message: "Please enter valid email address.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            if self.mobileNumField.text?.characters.count < 10 {
                let alert = UIAlertController(title: "Alert!!!", message: "Please enter valid Phone number.", preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    //self.navigationController?.popViewControllerAnimated(true)
                    
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                
                
                return
            }
            self.sendSignUpDetails()
            
        } else {
            let alert = UIAlertController(title: "Alert!!!", message: "All fields are mandatory. Please enter all fields.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func signInBtnAction() {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
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
        button.setTitleColor(UIColor.black, for: UIControlState())
        button.layer.cornerRadius = 5.0
        button.layer.masksToBounds = true
        button.backgroundColor = bgColor
        return button
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.cScrollView.endEditing(true)
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
    override func shouldShowLeftMenuWithLogo() -> Bool{
        
        return true
    }

    override func headerTitleText() -> String{
        return "Sign up"
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
        if textField.tag == 3 {
            if  range.length==1 && string.characters.count == 0 {
                return true
            }
            if textField.text?.characters.count >= 10 {
                return false
            }
            let invalidCharacters = CharacterSet(charactersIn: "0123456789").inverted
            //return string.rangeOfCharacter(from: invalidCharacters, options: [], range: string.characters.indices) == nil
        }
        return true
    }

}

extension UILabel {
    static func createHeaderLabel(_ frame :CGRect,text:String, font:UIFont) -> UILabel {
        let cLabel = UILabel.init(frame: frame)
        cLabel.font = font//UIFont.init(name: "Roboto-Bold", size: 18)
        cLabel.text = text
        cLabel.textAlignment = NSTextAlignment.center
        cLabel.textColor = UIColor.darkGray
        return cLabel
    }
    

}
