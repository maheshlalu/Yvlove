//
//  NotificationsViewController.swift
//  NowFloats
//
//  Created by Manishi on 9/19/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit

class NotificationsViewController: CXViewController,UITableViewDataSource,UITableViewDelegate {
    var dataNotification = NSMutableArray()
    
    @IBOutlet weak var notificationTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        CXMixpanel.sharedInstance.mixelNotificationTrack()
        
        let nib = UINib(nibName: "NotificationTableViewCell", bundle: nil)
        self.notificationTableView.register(nib, forCellReuseIdentifier: "NotificationTableViewCell")
        
        self.notificationTableView.rowHeight = UITableViewAutomaticDimension
        self.notificationTableView.estimatedRowHeight = 93
        self.notificationTableView.backgroundColor = UIColor.clear
        self.view.backgroundColor = CXAppConfig.sharedInstance.getAppBGColor()
        self.getNotificationService()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataNotification.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath)as! NotificationTableViewCell
        //        cell.backgroundColor = UIColor.clear
        //        cell.backgroundView?.backgroundColor = UIColor.clear
        //        cell.viewInBG.backgroundColor = UIColor.white
        //        cell.viewInBG.layer.borderWidth = 1.0
        //        cell.viewInBG.layer.borderColor = UIColor.lightGray.cgColor
        //        cell.viewInBG.layer.cornerRadius = 8.0
        //        cell.viewmore.layer.cornerRadius = 8.0
        //        cell.viewmore.layer.borderWidth = 0.0
        let dict:NSDictionary = self.dataNotification.object(at: indexPath.section) as! NSDictionary
        cell.title.text = dict.value(forKey: "Name") as? String
        cell.date.text = dict.value(forKey: "createdOn") as? String
        cell.desc.text = dict.value(forKey: "Description") as? String
        cell.viewMoreBtn.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
        cell.viewMoreBtn.addTarget(self, action: #selector(morebtnTapped(_:)), for: .touchUpInside)
        cell.viewMoreBtn.tag = indexPath.section
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 113
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 3
    }
    
    func getNotificationService(){
        
        let dataKyes = ["type":"keys","mallId":CXAppConfig.sharedInstance.getAppMallID()]
        CXDataService.sharedInstance.getTheAppDataFromServer(dataKyes as [String : AnyObject]?) { (responceDic) in
            let jobsData:NSArray = responceDic.value(forKey: "jobs")! as! NSArray
            for dictData in jobsData {
                self.dataNotification.add(dictData)
            }
            self.notificationTableView.reloadData()
        }
    }
    func morebtnTapped(_ sender:UIButton){
        let dict: NSDictionary = self.dataNotification.object(at: sender.tag) as! NSDictionary
        // let desc = dict.value(forKey: "Description") as! String
        
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let description = storyBoard.instantiateViewController(withIdentifier: "NOTIFICATION") as! NotificationDescriptionViewController
        let navController = UINavigationController(rootViewController: description)
        navController.navigationItem.hidesBackButton = false
        description.dict = dict
        self.present(navController, animated: true, completion: nil)
        
    }
    
}
