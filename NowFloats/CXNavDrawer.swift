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
    let chooseArticleDropDown = DropDown()
    
    var pan_gr : UIPanGestureRecognizer!
    var isOPen : Bool = false
    var menuHeight: CGFloat = 0.0
    var menuWidth : CGFloat = 0.0
    var outFrame = CGRect(
        origin: CGPoint(x: 0, y: 0),
        size: UIScreen.main.bounds.size
    )

    var inFrame = CGRect(
        origin: CGPoint(x: 0, y: 0),
        size: UIScreen.main.bounds.size
    )
    
    var shawdowView : UIView!
    var drawerView : UIView!
    var cartBtn : MIBadgeButton!
    var profileBtn : UIButton!
    var notificationBellBtn : UIButton!
    var navTitle : String!

    var leftViewController : LeftViewController!
    var presentWindow:UIWindow?
    
    var fromProfile = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presentWindow = UIApplication.shared.keyWindow
        self.navigationBar.barTintColor = CXAppConfig.sharedInstance.getAppTheamColor()
        self.navigationBar.tintColor = UIColor.white
        self.navigationBar.isTranslucent = false
        NotificationCenter.default.addObserver(self, selector: #selector(CXNavDrawer.upodateTheCartItems), name:NSNotification.Name(rawValue: "CartCountUpdate"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CXNavDrawer.backBtnAction), name:NSNotification.Name(rawValue: "PlaceOrderSuccessFully"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CXNavDrawer.profileBackBtnAction), name:NSNotification.Name(rawValue: "FromProfile"), object: nil)
        
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
            let cartlist : NSArray =  CX_Cart.mr_findAll(with: NSPredicate(format: "addToCart = %@", "1")) as NSArray
            if cartlist.count != 0 {
                self.cartBtn.badgeString = String(cartlist.count)
            }else{
                self.cartBtn.badgeString = ""
            }
        }
    }
    
    
    func designLeftBarButtonItems(_ viewController:UIViewController) -> UIBarButtonItem{
        
        let leftButtonsView: UIView = UIView(frame: CGRect(x: -10, y: 0, width: 100, height: self.navigationBar.frame.size.height))
        
        //leftButtonsView.backgroundColor = UIColor.blueColor()
        
        let sidePanelBtn : UIButton = UIButton(frame: CGRect(x: -10, y: 10, width: Constants.LEFT_NAV_BUTTON_WIDTH, height: Constants.LEFT_NAV_BUTTON_HEIGHT))
        sidePanelBtn.setBackgroundImage(UIImage(named:"sidePanel"), for: UIControlState())
        sidePanelBtn.addTarget(self, action: #selector(drawerToggle), for: .touchUpInside)
        let titleLable : UILabel = UILabel(frame: CGRect(x: Constants.LEFT_NAV_BUTTON_WIDTH, y: 10, width: 200, height: Constants.LEFT_NAV_BUTTON_HEIGHT))
        titleLable.textAlignment = .left
        titleLable.textColor = UIColor.white
        titleLable.text = CXAppConfig.sharedInstance.productName()
        titleLable.font = CXAppConfig.sharedInstance.appLargeFont()
        leftButtonsView.addSubview(titleLable)

        leftButtonsView.addSubview(sidePanelBtn)
        return UIBarButtonItem(customView: leftButtonsView)
    }
    
    func rightMenuButtonCreation(_ imageName:String,frame:CGRect) -> UIButton{
        let button = UIButton(type: .custom) as UIButton
        button.setBackgroundImage(UIImage(named:imageName), for: UIControlState())
        button.frame =  frame
        return button
    }
    
    func createCartButton(_ imageName:String,frame:CGRect) -> MIBadgeButton {
        
        let button = MIBadgeButton(type: .custom) as MIBadgeButton
        button.setBackgroundImage(UIImage(named:imageName), for: UIControlState())
        button.frame =  frame
        button.badgeTextColor = UIColor.red
        button.badgeBackgroundColor = UIColor.white
        button.badgeEdgeInsets = UIEdgeInsetsMake(13, 5, 0, 10)
        #if MyLabs
            button.isHidden = true
        #else
            
        #endif
        return button
    }
    
    
    func designRightBarButtonItems(_ viewController:UIViewController) -> UIBarButtonItem{
        
        let rightButtonsView: UIView = UIView(frame: CGRect(x: -10, y: 0, width: 100, height: 40))
//        rightButtonsView.backgroundColor = UIColor.greenColor()
        let buttondWidth : CGFloat = 35
        self.profileBtn = self.rightMenuButtonCreation("dropDownIconImage", frame: CGRect(x: rightButtonsView.frame.size.width-buttondWidth+12, y: 5, width: 30, height: 30))
        self.notificationBellBtn = self.rightMenuButtonCreation("whiteNotification", frame: CGRect(x: rightButtonsView.frame.size.width-buttondWidth-25,y: 2, width: 35, height: 35))
        self.cartBtn = self.createCartButton("whiteCartImage", frame: CGRect(x: rightButtonsView.frame.size.width-buttondWidth*2-30, y: 1, width: 35, height: 35))
        self.cartBtn.isHighlighted = false
       // self.cartBtn.badgeString = "10"
//whiteCartImage
        #if MyLabs
            rightButtonsView.addSubview(self.profileBtn)
            rightButtonsView.addSubview(self.notificationBellBtn)
        #else
            rightButtonsView.addSubview(self.profileBtn)
            rightButtonsView.addSubview(self.cartBtn)
            rightButtonsView.addSubview(self.notificationBellBtn)
        #endif


        
        self.profileBtn.addTarget(self, action: #selector(profileToggleAction), for: .touchUpInside)
        self.notificationBellBtn.addTarget(self, action: #selector(notificationBellAction), for: .touchUpInside)
        self.cartBtn.addTarget(self, action: #selector(cartButtonAction), for: .touchUpInside)
        self.upodateTheCartItems()
        
       // let editButton   = UIBarButtonItem(image: editImage,  style: .Plain, target: self, action: "didTapEditButton:")

        
        
        return UIBarButtonItem(customView:rightButtonsView)
    }
    
    
    //MARK: Design left and right header component
    func designLeftBarButtonItemsForCXController(_ viewController:CXViewController) -> UIBarButtonItem{

        let leftButtonsView: UIView = UIView(frame: CGRect(x: -10, y: 0, width: 100, height: self.navigationBar.frame.size.height))
        //leftButtonsView.backgroundColor = UIColor.redColor()
        
        let sidePanelBtn : UIButton = UIButton(frame: CGRect(x: -10, y: 10, width: Constants.LEFT_NAV_BUTTON_WIDTH, height: Constants.LEFT_NAV_BUTTON_HEIGHT))
        sidePanelBtn.setBackgroundImage(UIImage(named:"sidePanel"), for: UIControlState())
        sidePanelBtn.addTarget(self, action: #selector(drawerToggle), for: .touchUpInside)
        
        let titleLable : UILabel = UILabel(frame: CGRect(x: Constants.LEFT_NAV_BUTTON_WIDTH, y: 10, width: 100, height: Constants.LEFT_NAV_BUTTON_HEIGHT))
        titleLable.textAlignment = .left
        titleLable.textColor = UIColor.white
      
        titleLable.text = viewController.headerTitleText()
        titleLable.font = CXAppConfig.sharedInstance.appLargeFont()
        leftButtonsView.addSubview(titleLable)
        
        leftButtonsView.addSubview(sidePanelBtn)
        return UIBarButtonItem(customView: leftButtonsView)
    }
    
    func designLeftBarButtonItemsForCXControllerWithBackBtn(_ viewController:CXViewController) -> UIBarButtonItem{
        
        let leftButtonsView: UIView = UIView(frame: CGRect(x: -10, y: 0, width: 100, height: self.navigationBar.frame.size.height))
        //leftButtonsView.backgroundColor = UIColor.redColor()
        
        let sidePanelBtn : UIButton = UIButton(frame: CGRect(x: -10, y: 10, width: Constants.LEFT_NAV_BUTTON_WIDTH, height: Constants.LEFT_NAV_BUTTON_HEIGHT))
        sidePanelBtn.setBackgroundImage(UIImage(named:"backBtn"), for: UIControlState())
        sidePanelBtn.addTarget(self, action: #selector(backBtnAction), for: .touchUpInside)
        
        let titleLable : UILabel = UILabel(frame: CGRect(x: Constants.LEFT_NAV_BUTTON_WIDTH-10, y: 10, width: 150, height: Constants.LEFT_NAV_BUTTON_HEIGHT))
        titleLable.textAlignment = .left
        titleLable.textColor = UIColor.white
        
        titleLable.text = viewController.headerTitleText()
        titleLable.font = CXAppConfig.sharedInstance.appLargeFont()
        leftButtonsView.addSubview(titleLable)
        
        leftButtonsView.addSubview(sidePanelBtn)
        return UIBarButtonItem(customView: leftButtonsView)
    }
    
    func designLeftBarButtonItemsForCXControllerWithBackBtnAndLogo(_ viewController:CXViewController) -> UIBarButtonItem{
        
        let leftButtonsView: UIView = UIView(frame: CGRect(x: -10, y: 0, width: 100, height: self.navigationBar.frame.size.height))
        //leftButtonsView.backgroundColor = UIColor.redColor()
        
        let sidePanelBtn : UIButton = UIButton(frame: CGRect(x: -10, y: 10, width: Constants.LEFT_NAV_BUTTON_WIDTH, height: Constants.LEFT_NAV_BUTTON_HEIGHT))
        sidePanelBtn.setBackgroundImage(UIImage(named:"backBtn"), for: UIControlState())
        
        let imgUrl = UserDefaults.standard.value(forKey: "LOGO") as? String
        let sidePanelLogoBtn:UIButton = UIButton(frame: CGRect(x: Constants.LEFT_NAV_BUTTON_WIDTH-10, y: 10, width: Constants.LEFT_NAV_BUTTON_WIDTH, height: Constants.LEFT_NAV_BUTTON_HEIGHT))
        sidePanelLogoBtn.setImageWith(URL(string:imgUrl!), for: UIControlState())
        sidePanelBtn.addTarget(self, action: #selector(backBtnAction), for: .touchUpInside)
        sidePanelLogoBtn.addTarget(self, action: #selector(backBtnAction), for: .touchUpInside)
        
        let titleLable : UILabel = UILabel(frame: CGRect(x: Constants.LEFT_NAV_BUTTON_WIDTH+sidePanelLogoBtn.frame.size.width, y: 10, width: 100, height: Constants.LEFT_NAV_BUTTON_HEIGHT))
        titleLable.textAlignment = .left
        titleLable.textColor = UIColor.white
        
        titleLable.text = viewController.headerTitleText()
        titleLable.font = CXAppConfig.sharedInstance.appLargeFont()
        leftButtonsView.addSubview(titleLable)
        
        leftButtonsView.addSubview(sidePanelBtn)
        leftButtonsView.addSubview(sidePanelLogoBtn)
        
        return UIBarButtonItem(customView: leftButtonsView)
    }
    
    func headerWithLogoForAboutUs(_ viewController:CXViewController) -> UIBarButtonItem{
        
        let leftButtonsView: UIView = UIView(frame: CGRect(x: -10, y: 0, width: 100, height: self.navigationBar.frame.size.height))
        //leftButtonsView.backgroundColor = UIColor.redColor()
        
        let sidePanelBtn : UIButton = UIButton(frame: CGRect(x: -10, y: 10, width: Constants.LEFT_NAV_BUTTON_WIDTH, height: Constants.LEFT_NAV_BUTTON_HEIGHT))
        sidePanelBtn.setBackgroundImage(UIImage(named:"backBtn"), for: UIControlState())
        
        let imgUrl = UserDefaults.standard.value(forKey: "LOGO") as? String
        let screenWidth = UIScreen.main.bounds.width
        let sidePanelLogoBtn:UIButton = UIButton(frame: CGRect(x: screenWidth/2 - Constants.LEFT_NAV_BUTTON_WIDTH ,y: 10, width: Constants.LEFT_NAV_BUTTON_WIDTH, height: Constants.LEFT_NAV_BUTTON_HEIGHT))
        sidePanelLogoBtn.setImageWith(URL(string:imgUrl!), for: UIControlState())
        sidePanelLogoBtn.isHighlighted = false
        sidePanelLogoBtn.isUserInteractionEnabled = false
        sidePanelBtn.addTarget(self, action: #selector(backBtnAction), for: .touchUpInside)
        
        leftButtonsView.addSubview(sidePanelBtn)
        leftButtonsView.addSubview(sidePanelLogoBtn)
        
        return UIBarButtonItem(customView: leftButtonsView)
    }
    
    
    func backBtnAction(){
        if fromProfile{
            self.popToRootViewController(animated: true)
        }else{
            self.popViewController(animated: true)
        }
    }
    
    func profileBackBtnAction(){
        fromProfile = true
    }
    func rightMenuButtonCreationForCXController(_ imageName:String,frame:CGRect) -> UIButton{
        let button = UIButton(type: .custom) as UIButton
        button.setBackgroundImage(UIImage(named:imageName), for: UIControlState())
        button.frame =  frame
        return button
    }
    
    
    
    func designRightBarButtonItemsForCXController(_ viewController:CXViewController) -> UIBarButtonItem{
        
        let rightButtonsView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 250, height: 40))
       // rightButtonsView.backgroundColor = UIColor.brownColor()
        let buttondWidth : CGFloat = 35
        var buttonXposition : CGFloat = rightButtonsView.frame.size.width-buttondWidth+12
        

        if viewController.shouldShowRightMenu() {
            self.profileBtn = self.rightMenuButtonCreation("dropDownIconImage", frame: CGRect(x: buttonXposition, y: 5, width: 30, height: 30))
            buttonXposition =  buttonXposition-self.notificationBellBtn.frame.size.width
            rightButtonsView.addSubview(self.profileBtn)
            self.profileBtn.addTarget(self, action: #selector(profileToggleAction), for: .touchUpInside)

        }
        
        if viewController.shouldShowNotificatoinBell() {
            self.notificationBellBtn = self.rightMenuButtonCreation("whiteNotification", frame: CGRect(x: buttonXposition,y: 2, width: 35, height: 35))
            buttonXposition = buttonXposition-self.notificationBellBtn.frame.size.width
            rightButtonsView.addSubview(self.notificationBellBtn)
            self.notificationBellBtn.addTarget(self, action: #selector(notificationBellAction), for: .touchUpInside)

        }
        
        if viewController.shouldShowCart(){
            self.cartBtn = self.createCartButton("whiteCartImage", frame: CGRect(x: buttonXposition, y: 1, width: 35, height: 35))
            self.cartBtn.isHighlighted = false
            rightButtonsView.addSubview(self.cartBtn)
            self.cartBtn.addTarget(self, action: #selector(cartButtonAction), for: .touchUpInside)
            self.upodateTheCartItems()
        }
        
        if viewController.profileDropdown(){
            rightButtonsView.addSubview(self.profileBtn)
            self.profileBtn.addTarget(self, action: #selector(profileToggleActionForProfile), for: .touchUpInside)
        }
        
        if viewController.profileDropdownForSignIn(){
             rightButtonsView.addSubview(self.profileBtn)
            self.profileBtn.addTarget(self, action: #selector(profileToggleActionForSignIn), for: .touchUpInside)
        }

        return UIBarButtonItem(customView:rightButtonsView)
    }
    
    
    
    
    //MARK: SetUpDrawer
    
    func setuUpNavDrawer(){
        //LeftViewController
        
        
        self.isOPen = false
        
        self.leftViewController = (self.storyboard?.instantiateViewController(withIdentifier: "LeftViewController") as? LeftViewController)!
        self.leftViewController.view.frame = CGRect(x: 0, y: 0, width: 230, height: self.leftViewController.view.frame.size.height)
        self.leftViewController.navController = self
        
        self.drawerView = self.leftViewController.view
        
        self.menuHeight =  self.leftViewController.view.frame.size.height
        self.menuWidth =  self.leftViewController.view.frame.size.width
        
        self.outFrame = CGRect(x: -self.menuWidth, y: 0, width: self.menuWidth, height: self.menuHeight)
        self.inFrame = CGRect(x: 0, y: 0, width: self.menuWidth, height: self.menuHeight)

         // drawer shawdow and assign its gesture
        self.shawdowView = UIView(frame: self.view.frame)
        self.shawdowView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        self.shawdowView.isHidden = true
        
        
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
        self.view.bringSubview(toFront: self.navigationBar)

        
    }
    
    func tapOnShawdow(_ geture:UITapGestureRecognizer){
        self.closeNavigationDrawer()
    }

    func drawerToggle(){
        if self.isOPen {
            self.closeNavigationDrawer()
        }else{
            self.openNavigationDrawer()
        }
    }
    
    func drawerHide(){
        if self.isOPen{
            self.closeNavigationDrawer()
        }
    }
    
    func closeAndOpenNavDrawer(_ shadowBgColor:UIColor , drawerFrame: CGRect,isOpenDrawer:Bool){
      
        
        //var duration: Float = MENU_DURATION / self.menuWidth * abs(self.drawerView.center.x) + MENU_DURATION / 2

        let duration: Float = Constants.MENU_DURATION / Float(self.menuWidth) * abs(Float(self.drawerView.center.x)) +  Constants.MENU_DURATION / 2

        self.shawdowView.isHidden = !isOpenDrawer
        UIView.animate(withDuration: Double(duration), delay: 0, options: UIViewAnimationOptions(), animations: { () -> Void in
            self.shawdowView.backgroundColor = shadowBgColor
            }, completion: { (finished: Bool) -> Void in
                // you can do this in a shorter, more concise way by setting the value to its opposite, NOT value
                //isMenuHidden = !isMenuHidden
        })
        // drawer
        
        UIView.animate(withDuration: Double(duration), delay: 0, options: UIViewAnimationOptions.beginFromCurrentState, animations: { () -> Void in
            
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
    
    func moveDrawer(_ gesture:UIPanGestureRecognizer){
        
        let translation : CGPoint = gesture.translation(in: self.view)
        let velocity : CGPoint = gesture.velocity(in: self.view)
        
        if gesture.state == UIGestureRecognizerState.began {
            
            if velocity.x >  Constants.MENU_TRIGGER_VELOCITY && !self.isOPen{
                self.openNavigationDrawer()
            }else if(velocity.x < -Constants.MENU_TRIGGER_VELOCITY && self.isOPen){
                self.closeNavigationDrawer()
            }
        }
        
        if gesture.state == UIGestureRecognizerState.changed {
            let movingx  = self.drawerView.center.x + translation.x
            if movingx > -self.menuWidth/2 && movingx < self.menuWidth/2 {
                
                self.drawerView.center = CGPoint(x: movingx, y: self.drawerView.center.y)
                gesture.setTranslation(CGPoint(x: 0,y: 0), in: self.view)
               // let changingAlpha : CGFloat = Constants.SHAWDOW_ALPHA / self.menuWidth * movingx + Constants.SHAWDOW_ALPHA/2
                let changingAlpha: Float = Constants.SHAWDOW_ALPHA / Float(self.menuWidth) * Float(movingx) + Constants.SHAWDOW_ALPHA / 2
                self.shawdowView.isHidden = false
                self.shawdowView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: CGFloat(changingAlpha))
            }
          
        }
        if gesture.state == UIGestureRecognizerState.ended {
            
            if self.drawerView.center.x > 0 {
                self.openNavigationDrawer()
            }else if self.drawerView.center.x < 0{
                self.closeNavigationDrawer()                                                                                                                              
            }
        }
    }
}


extension CXNavDrawer : UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        print("nav controlller \(viewController)")
        self.upodateTheCartItems()
        if viewController.isKind(of: CXViewController.self) {
            
            viewController.navigationItem.rightBarButtonItem = self.designRightBarButtonItemsForCXController((viewController as?CXViewController)!)
            let viewCntl:CXViewController = (viewController as?CXViewController)!
            if viewCntl.shouldShowLeftMenu(){
                
                viewController.navigationItem.leftBarButtonItem = self.designLeftBarButtonItemsForCXController((viewController as?CXViewController)!)
            }else{
                //designLeftBarButtonItemsForCXControllerWithBackBtn
                viewController.navigationItem.leftBarButtonItem = self.designLeftBarButtonItemsForCXControllerWithBackBtn((viewController as?CXViewController)!)
            }
            if viewCntl.shouldShowLeftMenuWithLogo(){
                viewController.navigationItem.leftBarButtonItem = self.designLeftBarButtonItemsForCXControllerWithBackBtnAndLogo((viewController as?CXViewController)!)

            }
            
            if viewCntl.showLogoForAboutUs(){
                viewController.navigationItem.leftBarButtonItem = self.headerWithLogoForAboutUs((viewController as?CXViewController)!)

            }
            
            if viewCntl.backButtonTapped(){
                self.popToRootViewController(animated: true)
                
            }

            
        }
        else{
            viewController.navigationItem.leftBarButtonItem = self.designLeftBarButtonItems(UpdatesViewController())
            viewController.navigationItem.rightBarButtonItem = self.designRightBarButtonItems(UpdatesViewController())
        }
       
    }
}


extension CXNavDrawer {
    
    override func viewWillAppear(_ animated: Bool) {
        self.ToggleWithProfileForSignIn()
        self.ToggleWithProfileForProfile()
        self.ToggleWithProfileWithUserId()
        self.ToggleWithProfileWithoutUserId()
        self.upodateTheCartItems()
    }

    func cartButtonAction(){
        //CartButtonNotification
        drawerHide()
        NotificationCenter.default.post(name: Notification.Name(rawValue: "CartButtonNotification"), object: nil)
        
    }
    
    func notificationBellAction(){
        drawerHide()
        NotificationCenter.default.post(name: Notification.Name(rawValue: "NotificationBellNotification"), object: nil)
    }
    
    
    
    func profileToggleAction(_ sender:UIButton){
        drawerHide()
        if UserDefaults.standard.value(forKey: "USER_ID") == nil{
            chooseArticleDropDown.show()
            ToggleWithProfileWithoutUserId()
        }else{
            chooseArticleDropDown.show()
            ToggleWithProfileWithUserId()
        }
        
    }
    
    func profileToggleActionForProfile(_ sender:UIButton){
        
        chooseArticleDropDown.show()
        ToggleWithProfileForProfile()
    }
    
    func profileToggleActionForSignIn(_ sender:UIButton){
        chooseArticleDropDown.show()
        ToggleWithProfileForSignIn()
    }
    
    
    func ToggleWithProfileWithUserId(){
        chooseArticleDropDown.anchorView = profileBtn
        chooseArticleDropDown.bottomOffset = CGPoint(x: 0, y:self.navigationBar.frame.size.height-7)
        chooseArticleDropDown.dataSource = [
            "Profile                    ","Logout                      "
        ]
        chooseArticleDropDown.selectionAction = {(index, item) in
            self.profileBtn.setTitle(nil, for: UIControlState())
            if index == 0{
                NotificationCenter.default.post(name: Notification.Name(rawValue: "ProfileNotification"), object: nil)
            }else if index == 1{
                self.showAlertView("Are You Sure??", status: 1)
                
            }
        }
    }
    func ToggleWithProfileWithoutUserId(){
        chooseArticleDropDown.anchorView = profileBtn
        chooseArticleDropDown.bottomOffset = CGPoint(x: 0, y:self.navigationBar.frame.size.height-7)
        chooseArticleDropDown.dataSource = [
            "Profile                    "
        ]
        chooseArticleDropDown.selectionAction = {(index, item) in
            self.profileBtn.setTitle(nil, for: UIControlState())
            if index == 0{
                NotificationCenter.default.post(name: Notification.Name(rawValue: "SignInNotification"), object: nil)
            }
        }
    }
    
    
    func ToggleWithProfileForSignIn(){
        chooseArticleDropDown.anchorView = profileBtn
        chooseArticleDropDown.bottomOffset = CGPoint(x: 0, y:self.navigationBar.frame.size.height-7)
        chooseArticleDropDown.dataSource = [
            "Forgot Password?              "
        ]
        chooseArticleDropDown.selectionAction = {(index, item) in
            //self.profileBtn.setTitle(nil, forState: .Normal)
            if index == 0{
                //print("Forgot password")
                NotificationCenter.default.post(name: Notification.Name(rawValue: "ForgotNotification"), object: nil)
//                let forgotPswdViewCnt : CXForgotPassword = CXForgotPassword()
//                let navController: UINavigationController = UINavigationController(rootViewController: forgotPswdViewCnt)
//                self.presentViewController(navController, animated: true, completion: nil)
                
            }
        }
    }
    
    func ToggleWithProfileForProfile(){
        chooseArticleDropDown.anchorView = profileBtn
        chooseArticleDropDown.bottomOffset = CGPoint(x: 0, y:self.navigationBar.frame.size.height-7)
        chooseArticleDropDown.dataSource = [
            "Logout         "
        ]
        chooseArticleDropDown.selectionAction = {(index, item) in
            self.profileBtn.setTitle(nil, for: UIControlState())
            if index == 0{
                self.showAlertView("Are You Sure??", status: 1)
            }
        }
    }
    
    func logout(){
        
        UserDefaults.standard.removeObject(forKey: "STATE")
        UserDefaults.standard.removeObject(forKey: "USER_EMAIL")
        UserDefaults.standard.removeObject(forKey: "FIRST_NAME")
        UserDefaults.standard.removeObject(forKey: "LAST_NAME")
        UserDefaults.standard.removeObject(forKey: "GENDER")
        UserDefaults.standard.removeObject(forKey: "USER_ID")
        UserDefaults.standard.removeObject(forKey: "MAC_ID")
        UserDefaults.standard.removeObject(forKey: "MOBILE")
        UserDefaults.standard.removeObject(forKey: "ADDRESS")
        UserDefaults.standard.removeObject(forKey: "FULL_NAME")
        UserDefaults.standard.removeObject(forKey: "CITY")
        UserDefaults.standard.removeObject(forKey: "ORG_ID")
        UserDefaults.standard.removeObject(forKey: "MACID_JOBID")
        UserDefaults.standard.removeObject(forKey: "ORGANIZATION")
        UserDefaults.standard.removeObject(forKey: "MESSAGE")
        UserDefaults.standard.removeObject(forKey: "STATUS")
        UserDefaults.standard.removeObject(forKey: "COUNTRY")
        UserDefaults.standard.removeObject(forKey: "BANNER_PATH")
        UserDefaults.standard.removeObject(forKey: "IMAGE_PATH")
        UserDefaults.standard.synchronize()
    }
    func showAlertView(_ message:String, status:Int) {
        let alert = UIAlertController(title:message, message: nil, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.default) {
            UIAlertAction in
            if status == 1 {
                self.logout()
                 self.presentWindow?.makeToast(message: "User logout successfully")
                self.popToRootViewController(animated: true)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive) {
            UIAlertAction in
            if status == 1 {
                
            }
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}
