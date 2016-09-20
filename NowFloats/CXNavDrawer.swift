//
//  CXNavDrawer.swift
//  NowFloats
//
//  Created by apple on 30/08/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit
import MIBadgeButton_Swift
//static SHAWDOW_ALPHA 0.5
/*
#define SHAWDOW_ALPHA 0.5
#define MENU_DURATION 0.3
#define MENU_TRIGGER_VELOCITY 350
#define LEFT_NAV_BUTTON_WIDTH 44
#define LEFT_NAV_BUTTON_HEIGHT 44

#define ICON_WIDTH 35
#define ICON_HEIGHT 35*/

class Constants {
    
    // MARK: List of Constants
    static let SHAWDOW_ALPHA : Float = 0.5
    static let  MENU_DURATION : Float = 0.3
    static let MENU_TRIGGER_VELOCITY : CGFloat  = 350.0
    static let LEFT_NAV_BUTTON_WIDTH : CGFloat = 30.0
    static let LEFT_NAV_BUTTON_HEIGHT : CGFloat = 30.0

}


class CXNavDrawer: UINavigationController {
    let chooseArticleDropDown = DropDown()
    
    var pan_gr : UIPanGestureRecognizer!
    var isOPen : Bool = false
    var menuHeight: CGFloat = 0.0
    var menuWidth : CGFloat = 0.0
    var outFrame = CGRect(
        origin: CGPoint(x: 0, y: 0),
        size: UIScreen.mainScreen().bounds.size
    )

    var inFrame = CGRect(
        origin: CGPoint(x: 0, y: 0),
        size: UIScreen.mainScreen().bounds.size
    )
    
    var shawdowView : UIView!
    var drawerView : UIView!
    var cartBtn : MIBadgeButton!
    var profileBtn : UIButton!
    var notificationBellBtn : UIButton!
    var navTitle : String!

