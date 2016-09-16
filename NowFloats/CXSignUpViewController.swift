//
//  CXSignUpViewController.swift
//  NV Agencies
//
//  Created by NUNC on 5/19/16.
//  Copyright © 2016 Sarath. All rights reserved.
//

import UIKit

enum SignUpMembers {
    case FIRST_NAME
    case LAST_NAME
    case MOBILE_NUMBER
    case EMAIL_ADDRESS
    case PASSWORD
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
        self.view.backgroundColor = UIColor.whiteColor()
        self.customizeMainView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func customizeMainView() {
        self.cScrollView = UIScrollView.init(frame: CGRectMake(0,20, self.view.frame.size.width, (self.view.frame.size.height)))
        self.cScrollView.backgroundColor = UIColor.clearColor()
        // self.cScrollView.contentSize = CGSizeMake(self.view.frame.size.width,600)
        self.view.addSubview(self.cScrollView)
        
        let signUpLbl = UILabel.createHeaderLabel(CGRectMake(20, 0, self.cScrollView.frame.size.width-40, 50), text: "Sign Up",font:UIFont.init(name: "Roboto-Regular", size: 40)!)
        self.cScrollView.addSubview(signUpLbl)
        let signUpSubLbl = UILabel.createHeaderLabel(CGRectMake(20, signUpLbl.frame.origin.y+signUpLbl.frame.size.height-10, self.cScrollView.frame.size.width-40, 40), text: "Sign up with email address",font:UIFont.init(name: "Roboto-Regular", size: 14)!)
        self.cScrollView.addSubview(signUpSubLbl)
        
        self.firstNameField = self.createField(CGRectMake(30, signUpSubLbl.frame.size.height+signUpSubLbl.frame.origin.y+20, self.cScrollView.frame.size.width-60, 40), tag: 1, placeHolder: "First Name")
        self.cScrollView.addSubview(self.firstNameField)
        
        self.lastNameField = self.createField(CGRectMake(30, self.firstNameField.frame.size.height+self.firstNameField.frame.origin.y+5, self.cScrollView.frame.size.width-60, 40), tag: 2, placeHolder: "Last Name")
        self.cScrollView.addSubview(self.lastNameField)
        
        self.mobileNumField = self.createField(CGRectMake(30, self.lastNameField.frame.size.height+self.lastNameField.frame.origin.y+5, self.cScrollView.frame.size.width-60, 40), tag: 3, placeHolder: "Mobile Number")
        self.mobileNumField.keyboardType = UIKeyboardType.NumberPad
        self.addAccessoryViewToField(self.mobileNumField)
        self.cScrollView.addSubview(self.mobileNumField)
        
        self.emailAddressField = self.createField(CGRectMake(30, self.mobileNumField.frame.size.height+self.mobileNumField.frame.origin.y+5, self.cScrollView.frame.size.width-60, 40), tag: 4, placeHolder: "Email Address")
        self.emailAddressField.keyboardType = UIKeyboardType.EmailAddress
        self.cScrollView.addSubview(self.emailAddressField)
        
        self.passwordField = self.createField(CGRectMake(30, self.emailAddressField.frame.size.height+self.emailAddressField.frame.origin.y+5, self.cScrollView.frame.size.width-60, 40), tag: 5, placeHolder: "Password")
        self.passwordField.secureTextEntry = true
        self.cScrollView.addSubview(self.passwordField)
        
        self.signUpBtn = self.createButton(CGRectMake(25, self.passwordField.frame.size.height+self.passwordField.frame.origin.y+30, self.view.frame.size.width-50, 50), title: "SIGN UP", tag: 3, bgColor: UIColor.signUpColor())
        self.signUpBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.signUpBtn.addTarget(self, action: #selector(CXSignUpViewController.signUpBtnAction), forControlEvents: .TouchUpInside)
        self.cScrollView.addSubview(self.signUpBtn)
        
        self.signInBtn = self.createButton(CGRectMake(25, self.signUpBtn.frame.size.height+self.signUpBtn.frame.origin.y+20, self.view.frame.size.width-50, 50), title: "SIGN IN", tag: 3, bgColor:CXAppConfig.sharedInstance.getAppTheamColor())
        self.signInBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.signInBtn.addTarget(self, action: #selector(CXSignUpViewController.signInBtnAction), forControlEvents: .TouchUpInside)
        self.cScrollView.addSubview(self.signInBtn)
        
    }
    func clearNumPadAction() {
        self.mobileNumField.text = nil
        self.view.endEditing(true)
    }
    
    func doneNumberPadAction() {
        self.view.endEditing(true)
    }
    func alertWithMessage(alertMessage:String){
        
        let alert = UIAlertController(title: "Alert!!!", message:alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    func addAccessoryViewToField(mTextField:UITextField) {
        let numToolBar = UIToolbar.init(frame: CGRectMake(0, 0, self.view.frame.size.width, 50))
        numToolBar.barStyle = UIBarStyle.BlackTranslucent
        let clearBtn = UIBarButtonItem.init(title: "Clear", style: UIBarButtonItemStyle.Bordered, target: self, action: #selector(CXSignUpViewController.clearNumPadAction))
        let flexSpace = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action:nil)
        let doneBtn = UIBarButtonItem.init(title:"Done", style: UIBarButtonItemStyle.Done, target: self, action: #selector(CXSignUpViewController.doneNumberPadAction))
        
        numToolBar.items = [clearBtn,flexSpace,doneBtn]
        numToolBar.sizeToFit()
        mTextField.inputAccessoryView = numToolBar
    }
    
    func backAction() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func showAlertView(message:String, status:Int) {
        dispatch_async(dispatch_get_main_queue(), {
            let alert = UIAlertController(title: "Alert!!!", message: message, preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                if status == 1 {
                    //It should leads to Profile Screen
                    //self.navigationController?.popViewControllerAnimated(true)
                    
                    let viewController: UIViewController = self.navigationController!.viewControllers[1]
                    self.navigationController!.popToViewController(viewController, animated: true)
                }
            }
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true, completion: nil)
        })
    }
    
    func sendSignUpDetails() {
        CXAppDataManager.sharedInstance.signUpWithUserDetails(self.firstNameField.text!, lastName:self.lastNameField.text!, mobileNumber: self.mobileNumField.text!, email: self.emailAddressField.text!, password: self.passwordField.text!) { (responseDict) in
            let status: Int = Int(responseDict.valueForKey("status") as! String)!
            if status == 1{
                NSUserDefaults.standardUserDefaults().setObject(responseDict.valueForKey("state"), forKey: "STATE")
                NSUserDefaults.standardUserDefaults().setObject(responseDict.valueForKey("emailId"), forKey: "USER_EMAIL")
                NSUserDefaults.standardUserDefaults().setObject(responseDict.valueForKey("firstName"), forKey: "FIRST_NAME")
                NSUserDefaults.standardUserDefaults().setObject(responseDict.valueForKey("lastName"), forKey: "LAST_NAME")
                NSUserDefaults.standardUserDefaults().setObject(responseDict.valueForKey("userBannerPath"), forKey: "USER_BANNER_PATH")
                NSUserDefaults.standardUserDefaults().setObject(responseDict.valueForKey("gender"), forKey: "GENDER")
                NSUserDefaults.standardUserDefaults().setObject(responseDict.valueForKey("userImagePath"), forKey: "USER_IMAGE_PATH")
                NSUserDefaults.standardUserDefaults().setObject(responseDict.valueForKey("UserId"), forKey: "USER_ID")
                NSUserDefaults.standardUserDefaults().setObject(responseDict.valueForKey("macId"), forKey: "MAC_ID")
                NSUserDefaults.standardUserDefaults().setObject(responseDict.valueForKey("mobile"), forKey: "MOBILE")
                NSUserDefaults.standardUserDefaults().setObject(responseDict.valueForKey("address"), forKey: "ADDRESS")
                NSUserDefaults.standardUserDefaults().setObject(responseDict.valueForKey("fullName"), forKey: "FULL_NAME")
                NSUserDefaults.standardUserDefaults().setObject(responseDict.valueForKey("city"), forKey: "CITY")
                NSUserDefaults.standardUserDefaults().setObject(responseDict.valueForKey("orgId"), forKey: "ORG_ID")
                NSUserDefaults.standardUserDefaults().setObject(responseDict.valueForKey("macIdJobId"), forKey: "MACID_JOBID")
                NSUserDefaults.standardUserDefaults().setObject(responseDict.valueForKey("organisation"), forKey: "ORGANIZATION")
                NSUserDefaults.standardUserDefaults().setObject(responseDict.valueForKey("msg"), forKey: "MESSAGE")
                NSUserDefaults.standardUserDefaults().setObject(responseDict.valueForKey("status"), forKey: "STATUS")
                NSUserDefaults.standardUserDefaults().setObject(responseDict.valueForKey("country"), forKey: "COUNTRY")
                NSUserDefaults.standardUserDefaults().synchronize()
                
                self.showAlertView("User Registered Successfully", status: status)
            }
            
            let message = responseDict.valueForKey("msg") as? String
            dispatch_async(dispatch_get_main_queue(), {
                let alert = UIAlertController(title: "Alert!!!", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) in
                    //self.moveBackView()
                    self.navController.popViewControllerAnimated(true)
                    
                }))
                self.presentViewController(alert, animated: true, completion: nil)
            })
        }
    }
    
    func moveBackView() {
        let navControllers:NSArray = (self.navigationController?.viewControllers)!
        let prevController = navControllers.objectAtIndex(navControllers.count-3)
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
                let alert = UIAlertController(title: "Alert!!!", message: "Please enter valid email address.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                return
            }
            
            if self.mobileNumField.text?.characters.count < 10 {
                let alert = UIAlertController(title: "Alert!!!", message: "Please enter valid Phone number.", preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default) {
                    UIAlertAction in
                    //self.navigationController?.popViewControllerAnimated(true)
                    
                }
                alert.addAction(okAction)
                self.presentViewController(alert, animated: true, completion: nil)
                
                return
            }
            self.sendSignUpDetails()
            
        } else {
            let alert = UIAlertController(title: "Alert!!!", message: "All fields are mandatory. Please enter all fields.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func signInBtnAction() {
        self.view.endEditing(true)
        self.navigationController?.popViewControllerAnimated(true)
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
        button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        button.layer.cornerRadius = 5.0
        button.layer.masksToBounds = true
        button.backgroundColor = bgColor
        return button
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
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

    override func headerTitleText() -> String{
        return ""
    }
    
    func isValidEmail(email: String) -> Bool {
       // print("validate email: \(email)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if emailTest.evaluateWithObject(email) {
            return true
        }
        return false
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        let scrollPoint = CGPointMake(0, textField.frame.origin.y)
        self.cScrollView.setContentOffset(scrollPoint, animated: true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
       return textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.cScrollView.setContentOffset(CGPointZero, animated: true)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 3 {
            if  range.length==1 && string.characters.count == 0 {
                return true
            }
            if textField.text?.characters.count >= 10 {
                return false
            }
            let invalidCharacters = NSCharacterSet(charactersInString: "0123456789").invertedSet
            return string.rangeOfCharacterFromSet(invalidCharacters, options: [], range: string.startIndex ..< string.endIndex) == nil
        }
        return true
    }

}

extension UILabel {
    static func createHeaderLabel(frame :CGRect,text:String, font:UIFont) -> UILabel {
        let cLabel = UILabel.init(frame: frame)
        cLabel.font = font//UIFont.init(name: "Roboto-Bold", size: 18)
        cLabel.text = text
        cLabel.textAlignment = NSTextAlignment.Center
        cLabel.textColor = UIColor.darkGrayColor()
        return cLabel
    }
    

}
