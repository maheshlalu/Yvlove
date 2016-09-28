//
//  UserProfileViewController.swift
//  NowFloats
//
//  Created by Manishi on 9/14/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit

class UserProfileViewController: CXViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var profileTableView: UITableView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userMobileLbl: UILabel!
    @IBOutlet weak var userMailLbl: UILabel!
    @IBOutlet weak var dpImageView: UIImageView!
    var presentWindow:UIWindow?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presentWindow = UIApplication.sharedApplication().keyWindow
        self.profileTableView.rowHeight = UITableViewAutomaticDimension
        self.profileTableView.estimatedRowHeight = 10.0
        self.profileTableView.separatorStyle = .None
        headerViewAlignments()
        profileDataIntegration()

    }
    
    func profileDataIntegration(){
        userNameLbl.text = NSUserDefaults.standardUserDefaults().valueForKey("FULL_NAME") as? String
        userMobileLbl.text = NSUserDefaults.standardUserDefaults().valueForKey("MOBILE") as? String
        userMailLbl.text = NSUserDefaults.standardUserDefaults().valueForKey("USER_EMAIL") as? String
        let imageUrl = NSUserDefaults.standardUserDefaults().valueForKey("IMAGE_PATH") as? String
        if (imageUrl != ""){
            dpImageView.sd_setImageWithURL(NSURL(string: (NSUserDefaults.standardUserDefaults().valueForKey("IMAGE_PATH") as?String)!))
            dpImageView.alpha = 1
            dpImageView.backgroundColor = UIColor.clearColor()
        }else{
           // dpImageView.image = UIImage.init(imageLiteral: "placeholder")
            dpImageView.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
        }
        
      
    }
    @IBAction func editBtnAction(sender: AnyObject) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let editProfile = storyBoard.instantiateViewControllerWithIdentifier("EDIT_PROFILE") as! EditUserProfileViewController
        editProfile.firstName = NSUserDefaults.standardUserDefaults().valueForKey("FIRST_NAME") as? String
        editProfile.lastName = NSUserDefaults.standardUserDefaults().valueForKey("LAST_NAME") as? String
        editProfile.mobile = userMobileLbl.text!
        editProfile.emai = userMailLbl.text!
        let imageUrl = NSUserDefaults.standardUserDefaults().valueForKey("IMAGE_PATH") as? String
        if (imageUrl != ""){
            editProfile.dpImg = imageUrl
        }
        
        self.navigationController?.pushViewController(editProfile, animated: true)
        
    }

    func headerViewAlignments(){
        self.profileView.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
        self.dpImageView.clipsToBounds = true
        self.dpImageView.layer.cornerRadius = self.dpImageView.bounds.size.width/6
        self.dpImageView.layer.borderWidth = 3.0
        self.dpImageView.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 6
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return 1
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell: UITableViewCell? = nil
        
        if indexPath.section == 0{
            let imageCellIdentifier = "Orders"
            cell = tableView.dequeueReusableCellWithIdentifier(imageCellIdentifier)!
            cell?.accessoryType = .DisclosureIndicator;
            cell?.selectionStyle = .None
            
            let btn = cell?.viewWithTag(100) as! UIButton
            btn.userInteractionEnabled = false
            btn.imageView?.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
            btn.setTitleColor(CXAppConfig.sharedInstance.getAppTheamColor(), forState: .Normal)
           
        
        }else if indexPath.section == 1{
            let headerCellIdentifier = "Address"
            cell = tableView.dequeueReusableCellWithIdentifier(headerCellIdentifier)!
            cell?.selectionStyle = .None
            
            
        }else if indexPath.section == 2{
            let productInfoIdentifier = "Notifications"
            cell = tableView.dequeueReusableCellWithIdentifier(productInfoIdentifier)!
            cell?.accessoryType = .DisclosureIndicator;
            cell?.selectionStyle = .None
            
            let btn = cell?.viewWithTag(300) as! UIButton
            btn.userInteractionEnabled = false
            btn.imageView?.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
            //btn.setTitleColor(CXAppConfig.sharedInstance.getAppTheamColor(), forState: .Normal)

            
        }else if indexPath.section == 3{
            let footerIdentifier = "Rate"
            cell = tableView.dequeueReusableCellWithIdentifier(footerIdentifier)!
            cell?.selectionStyle = .None
            cell?.accessoryType = .DisclosureIndicator;
            
            let btn = cell?.viewWithTag(400) as! UIButton
            btn.userInteractionEnabled = false
            btn.imageView?.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
           // btn.setTitleColor(CXAppConfig.sharedInstance.getAppTheamColor(), forState: .Normal)

        }else if indexPath.section == 4{
            let productInfoIdentifier = "Share"
            cell = tableView.dequeueReusableCellWithIdentifier(productInfoIdentifier)!
            cell?.selectionStyle = .None
            cell?.accessoryType = .DisclosureIndicator;
            
            let btn = cell?.viewWithTag(500) as! UIButton
            btn.userInteractionEnabled = false
            btn.imageView?.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
            //btn.setTitleColor(CXAppConfig.sharedInstance.getAppTheamColor(), forState: .Normal)
            
            
        }else if indexPath.section == 5{
            let footerIdentifier = "Legal"
            cell = tableView.dequeueReusableCellWithIdentifier(footerIdentifier)!
            cell?.selectionStyle = .None
            cell?.accessoryType = .DisclosureIndicator;
            
            let btn = cell?.viewWithTag(600) as! UIButton
            btn.userInteractionEnabled = false
            btn.imageView?.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
           // btn.setTitleColor(CXAppConfig.sharedInstance.getAppTheamColor(), forState: .Normal)
        }
        return cell!
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        if indexPath.section == 0{
            let orders = storyBoard.instantiateViewControllerWithIdentifier("ORDERS") as! OrdersViewController
            self.navigationController?.pushViewController(orders, animated: true)
        }else if indexPath.section == 2{
            let profile = storyBoard.instantiateViewControllerWithIdentifier("NOTIFICATIONS") as! NotificationsViewController
            self.navigationController?.pushViewController(profile, animated: true)
        }else if indexPath.section == 3{
            let comentsView = CXCommentViewController.init()
            self.navigationController?.pushViewController(comentsView, animated: true)
        }else if indexPath.section == 4 {
            shareAppAction()
        }else if indexPath.section == 5{
            presentWindow?.makeToast(message: "Disclaimer to be shown")
        }
    }
    
    func shareAppAction(){
    
        let description = "Coming Soon"
        let url = "Coming Soon"
        
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: [description,url], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivityTypePrint, UIActivityTypePostToWeibo, UIActivityTypeCopyToPasteboard, UIActivityTypeAddToReadingList, UIActivityTypePostToVimeo]
        self.presentViewController(activityViewController, animated: true, completion: nil)
        
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
       
    }
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 10
    }
    
    //MAR:Heder options enable
    override  func shouldShowRightMenu() -> Bool{
        
        return true
    }
    
    override func shouldShowNotificatoinBell() ->Bool{
        
        return false
    }
    
    override  func shouldShowCart() -> Bool{
        
        return true
    }
    
    override func shouldShowLeftMenu() -> Bool{
        
        return false
    }
    override func showLogoForAboutUs() -> Bool{
        return false
    }
    override func shouldShowLeftMenuWithLogo() -> Bool{
        
        return false
    }
    override func headerTitleText() -> String{
        return "Profile"
    }
    
    override func profileDropdown() -> Bool{
        return true
    }
    
    override func profileDropdownForSignIn() -> Bool{
        return false
    }

}
