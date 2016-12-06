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
        self.enquiryTableview.register(nib, forCellReuseIdentifier: "EnquiryTableViewCell")
        self.enquiryTableview.rowHeight = UITableViewAutomaticDimension
        self.enquiryTableview.estimatedRowHeight = 10.5
        
        UITabBar.appearance().tintColor = CXAppConfig.sharedInstance.getAppTheamColor()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        
        
      return nameArray.count
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        
       return 1
        
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        
        
        
       let cell = enquiryTableview.dequeueReusableCell(withIdentifier: "EnquiryTableViewCell", for: indexPath)as! EnquiryTableViewCell
        cell.selectionStyle = .none
        
        cell.enquiryActivebutton.layer.cornerRadius = 10
        
        cell.enquiryActivebutton.clipsToBounds = true

        cell.enquiryActivebutton.layer.borderWidth = 1
        cell.enquiryActivebutton.layer.backgroundColor = UIColor.black.cgColor
        
        cell.enquiryfpldTextlabel?.text = nameArray[indexPath.section]
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        
       /* tableView.rowHeight = 150
        return 150*/
        return UITableViewAutomaticDimension
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
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

