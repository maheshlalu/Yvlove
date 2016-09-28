//
//  ViewController.swift
//  Nowfloatsenquiry
//
//  Created by Rama kuppa on 15/09/16.
//  Copyright © 2016 Mahesh. All rights reserved.
//

import UIKit

class EnquiryViewController: CXViewController,UITableViewDataSource,UITableViewDelegate {
    
 var nameArray = ["indiadsaghfdhgafshgdfjhsafdjhfasjhdfhjasfdhjfasjhdfjhsafdjhfasjhdfjhsafdhjfsdhg"]
    @IBOutlet var enquiryTableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "EnquiryTableViewCell", bundle: nil)
        self.enquiryTableview.registerNib(nib, forCellReuseIdentifier: "EnquiryTableViewCell")
        self.enquiryTableview.rowHeight = UITableViewAutomaticDimension
        self.enquiryTableview.estimatedRowHeight = 10.5
        
        UITabBar.appearance().tintColor = CXAppConfig.sharedInstance.getAppTheamColor()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        
        
      return nameArray.count
        
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        
       return 1
        
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        
        
        
       let cell = enquiryTableview.dequeueReusableCellWithIdentifier("EnquiryTableViewCell", forIndexPath: indexPath)as! EnquiryTableViewCell
        cell.selectionStyle = .None
        
        cell.enquiryActivebutton.layer.cornerRadius = 10
        
        cell.enquiryActivebutton.clipsToBounds = true

        cell.enquiryActivebutton.layer.borderWidth = 1
        cell.enquiryActivebutton.layer.backgroundColor = UIColor.blackColor().CGColor
        
        cell.enquiryfpldTextlabel?.text = nameArray[indexPath.section]
        return cell
        
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        
       /* tableView.rowHeight = 150
        return 150*/
        return UITableViewAutomaticDimension
        
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        
        return 20
        
    }
    /* func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
     {
        
        return 10
        
    }*/
   
    //MAR:Heder options enable
    override  func shouldShowRightMenu() -> Bool{
        
        return true
    }
    
    override func shouldShowNotificatoinBell() ->Bool{
        
        return true
    }
    
    override  func shouldShowCart() -> Bool{
        
        return false
    }
    
    
    override func headerTitleText() -> String{
        return "Enquiry"
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
    
    override func profileDropdown() -> Bool{
        return false
    }
    
    override func profileDropdownForSignIn() -> Bool{
        return false
    }


}

