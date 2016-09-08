//
//  CXNavDrawer.swift
//  NowFloats
//
//  Created by apple on 30/08/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit

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
    var cartBtn : UIButton!
    var profileBtn : UIButton!
    var notificationBellBtn : UIButton!
    var navTitle : String!

    var leftViewController : LeftViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.barTintColor = CXAppConfig.sharedInstance.getAppTheamColor()
        self.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationBar.translucent = false


        self.setuUpNavDrawer()
        self.delegate  = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        leftButtonsView.addSubview(sidePanelBtn)
        return UIBarButtonItem(customView: leftButtonsView)
    }
    
    func rightMenuButtonCreation(imageName:String,frame:CGRect) -> UIButton{
        let button = UIButton(type: .Custom) as UIButton
        button.setBackgroundImage(UIImage(named:imageName), forState: .Normal)
        button.frame =  frame
        return button
    }
    
    
    
    func designRightBarButtonItems(viewController:UIViewController) -> UIBarButtonItem{
        let rightButtonsView: UIView = UIView(frame: CGRectMake(0, 0, 250, 40))
        let buttondWidth : CGFloat = 35
        self.profileBtn = self.rightMenuButtonCreation("dropDownIconImage", frame: CGRectMake(rightButtonsView.frame.size.width-buttondWidth, 0, 35, 35))
        self.notificationBellBtn = self.rightMenuButtonCreation("whiteNotification", frame: CGRectMake(rightButtonsView.frame.size.width-buttondWidth*2, 0, 35, 35))
        self.cartBtn = self.rightMenuButtonCreation("whiteCartImage", frame: CGRectMake(rightButtonsView.frame.size.width-buttondWidth*3, 0, 35, 35))
//whiteCartImage
        
        rightButtonsView.addSubview(self.profileBtn)
        rightButtonsView.addSubview(self.cartBtn)
        rightButtonsView.addSubview(self.notificationBellBtn)

        
        self.profileBtn.addTarget(self, action: #selector(profileToggleAction), forControlEvents: .TouchUpInside)
        self.notificationBellBtn.addTarget(self, action: #selector(notificationBellAction), forControlEvents: .TouchUpInside)
        self.cartBtn.addTarget(self, action: #selector(cartButtonAction), forControlEvents: .TouchUpInside)

        
       // let editButton   = UIBarButtonItem(image: editImage,  style: .Plain, target: self, action: "didTapEditButton:")

        
        
        return UIBarButtonItem(customView:rightButtonsView)
    }
    
    
    
    //MARK: SetUpDrawer
    
    func setuUpNavDrawer(){
        //LeftViewController
        
        
        self.isOPen = false
        
        self.leftViewController = (self.storyboard?.instantiateViewControllerWithIdentifier("LeftViewController") as? LeftViewController)!
        self.leftViewController.view.frame = CGRectMake(0, 0, self.outFrame.size.width-100, self.leftViewController.view.frame.size.height)
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
        
        if viewController.isKindOfClass(CXViewController) {
            
        }else{
            viewController.navigationItem.leftBarButtonItem = self.designLeftBarButtonItems(UpdatesViewController())
            viewController.navigationItem.rightBarButtonItem = self.designRightBarButtonItems(UpdatesViewController())
        }
       
    }
}


extension CXNavDrawer {
    
    
    func cartButtonAction(){
       
        NSNotificationCenter.defaultCenter().postNotificationName("NotificationIdentifier", object: nil)

    }
    
    func notificationBellAction(){
        
    }
    
    func profileToggleAction(){
        
    }
    
    
}
