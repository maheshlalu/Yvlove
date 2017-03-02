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
    var isFromSignIn = false
    var presentWindow:UIWindow?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CXMixpanel.sharedInstance.mixelProfileTarck()
        if isFromSignIn{
            let notif:NSNotification.Name = NSNotification.Name(rawValue: "FromProfile")
            NotificationCenter.default.post(name: notif, object: nil)
        }
        presentWindow = UIApplication.shared.keyWindow
        self.profileTableView.rowHeight = UITableViewAutomaticDimension
        self.profileTableView.estimatedRowHeight = 10.0
        self.profileTableView.separatorStyle = .none
        headerViewAlignments()
        profileDataIntegration()
        

    }
    
    func profileDataIntegration(){
        
        userNameLbl.text = UserDefaults.standard.value(forKey: "FULL_NAME") as? String
        userMobileLbl.text = UserDefaults.standard.value(forKey: "MOBILE") as? String
        userMailLbl.text = UserDefaults.standard.value(forKey: "USER_EMAIL") as? String
        let imageUrl = UserDefaults.standard.value(forKey: "IMAGE_PATH") as? String
        if (imageUrl != "" && imageUrl != nil){
            dpImageView.sd_setImage(with: URL(string: (UserDefaults.standard.value(forKey: "IMAGE_PATH") as?String)!))
            dpImageView.alpha = 1
            dpImageView.backgroundColor = UIColor.clear
        }else{
           // dpImageView.image = UIImage.init(imageLiteral: "placeholder")
            dpImageView.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
        }
        
      
    }
    override func viewWillAppear(_ animated: Bool) {
        profileDataIntegration()
    }
    @IBAction func editBtnAction(_ sender: AnyObject) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let editProfile = storyBoard.instantiateViewController(withIdentifier: "EDIT_PROFILE") as! EditUserProfileViewController
        editProfile.firstName = UserDefaults.standard.value(forKey: "FIRST_NAME") as? String
        editProfile.lastName = UserDefaults.standard.value(forKey: "LAST_NAME") as? String
        editProfile.mobile = userMobileLbl.text!
        editProfile.emai = userMailLbl.text!
        let imageUrl = UserDefaults.standard.value(forKey: "IMAGE_PATH") as? String
        if (imageUrl != ""){
            editProfile.dpImg = imageUrl
        }
        
        self.navigationController?.pushViewController(editProfile, animated: true)
        
    }

    func headerViewAlignments(){
        
        self.profileView.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
        self.dpImageView.clipsToBounds = true
        self.dpImageView.layer.cornerRadius = 45.5
        self.dpImageView.layer.borderWidth = 3.0
        self.dpImageView.layer.borderColor = UIColor.white.cgColor
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 6
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return 1
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell: UITableViewCell? = nil
        
        if indexPath.section == 0{
            let imageCellIdentifier = "Orders"
            cell = tableView.dequeueReusableCell(withIdentifier: imageCellIdentifier)!
            cell?.accessoryType = .disclosureIndicator;
            cell?.selectionStyle = .none
            
            let btn = cell?.viewWithTag(100) as! UIButton
            btn.isUserInteractionEnabled = false
            btn.imageView?.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
            btn.setTitleColor(CXAppConfig.sharedInstance.getAppTheamColor(), for: UIControlState())
           
        
        }else if indexPath.section == 1{
            let headerCellIdentifier = "Address"
            cell = tableView.dequeueReusableCell(withIdentifier: headerCellIdentifier)!
            cell?.selectionStyle = .none
            
            
        }else if indexPath.section == 2{
            let productInfoIdentifier = "Notifications"
            cell = tableView.dequeueReusableCell(withIdentifier: productInfoIdentifier)!
            cell?.accessoryType = .disclosureIndicator;
            cell?.selectionStyle = .none
            
            let btn = cell?.viewWithTag(300) as! UIButton
            btn.isUserInteractionEnabled = false
            btn.imageView?.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
            //btn.setTitleColor(CXAppConfig.sharedInstance.getAppTheamColor(), forState: .Normal)

            
        }else if indexPath.section == 3{
            let footerIdentifier = "Rate"
            cell = tableView.dequeueReusableCell(withIdentifier: footerIdentifier)!
            cell?.selectionStyle = .none
            cell?.accessoryType = .disclosureIndicator;
            
            let btn = cell?.viewWithTag(400) as! UIButton
            btn.isUserInteractionEnabled = false
            btn.imageView?.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
           // btn.setTitleColor(CXAppConfig.sharedInstance.getAppTheamColor(), forState: .Normal)

        }else if indexPath.section == 4{
            let productInfoIdentifier = "Share"
            cell = tableView.dequeueReusableCell(withIdentifier: productInfoIdentifier)!
            cell?.selectionStyle = .none
            cell?.accessoryType = .disclosureIndicator;
            
            let btn = cell?.viewWithTag(500) as! UIButton
            btn.isUserInteractionEnabled = false
            btn.imageView?.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
            //btn.setTitleColor(CXAppConfig.sharedInstance.getAppTheamColor(), forState: .Normal)
            
            
        }else if indexPath.section == 5{
            let footerIdentifier = "Legal"
            cell = tableView.dequeueReusableCell(withIdentifier: footerIdentifier)!
            cell?.selectionStyle = .none
            cell?.accessoryType = .disclosureIndicator;
            
            let btn = cell?.viewWithTag(600) as! UIButton
            btn.isUserInteractionEnabled = false
            btn.imageView?.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
           // btn.setTitleColor(CXAppConfig.sharedInstance.getAppTheamColor(), forState: .Normal)
        }
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if indexPath.section == 0{
            let orders = storyBoard.instantiateViewController(withIdentifier: "ORDERS") as! OrdersViewController
            self.navigationController?.pushViewController(orders, animated: true)
        }else if indexPath.section == 2{
//            let profile = storyBoard.instantiateViewController(withIdentifier: "NOTIFICATIONS") as! NotificationsViewController
//            self.navigationController?.pushViewController(profile, animated: true)
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
        activityViewController.excludedActivityTypes = [UIActivityType.print, UIActivityType.postToWeibo, UIActivityType.copyToPasteboard, UIActivityType.addToReadingList, UIActivityType.postToVimeo]
        self.present(activityViewController, animated: true, completion: nil)
        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
       
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 10
    }
    
    //MAR:Heder options esable
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
