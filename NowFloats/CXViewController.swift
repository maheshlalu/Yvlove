//
//  CXViewController.swift
//  NowFloats
//
//  Created by apple on 30/08/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit

class CXViewController: UIViewController {

    var leftNavigationBarItemTitle : String!
    var navController : CXNavDrawer = CXNavDrawer()
    override func viewDidLoad() {
        super.viewDidLoad()
         // Do any additional setup after loading the view.
    }

    func methodOfReceivedNotification(notification: NSNotification){
        //Take Action on Notification
        let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let product = storyBoard.instantiateViewControllerWithIdentifier("PRODUCT") as! ProductsViewController
        self.navigationController?.pushViewController(product, animated: true)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CXViewController.methodOfReceivedNotification(_:)), name:"NotificationIdentifier", object: nil)

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