    var leftViewController : LeftViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.barTintColor = CXAppConfig.sharedInstance.getAppTheamColor()
        self.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationBar.translucent = false
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CXNavDrawer.upodateTheCartItems), name:"CartCountUpdate", object: nil)

        self.setuUpNavDrawer()
        self.delegate  = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func upodateTheCartItems(){
        
        if (self.cartBtn != nil) {
            let cartlist : NSArray =  CX_Cart.MR_findAllWithPredicate(NSPredicate(format: "addToCart = %@", "1"))
            if cartlist.count != 0 {
                self.cartBtn.badgeString = String(cartlist.count)
            }else{
                self.cartBtn.badgeString = ""
            }
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: LeftBar Button Item and Right bar button item
    
    
    func designLeftBarButtonItems(viewController:UIViewController) -> UIBarButtonItem{
        
        let leftButtonsView: UIView = UIView(frame: CGRectMake(0, 0, 250, 50))
        
        //leftButtonsView.backgroundColor = UIColor.blueColor()
        
        let sidePanelBtn : UIButton = UIButton(frame: CGRectMake(-10, 10, Constants.LEFT_NAV_BUTTON_WIDTH, Constants.LEFT_NAV_BUTTON_HEIGHT))
        sidePanelBtn.setBackgroundImage(UIImage(named:"sidePanel"), forState: .Normal)
        sidePanelBtn.addTarget(self, action: #selector(drawerToggle), forControlEvents: .TouchUpInside)
        let titleLable : UILabel = UILabel(frame: CGRectMake(Constants.LEFT_NAV_BUTTON_WIDTH, 10, 200, Constants.LEFT_NAV_BUTTON_HEIGHT))
        titleLable.textAlignment = .Left
        titleLable.textColor = UIColor.whiteColor()
        titleLable.text = CXAppConfig.sharedInstance.productName()
        titleLable.font = CXAppConfig.sharedInstance.appLargeFont()
        leftButtonsView.addSubview(titleLable)

        leftButtonsView.addSubview(sidePanelBtn)
        return UIBarButtonItem(customView: leftButtonsView)
    }
    
    func rightMenuButtonCreation(imageName:String,frame:CGRect) -> UIButton{
        let button = UIButton(type: .Custom) as UIButton
        button.setBackgroundImage(UIImage(named:imageName), forState: .Normal)
        button.frame =  frame
        return button
    }
    
    func createCartButton(imageName:String,frame:CGRect) -> MIBadgeButton {
        
        let button = MIBadgeButton(type: .Custom) as MIBadgeButton
        button.setBackgroundImage(UIImage(named:imageName), forState: .Normal)
        button.frame =  frame
        button.badgeTextColor = UIColor.redColor()
        button.badgeBackgroundColor = UIColor.whiteColor()
        button.badgeEdgeInsets = UIEdgeInsetsMake(13, 5, 0, 10)

        return button
    }
    
    
    func designRightBarButtonItems(viewController:UIViewController) -> UIBarButtonItem{
        
        let rightButtonsView: UIView = UIView(frame: CGRectMake(0, 0, 250, 40))
        let buttondWidth : CGFloat = 35
        self.profileBtn = self.rightMenuButtonCreation("dropDownIconImage", frame: CGRectMake(rightButtonsView.frame.size.width-buttondWidth+12, 5, 30, 30))
        self.notificationBellBtn = self.rightMenuButtonCreation("whiteNotification", frame: CGRectMake(rightButtonsView.frame.size.width-buttondWidth-25,2, 35, 35))
        self.cartBtn = self.createCartButton("whiteCartImage", frame: CGRectMake(rightButtonsView.frame.size.width-buttondWidth*2-30, 1, 35, 35))
       // self.cartBtn.badgeString = "10"
//whiteCartImage
      
        rightButtonsView.addSubview(self.profileBtn)
        rightButtonsView.addSubview(self.cartBtn)
        rightButtonsView.addSubview(self.notificationBellBtn)

        
        self.profileBtn.addTarget(self, action: #selector(profileToggleAction), forControlEvents: .TouchUpInside)
        self.notificationBellBtn.addTarget(self, action: #selector(notificationBellAction), forControlEvents: .TouchUpInside)
        self.cartBtn.addTarget(self, action: #selector(cartButtonAction), forControlEvents: .TouchUpInside)
        self.upodateTheCartItems()
        
       // let editButton   = UIBarButtonItem(image: editImage,  style: .Plain, target: self, action: "didTapEditButton:")

        
        
        return UIBarButtonItem(customView:rightButtonsView)
    }
    
    
    //MARK: Design left and right header component
    func designLeftBarButtonItemsForCXController(viewController:CXViewController) -> UIBarButtonItem{

        let leftButtonsView: UIView = UIView(frame: CGRectMake(0, 0, 250, 50))
        
        //leftButtonsView.backgroundColor = UIColor.blueColor()
        
        let sidePanelBtn : UIButton = UIButton(frame: CGRectMake(-10, 10, Constants.LEFT_NAV_BUTTON_WIDTH, Constants.LEFT_NAV_BUTTON_HEIGHT))
        sidePanelBtn.setBackgroundImage(UIImage(named:"sidePanel"), forState: .Normal)
        sidePanelBtn.addTarget(self, action: #selector(drawerToggle), forControlEvents: .TouchUpInside)
        
        let titleLable : UILabel = UILabel(frame: CGRectMake(Constants.LEFT_NAV_BUTTON_WIDTH, 10, 200, Constants.LEFT_NAV_BUTTON_HEIGHT))
        titleLable.textAlignment = .Left
        titleLable.textColor = UIColor.whiteColor()
      
        titleLable.text = viewController.headerTitleText()
        titleLable.font = CXAppConfig.sharedInstance.appLargeFont()
        leftButtonsView.addSubview(titleLable)
        
        leftButtonsView.addSubview(sidePanelBtn)
        return UIBarButtonItem(customView: leftButtonsView)
    }
    
    func rightMenuButtonCreationForCXController(imageName:String,frame:CGRect) -> UIButton{
        let button = UIButton(type: .Custom) as UIButton
        button.setBackgroundImage(UIImage(named:imageName), forState: .Normal)
        button.frame =  frame
        return button
    }
    
    
    
    func designRightBarButtonItemsForCXController(viewController:CXViewController) -> UIBarButtonItem{
        
        let rightButtonsView: UIView = UIView(frame: CGRectMake(0, 0, 250, 40))
        let buttondWidth : CGFloat = 35
        var buttonXposition : CGFloat = rightButtonsView.frame.size.width-buttondWidth+12
        if viewController.shouldShowRightMenu() {
            self.profileBtn = self.rightMenuButtonCreation("dropDownIconImage", frame: CGRectMake(buttonXposition, 5, 30, 30))
            buttonXposition =  buttonXposition-self.notificationBellBtn.frame.size.width
            rightButtonsView.addSubview(self.profileBtn)
            self.profileBtn.addTarget(self, action: #selector(profileToggleAction), forControlEvents: .TouchUpInside)

        }
        
        if viewController.shouldShowNotificatoinBell() {
            self.notificationBellBtn = self.rightMenuButtonCreation("whiteNotification", frame: CGRectMake(buttonXposition,2, 35, 35))
            buttonXposition = buttonXposition-self.notificationBellBtn.frame.size.width
            rightButtonsView.addSubview(self.notificationBellBtn)
            self.notificationBellBtn.addTarget(self, action: #selector(notificationBellAction), forControlEvents: .TouchUpInside)

        }
        
        if viewController.shouldShowCart(){
            self.cartBtn = self.createCartButton("whiteCartImage", frame: CGRectMake(buttonXposition, 1, 35, 35))
            rightButtonsView.addSubview(self.cartBtn)
            self.cartBtn.addTarget(self, action: #selector(cartButtonAction), forControlEvents: .TouchUpInside)
            self.upodateTheCartItems()
        }
        
        if viewController.profileDropdown(){
            self.profileBtn.addTarget(self, action: #selector(profileToggleActionForProfile), forControlEvents: .TouchUpInside)
        }
        
        if viewController.profileDropdownForSignIn(){
            self.profileBtn.addTarget(self, action: #selector(profileToggleActionForSignIn), forControlEvents: .TouchUpInside)
        }

        //whiteCartImage
        

        // let editButton   = UIBarButtonItem(image: editImage,  style: .Plain, target: self, action: "didTapEditButton:")
        
        
        
        return UIBarButtonItem(customView:rightButtonsView)
    }
    
    
    
    
    //MARK: SetUpDrawer
    
    func setuUpNavDrawer(){
        //LeftViewController
        
        
        self.isOPen = false
        
        self.leftViewController = (self.storyboard?.instantiateViewControllerWithIdentifier("LeftViewController") as? LeftViewController)!
        self.leftViewController.view.frame = CGRectMake(0, 0, 230, self.leftViewController.view.frame.size.height)
        self.leftViewController.navController = self
        
        self.drawerView = self.leftViewController.view
        
        self.menuHeight =  self.leftViewController.view.frame.size.height
        self.menuWidth =  self.leftViewController.view.frame.size.width
        
        self.outFrame = CGRectMake(-self.menuWidth, 0, self.menuWidth, self.menuHeight)
        self.inFrame = CGRectMake(0, 0, self.menuWidth, self.menuHeight)

         // drawer shawdow and assign its gesture
        self.shawdowView = UIView(frame: self.view.frame)
        self.shawdowView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        self.shawdowView.hidden = true
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CXNavDrawer.tapOnShawdow(_:)))
        self.shawdowView.addGestureRecognizer(tapGesture)
        self.shawdowView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.shawdowView)
        
         // add drawer view
        self.drawerView.frame = self.outFrame
        self.view.addSubview(self.drawerView)
        
        // gesture on self.view
        
        self.pan_gr = UIPanGestureRecognizer(target: self, action: #selector(CXNavDrawer.moveDrawer(_:)))
        self.pan_gr.maximumNumberOfTouches = 1
        self.view.addGestureRecognizer(self.pan_gr)
        self.view.bringSubviewToFront(self.navigationBar)

        
    }
    
    func tapOnShawdow(geture:UITapGestureRecognizer){
        self.closeNavigationDrawer()
    }


    
    func drawerToggle(){
        if self.isOPen {
            self.closeNavigationDrawer()
        }else{
            self.openNavigationDrawer()
        }
    }
    
    func closeAndOpenNavDrawer(shadowBgColor:UIColor , drawerFrame: CGRect,isOpenDrawer:Bool){
      
        
        //var duration: Float = MENU_DURATION / self.menuWidth * abs(self.drawerView.center.x) + MENU_DURATION / 2

        let duration: Float = Constants.MENU_DURATION / Float(self.menuWidth) * abs(Float(self.drawerView.center.x)) +  Constants.MENU_DURATION / 2

        self.shawdowView.hidden = !isOpenDrawer
        UIView.animateWithDuration(Double(duration), delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.shawdowView.backgroundColor = shadowBgColor
            }, completion: { (finished: Bool) -> Void in
                // you can do this in a shorter, more concise way by setting the value to its opposite, NOT value
                //isMenuHidden = !isMenuHidden
        })
        // drawer
        
        UIView.animateWithDuration(Double(duration), delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
            
            self.drawerView.frame = drawerFrame;
            
            }, completion: { (finished: Bool) -> Void in
                
                // you can do this in a shorter, more concise way by setting the value to its opposite, NOT value
                //isMenuHidden = !isMenuHidden
        })
        self.isOPen = isOpenDrawer;
        
        
    }
    
    //MARK: open and close action
    func openNavigationDrawer(){
        self.closeAndOpenNavDrawer(UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: CGFloat(Constants.SHAWDOW_ALPHA)), drawerFrame:  self.inFrame, isOpenDrawer: true)
          //self.isOPen = true;
    }
    
    func closeNavigationDrawer(){
        self.closeAndOpenNavDrawer(UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0), drawerFrame:  self.outFrame, isOpenDrawer: false)
    }
    
    func moveDrawer(gesture:UIPanGestureRecognizer){
        
        let translation : CGPoint = gesture.translationInView(self.view)
        let velocity : CGPoint = gesture.velocityInView(self.view)
        
        if gesture.state == UIGestureRecognizerState.Began {
            
            if velocity.x >  Constants.MENU_TRIGGER_VELOCITY && !self.isOPen{
                self.openNavigationDrawer()
            }else if(velocity.x < -Constants.MENU_TRIGGER_VELOCITY && self.isOPen){
                self.closeNavigationDrawer()
            }
        }
        
        if gesture.state == UIGestureRecognizerState.Changed {
            let movingx  = self.drawerView.center.x + translation.x
            if movingx > -self.menuWidth/2 && movingx < self.menuWidth/2 {
                
                self.drawerView.center = CGPointMake(movingx, self.drawerView.center.y)
                gesture.setTranslation(CGPointMake(0,0), inView: self.view)
               // let changingAlpha : CGFloat = Constants.SHAWDOW_ALPHA / self.menuWidth * movingx + Constants.SHAWDOW_ALPHA/2
                let changingAlpha: Float = Constants.SHAWDOW_ALPHA / Float(self.menuWidth) * Float(movingx) + Constants.SHAWDOW_ALPHA / 2
                self.shawdowView.hidden = false
                self.shawdowView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: CGFloat(changingAlpha))
            }
          
        }
        if gesture.state == UIGestureRecognizerState.Ended {
            
            if self.drawerView.center.x > 0 {
                self.openNavigationDrawer()
            }else if self.drawerView.center.x < 0{
                self.closeNavigationDrawer()                                                                                                                              
            }
        }
    }
}


extension CXNavDrawer : UINavigationControllerDelegate {
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        print("nav controlller \(viewController)")
        self.upodateTheCartItems()
        if viewController.isKindOfClass(CXViewController) {
            
            viewController.navigationItem.rightBarButtonItem = self.designRightBarButtonItemsForCXController((viewController as?CXViewController)!)
            let viewCntl:CXViewController = (viewController as?CXViewController)!
            if viewCntl.shouldShowLeftMenu() {
                viewController.navigationItem.leftBarButtonItem = self.designLeftBarButtonItemsForCXController((viewController as?CXViewController)!)
            }
           
        }else{
            viewController.navigationItem.leftBarButtonItem = self.designLeftBarButtonItems(UpdatesViewController())
            viewController.navigationItem.rightBarButtonItem = self.designRightBarButtonItems(UpdatesViewController())
        }
       
    }
}


extension CXNavDrawer {
    
    override func viewWillAppear(animated: Bool) {
        self.ToggleWithProfileForSignIn()
        self.ToggleWithProfileForProfile()
        self.ToggleWithProfileWithUserId()
        self.ToggleWithProfileWithoutUserId()
        self.upodateTheCartItems()
    }

    
    func cartButtonAction(){
        //CartButtonNotification
        NSNotificationCenter.defaultCenter().postNotificationName("CartButtonNotification", object: nil)
        
    }
    
    func notificationBellAction(){
        NSNotificationCenter.defaultCenter().postNotificationName("NotificationBellNotification", object: nil)
    }
    
    
    
    func profileToggleAction(sender:UIButton){
        
        if NSUserDefaults.standardUserDefaults().valueForKey("USER_ID") == nil{
            chooseArticleDropDown.show()
            ToggleWithProfileWithoutUserId()
        }else{
            chooseArticleDropDown.show()
            ToggleWithProfileWithUserId()
        }
        
    }
    
    func profileToggleActionForProfile(sender:UIButton){
        
        chooseArticleDropDown.show()
        ToggleWithProfileForProfile()
    }
    
    func profileToggleActionForSignIn(sender:UIButton){
        chooseArticleDropDown.show()
        ToggleWithProfileForSignIn()
    }
    
    
    func ToggleWithProfileWithUserId(){
        chooseArticleDropDown.anchorView = profileBtn
        chooseArticleDropDown.bottomOffset = CGPoint(x: 0, y:self.navigationBar.frame.size.height-5)
        chooseArticleDropDown.dataSource = [
            "Profile","Logout"
        ]
        chooseArticleDropDown.selectionAction = {(index, item) in
            self.profileBtn.setTitle(nil, forState: .Normal)
            if index == 0{
                NSNotificationCenter.defaultCenter().postNotificationName("ProfileNotification", object: nil)
            }else if index == 1{
                self.showAlertView("Are You Sure??", status: 1)
                
            }
        }
    }
    func ToggleWithProfileWithoutUserId(){
        chooseArticleDropDown.anchorView = profileBtn
        chooseArticleDropDown.bottomOffset = CGPoint(x: 0, y:self.navigationBar.frame.size.height)
        chooseArticleDropDown.dataSource = [
            "Profile"
        ]
        chooseArticleDropDown.selectionAction = {(index, item) in
            self.profileBtn.setTitle(nil, forState: .Normal)
            if index == 0{
                NSNotificationCenter.defaultCenter().postNotificationName("SignInNotification", object: nil)
            }
        }
    }
    func ToggleWithProfileForSignIn(){
        chooseArticleDropDown.anchorView = profileBtn
        chooseArticleDropDown.bottomOffset = CGPoint(x: 0, y:self.navigationBar.frame.size.height)
        chooseArticleDropDown.dataSource = [
            "Forgot Password?"
        ]
        chooseArticleDropDown.selectionAction = {(index, item) in
            self.profileBtn.setTitle(nil, forState: .Normal)
            if index == 0{
                NSNotificationCenter.defaultCenter().postNotificationName("ForgotNotification", object: nil)
            }
        }
    }func ToggleWithProfileForProfile(){
        chooseArticleDropDown.anchorView = profileBtn
        chooseArticleDropDown.bottomOffset = CGPoint(x: 0, y:self.navigationBar.frame.size.height)
        chooseArticleDropDown.dataSource = [
            "Logout"
        ]
        chooseArticleDropDown.selectionAction = {(index, item) in
            self.profileBtn.setTitle(nil, forState: .Normal)
            if index == 0{
                self.showAlertView("Are You Sure??", status: 1)
            }
        }
    }
    func logout(){
        
        NSUserDefaults.standardUserDefaults().removeObjectForKey("STATE")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("USER_EMAIL")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("FIRST_NAME")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("LAST_NAME")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("GENDER")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("USER_ID")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("MAC_ID")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("MOBILE")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("ADDRESS")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("FULL_NAME")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("CITY")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("ORG_ID")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("MACID_JOBID")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("ORGANIZATION")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("MESSAGE")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("STATUS")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("COUNTRY")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("BANNER_PATH")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("IMAGE_PATH")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    func showAlertView(message:String, status:Int) {
        let alert = UIAlertController(title:message, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            if status == 1 {
                self.logout()
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Destructive) {
            UIAlertAction in
            if status == 1 {
                
            }
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
