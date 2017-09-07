//
//  CXLoyalCrdViewController.swift
//  NowFloats
//
//  Created by Rama on 05/09/17.
//  Copyright © 2017 CX. All rights reserved.
//

import UIKit

class CXLoyalCrdViewController: CXViewController{

    @IBOutlet var summaryTableView: UITableView!
    var summaryArr = NSArray()
     var jobInstanceArr = NSArray()
    var allActivitiesArr:NSMutableArray = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "LoyalSunmmaryTableViewCell", bundle: nil)
        self.summaryTableView.register(nib, forCellReuseIdentifier: "LoyalSunmmaryTableViewCell")
        //getLoyalcards()
    }
    override func viewWillAppear(_ animated: Bool) {
        getLoyalcards()
    }
   
    func getLoyalcards(){
//                if UserDefaults.standard.value(forKey: "USER_EMAIL") == nil
//                {let alert = UIAlertController.init(title: "YVOLV", message: "Please signIn to view", preferredStyle: .alert)
//                    let okAction = UIAlertAction.init(title: "Ok", style: .default, handler: { (okAction) in
//                   self.summaryTableView.isHidden = true
//                        let name = CXSignInSignUpViewController()
//                        self.navigationController?.pushViewController(name, animated: true)
//                        self.dismiss(animated: true, completion: nil)
//        
//                    })
//                    let cancelAction = UIAlertAction.init(title: "Cancel", style: .destructive, handler: { (cancelAction) in
//                        
//                    })
//                    alert.addAction(okAction)
//                    alert.addAction(cancelAction)
//                    self.present(alert, animated: true, completion: nil)
//                }else{
                    self.summaryTableView.isHidden = false
        let emailString = UserDefaults.standard.value(forKey: "USER_EMAIL")
        //CXAppConfig.sharedInstance.getAppMallID()
        //http://storeongo.com:8081/MobileAPIs/getConJobInstances?email=k@k.com&ownerId=4724
        let urlStr = CXAppConfig.sharedInstance.getBaseUrl() + CXAppConfig.sharedInstance.getLoyalcards()
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(urlStr, parameters: ["email":emailString as AnyObject,"ownerId":CXAppConfig.sharedInstance.getAppMallID() as AnyObject]) { (responseDict) in
            CXLog.print(responseDict)
            let activityArr = responseDict.value(forKey: "jobinstances") as! NSArray
             CXLog.print(activityArr)
            for activityData in activityArr{
                let dict:NSDictionary = activityData as! NSDictionary
                let activities = (dict.value(forKey: "actvities")!) as! NSArray
                self.allActivitiesArr.addObjects(from: activities as! [Any])
            }
            CXLog.print("ALL Activities== \(self.allActivitiesArr.description)")
             self.summaryTableView.reloadData()
            //self.summaryTableView.endUpdates()
        }
       // }
    }
}
extension CXLoyalCrdViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return allActivitiesArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
       let cell = tableView.dequeueReusableCell(withIdentifier: "LoyalSunmmaryTableViewCell", for: indexPath)as? LoyalSunmmaryTableViewCell
       let dict = self.allActivitiesArr[indexPath.row] as! NSDictionary
       let nameString = dict.value(forKey: "name") as! String
       let valueString = dict.value(forKey: "value") as! String
       let timeString = dict.value(forKey: "time") as! String      
       let summaryStr = " You got points "+valueString+" for "+nameString+" on "+timeString as! NSMutableString
      cell?.summaryDetailLbl.text = summaryStr as String
        cell?.selectionStyle = .none
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
}
//    //MAR:Heder options enable
//    override  func shouldShowRightMenu() -> Bool{
//        return true
//    }
//    
//    override func shouldShowNotificatoinBell() ->Bool{
//        return true
//    }
//    
//    override  func shouldShowCart() -> Bool{
//        return true
//    }
//    
//    override func headerTitleText() -> String{
//        return ""
//    }
//    
//    override func shouldShowLeftMenu() -> Bool{
//        return false
//    }
//    
//    override func shouldShowLeftMenuWithLogo() -> Bool{
//        return false
//    }
//    
//    override func showLogoForAboutUs() -> Bool{
//        return false
//    }
//    
//    override func profileDropdown() -> Bool{
//        return false
//    }
//    
//    override func profileDropdownForSignIn() -> Bool{
//        return false
//    }
    

}
