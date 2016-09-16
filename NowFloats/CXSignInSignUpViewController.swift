//
//  CXSignInSignUpViewController.swift
//  NV Agencies
//
//  Created by Sarath on 07/04/16.
//  Copyright © 2016 Sarath. All rights reserved.
//

import UIKit
import Foundation


protocol CXSingInDelegate {
    func didGoogleSignIn()
}

class CXSignInSignUpViewController: CXViewController,UITextFieldDelegate {
    var emailAddressField: UITextField!
    var passwordField: UITextField!
    var signInBtn:UIButton!
    var signUpBtn:UIButton!
    var backButton:UIButton!
    
    var cScrollView:UIScrollView!
    var keyboardIsShown:Bool!
    
    //var orgID:String! = CXConstant.MallID
    var profileImageStr:String!
    var profileImagePic:UIImageView!
    var delegate:CXSingInDelegate?
    var heder: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor();
        self.keyboardIsShown = false
        self.customizeMainView()
        
    }
    
    
    func customizeMainView() {
        self.cScrollView = UIScrollView.init(frame: CGRectMake(0,0, self.view.frame.size.width, (self.view.frame.size.height)))
        self.cScrollView.backgroundColor = UIColor.clearColor()
       // self.cScrollView.contentSize = CGSizeMake(self.view.frame.size.width,600)
        self.view.addSubview(self.cScrollView)

        let signUpLbl = UILabel.createHeaderLabel(CGRectMake(20, 40, self.cScrollView.frame.size.width-40, 50), text: "Sign In",font:UIFont.init(name: "Roboto-Regular", size: 40)!)
        self.cScrollView.addSubview(signUpLbl)
        
        let signUpSubLbl = UILabel.createHeaderLabel(CGRectMake(20, signUpLbl.frame.origin.y+signUpLbl.frame.size.height-10, self.cScrollView.frame.size.width-40, 40), text: "Sign up with email address",font:UIFont.init(name: "Roboto-Regular", size: 14)!)
        self.cScrollView.addSubview(signUpSubLbl)
        
        self.emailAddressField = self.createField(CGRectMake(30, signUpSubLbl.frame.size.height+signUpSubLbl.frame.origin.y+5, self.view.frame.size.width-60, 40), tag: 1, placeHolder: "Email address")
        self.cScrollView.addSubview(self.emailAddressField)
        
        self.passwordField = self.createField(CGRectMake(30, self.emailAddressField.frame.size.height+self.emailAddressField.frame.origin.y+20, self.view.frame.size.width-60, 40), tag: 2, placeHolder: "Password")
        self.passwordField.secureTextEntry = true
        self.cScrollView.addSubview(self.passwordField)
        
        self.signInBtn = self.createButton(CGRectMake(25, self.passwordField.frame.size.height+self.passwordField.frame.origin.y+30, self.view.frame.size.width-50, 50), title: "SIGN IN", tag: 3, bgColor: CXAppConfig.sharedInstance.getAppTheamColor())
          self.signInBtn.addTarget(self, action: #selector(CXSignInSignUpViewController.signInAction), forControlEvents: .TouchUpInside)
        self.cScrollView.addSubview(self.signInBtn)
        
        self.signUpBtn = self.createButton(CGRectMake(25, self.signInBtn.frame.size.height+self.signInBtn.frame.origin.y+20, self.view.frame.size.width-50, 50), title: "SIGN UP", tag: 3, bgColor: UIColor.signUpColor())
        self.signUpBtn.addTarget(self, action: #selector(CXSignInSignUpViewController.signUpAction), forControlEvents: .TouchUpInside)
        self.cScrollView.addSubview(self.signUpBtn)
        
      
        
    }
    
    func  createPlainTextButton(frame:CGRect,title: String,tag:Int) -> UIButton {
        let button: UIButton = UIButton()
        button.frame = frame
        button.setTitle(title, forState: .Normal)
        button.titleLabel?.font = UIFont.init(name:"Roboto-Regular", size: 15)
        button.titleLabel?.textAlignment = NSTextAlignment.Center
        button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        button.backgroundColor = UIColor.clearColor()
        return button
        
    }
  
    func showAlertView(message:String, status:Int) {
        dispatch_async(dispatch_get_main_queue(), {
            let alert = UIAlertController(title: "Alert!!!", message: message, preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                if status == 1 {
                    //It should leads to Profile Screen
                    let home : ViewController = ViewController.init()
                    self.navigationController?.pushViewController(home, animated: false)                }
            }
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true, completion: nil)
        })
    }
    
    
    func moveBackView() {
        let navControllers:NSArray = (self.navigationController?.viewControllers)!
        let prevController = navControllers.objectAtIndex(navControllers.count-1)
        self.navigationController?.popToViewController(prevController as! UIViewController, animated: true)
    }
    
    
    
    func sendSignDetails() {
  
        CXAppDataManager.sharedInstance.singWithUserDetails(self.emailAddressField.text!, password: self.passwordField.text!) { (responseDict) in
            /*   UserId = 2003;
             address = "";
             city = "";
             country = India;
             emailId = "iamsky.mme@gmail.com";
             firstName = Suresh;
             fullName = "Suresh Kumar";
             gender = 0;
             lastName = Kumar;
             macId = "20749ce5-bddb-4ea5-82b4-8960f0598e90";
             macIdJobId = 30450;
             mobile = 9640339556;
             msg = Success;
             orgId = 11;
             organisation = "68M Holidays";
             state = "";
             status = 1;
             userBannerPath = "";
             userImagePath = "";*/
            
        let status: Int = Int(responseDict.valueForKey("status") as! String)!
            
            if status == 1{
            NSUserDefaults.standardUserDefaults().setObject(responseDict.valueForKey("state"), forKey: "STATE")
            NSUserDefaults.standardUserDefaults().setObject(responseDict.valueForKey("emailId"), forKey: "USER_EMAIL")
            NSUserDefaults.standardUserDefaults().setObject(responseDict.valueForKey("firstName"), forKey: "FIRST_NAME")
            NSUserDefaults.standardUserDefaults().setObject(responseDict.valueForKey("lastName"), forKey: "LAST_NAME")
            NSUserDefaults.standardUserDefaults().setObject(responseDict.valueForKey("gender"), forKey: "GENDER")
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
            NSUserDefaults.standardUserDefaults().setObject(responseDict.valueForKey("userBannerPath"), forKey: "BANNER_PATH")
            NSUserDefaults.standardUserDefaults().setObject(responseDict.valueForKey("userImagePath"), forKey: "IMAGE_PATH")
            NSUserDefaults.standardUserDefaults().synchronize()
            
            self.showAlertView("Login successfully", status: status)
                
        } else {
               self.showAlertView("Please enter valid credentials", status: status)
            }
        }
        }
    
    func signInAction() {
        // print ("Sign In action")
        self.view.endEditing(true)
        if self.isValidEmail(self.emailAddressField.text!) {
            self.sendSignDetails()
        } else {
                let alert = UIAlertController(title: "Alert!!!", message: "Please enter valid email.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                //print("Please enter valid email")
        }
    }
    
    func signUpAction() {
        print ("Sign Up action")
        self.view.endEditing(true)
        let signUpView = CXSignUpViewController.init()
//signUpView.orgID = self.orgID
        self.navigationController?.pushViewController(signUpView, animated: true)
    }
    
    func isValidEmail(email: String) -> Bool {
        print("validate email: \(email)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if emailTest.evaluateWithObject(email) {
            return true
        }
        return false
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
        return button
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
    
    //MAR:Heder options enable
    override  func shouldShowRightMenu() -> Bool{
        
        return true
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


