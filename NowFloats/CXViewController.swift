//
//  CXViewController.swift
//  NowFloats
//
//  Created by apple on 30/08/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit

class CXViewController: UIViewController,UIPopoverPresentationControllerDelegate{

    var leftNavigationBarItemTitle : String!
    var navController : CXNavDrawer = CXNavDrawer()
    override func viewDidLoad() {
        super.viewDidLoad()
         // Do any additional setup after loading the view.
    }

    func methodOfReceivedNotification(notification: NSNotification){
        
        //Take Action on Notification
        if notification.name == "SignInNotification"{
            let signInViewCnt : CXSignInSignUpViewController = CXSignInSignUpViewController()
            self.navigationController?.pushViewController(signInViewCnt, animated: true)
        }
        else if notification.name == "SignUpNotification"{
            let signUpViewCnt : CXSignUpViewController = CXSignUpViewController()
            self.navigationController?.pushViewController(signUpViewCnt, animated: true)
        }else if notification.name == "CartButtonNotification"{
             let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
             let cart = storyBoard.instantiateViewControllerWithIdentifier("CART") as! CartViewController
             self.navigationController?.pushViewController(cart, animated: true)
        }else if notification.name == "ProfileNotification"{
            let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let profile = storyBoard.instantiateViewControllerWithIdentifier("PROFILE") as! UserProfileViewController
            self.navigationController?.pushViewController(profile, animated: true)
        }else if notification.name == "NotificationBellNotification"{
            let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let profile = storyBoard.instantiateViewControllerWithIdentifier("NOTIFICATIONS") as! NotificationsViewController
            self.navigationController?.pushViewController(profile, animated: true)
        
        }
        
  
    }
    override func viewWillAppear(animated: Bool) {//NotificationBellNotification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CXViewController.methodOfReceivedNotification(_:)), name:"CartButtonNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CXViewController.methodOfReceivedNotification(_:)), name:"SignInNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CXViewController.methodOfReceivedNotification(_:)), name:"SignUpNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CXViewController.methodOfReceivedNotificationForgotPsw(_:)), name:"ForgotNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CXViewController.methodOfReceivedNotification(_:)), name:"ProfileNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CXViewController.methodOfReceivedNotification(_:)), name:"NotificationBellNotification", object: nil)

        

    }
    
    func methodOfReceivedNotificationForgotPsw(notification: NSNotification){
        
        let forgotPswdViewCnt : CXForgotPassword = CXForgotPassword()
        self.navigationController?.pushViewController(forgotPswdViewCnt, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func cartButtonAction(){
        
        
    }
    
    func notificationBellAction(){
        
    }
    
    func profileToggleAction(){
        
    }
    
    func shouldShowRightMenu() -> Bool{
        return true
    }
    
    func shouldShowNotificatoinBell() ->Bool{
        
        return true
    }
    
    func shouldShowCart() -> Bool{
        
        return true
    }
    
    
    func shouldShowLeftMenu() -> Bool{
        
        return true
    }
    
    func shouldShowLeftMenuWithLogo() -> Bool{
        
        return false
    }
    
    func showLogoForAboutUs() -> Bool{
        return false
    }

    func backButtonTapped() -> Bool{
        return false
    }
    
    func headerTitleText() -> String{
        return CXAppConfig.sharedInstance.productName()
    }
    
    func leftMenuTapped(){
        let navVC : CXNavDrawer = (self.navigationController as? CXNavDrawer)!
        navVC.drawerToggle()
    }
    func profileDropdown() -> Bool{
        return false
    }
    
    func profileDropdownForSignIn() -> Bool{
        return false
    }
    
    
}
