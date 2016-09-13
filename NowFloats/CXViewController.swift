//
//  CXViewController.swift
//  NowFloats
//
//  Created by apple on 30/08/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit

class CXViewController: UIViewController,UIPopoverPresentationControllerDelegate {

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
        }else if notification.name == "ForgotNotification" {
            let forgotPswdViewCnt : CXForgotPassword = CXForgotPassword()
            self.navigationController?.pushViewController(forgotPswdViewCnt, animated: true)
        }else if notification.name == "CartButtonNotification"{
             let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
             let cart = storyBoard.instantiateViewControllerWithIdentifier("CART") as! CartViewController
             self.navigationController?.pushViewController(cart, animated: true)
        }
        
  
    }
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CXViewController.methodOfReceivedNotification(_:)), name:"CartButtonNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CXViewController.methodOfReceivedNotification(_:)), name:"SignInNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CXViewController.methodOfReceivedNotification(_:)), name:"SignUpNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CXViewController.methodOfReceivedNotification(_:)), name:"ForgotNotification", object: nil)

        

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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    func shouldShowRightMenu() -> Bool{
        
        return true
    }
    
    func shouldShowLeftMenu() -> Bool{
        
        return true
    }
    func shouldShowCart() -> Bool{
        
        return true
    }
    
    func backButtonTapped(){
        
        
    }
    
    func leftMenuTapped(){
        
        let navVC : CXNavDrawer = (self.navigationController as? CXNavDrawer)!
        navVC.drawerToggle()
    }
    
    
}
