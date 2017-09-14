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
        //self.view.backgroundColor = CXAppConfig.sharedInstance.getAppBGColor()
         // Do any additional setup after loading the view.
    }

    func methodOfReceivedNotification(_ notification: NSNotification){
        
        let notificationName = notification.name._rawValue
        //Take Action on Notification
        if notificationName == "SignInNotification"{
            let signInViewCnt : CXSignInSignUpViewController = CXSignInSignUpViewController()
            self.navigationController?.pushViewController(signInViewCnt, animated: true)
        }
        else if notificationName == "SignUpNotification"{
            let signUpViewCnt : CXSignUpViewController = CXSignUpViewController()
            self.navigationController?.pushViewController(signUpViewCnt, animated: true)
        }else if notificationName == "CartButtonNotification"{
             let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
             let cart = storyBoard.instantiateViewController(withIdentifier: "CART") as! CartViewController
             self.navigationController?.pushViewController(cart, animated: true)
        }else if notificationName == "ProfileNotification"{
            let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let profile = storyBoard.instantiateViewController(withIdentifier: "PROFILE") as! UserProfileViewController
            self.navigationController?.pushViewController(profile, animated: true)
        }else if notificationName == "NotificationBellNotification"{
            let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let profile = storyBoard.instantiateViewController(withIdentifier: "NOTIFICATIONS") as! NotificationsViewController
            self.navigationController?.pushViewController(profile, animated: true)
//        }else if notification.name == "ForgotNotification" {
//            let forgotPswdViewCnt : CXForgotPassword = CXForgotPassword()
//            self.navigationController?.pushViewController(forgotPswdViewCnt, animated: true)
        }
  
    }
    override func viewWillAppear(_ animated: Bool) {//NotificationBellNotification
        NotificationCenter.default.addObserver(self, selector: #selector(CXViewController.methodOfReceivedNotification(_:)), name:NSNotification.Name(rawValue: "CartButtonNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CXViewController.methodOfReceivedNotification(_:)), name:NSNotification.Name(rawValue: "SignInNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CXViewController.methodOfReceivedNotification(_:)), name:NSNotification.Name(rawValue: "SignUpNotification"), object: nil)
       // NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CXViewController.methodOfReceivedNotification(_:)), name:"ForgotNotification", object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CXViewController.methodOfReceivedNotification(_:)), name:NSNotification.Name(rawValue: "ProfileNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CXViewController.methodOfReceivedNotification(_:)), name:NSNotification.Name(rawValue: "NotificationBellNotification"), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    func cartButtonAction(){
        
        //return true
        
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
        if CXDataProvider.sharedInstance.getTheTableDataFromDataBase("CXWidgets", predicate: NSPredicate(format:"name=%@","Cart" ), ispredicate: true, orederByKey: "").totalCount == 0{
            return false
        }
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
