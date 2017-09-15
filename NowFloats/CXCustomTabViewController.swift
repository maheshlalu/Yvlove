//
//  CXCustomTabViewController.swift
//  NowFloats
//
//  Created by Rama on 15/09/17.
//  Copyright © 2017 CX. All rights reserved.
//

import UIKit

class CXCustomTabViewController: CXViewController {

    @IBOutlet var customTabtableView: UITableView!
    var nameString:String!
    var jobArray = NSArray()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let nib = UINib(nibName: "customTabTableViewCell", bundle: nil)
        self.customTabtableView.register(nib, forCellReuseIdentifier: "customTabTableViewCell")
        getCustomTabsApi()
    }
    
    
    func getCustomTabsApi() {
        CXDataService.sharedInstance.showLoader(view: self.view, message: "Loading")
      // http://47.91.107.151:8081/Services/getMasters?type=iosSample%20CustomTab&mallId=19
        CXDataService.sharedInstance.getTheAppDataFromServer(["type":nameString as AnyObject,"mallId":CXAppConfig.sharedInstance.getAppMallID() as AnyObject]) { (responseDict) in
            CXDataService.sharedInstance.hideLoader()
            // print("print Campaign\(responseDict)")
            
            self.jobArray = responseDict.value(forKey: "jobs") as! NSArray
            print("jobArray \( self.jobArray)")
            self.customTabtableView.reloadData()
            // self.campCreatedDateArray = responseDict.value(forKey: "createdOn") as! NSArray
        }
  
    }
    
    
    //MAR:Heder options enable
    override  func shouldShowRightMenu() -> Bool{
        return true
    }
    
    override func shouldShowNotificatoinBell() ->Bool{
        return false
    }
    
    override  func shouldShowCart() -> Bool{
        return false
    }
    
    override func headerTitleText() -> String{
        return self.nameString
    }
    
    override func shouldShowLeftMenu() -> Bool{
        return false
    }
    
    override func shouldShowLeftMenuWithLogo() -> Bool{
        return false
    }
    
    override func showLogoForAboutUs() -> Bool{
        return false
    }
    
    override func profileDropdown() -> Bool{
        return false
    }
    
    override func profileDropdownForSignIn() -> Bool{
        return false
    }
}
extension CXCustomTabViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return  self.jobArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customTabTableViewCell", for: indexPath)as? customTabTableViewCell
        let dict = self.jobArray[indexPath.row] as! NSDictionary
        cell?.nameLbl.text = dict.value(forKey: "Name") as? String
        let descrptionStr = dict.value(forKey: "Description") as? String
        cell?.customWebView.loadHTMLString(descrptionStr!, baseURL: URL(string: CXAppConfig.sharedInstance.getBaseUrl()))
        cell?.customWebView.isUserInteractionEnabled = false
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
