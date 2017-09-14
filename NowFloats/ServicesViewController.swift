//
//  OtpViewController.swift
//  Marsh
//
//  Created by Rama kuppa on 09/08/17.
//  Copyright © 2017 sample. All rights reserved.
//

import UIKit

class ServicesViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var popUpView: UIView!
    var navController : CXNavDrawer = CXNavDrawer()
    var servicesNamesArray = NSArray()
    var serviceArray = ["Contact Us","Book Appointment","General Service","My Orders"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "ServicesTableViewCell", bundle: nil)
        
        self.tableView.register(nib, forCellReuseIdentifier: "ServicesTableViewCell")
        
        getServiceApiCall()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return servicesNamesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dict = servicesNamesArray[indexPath.row]as? NSDictionary
        
        print(dict)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServicesTableViewCell", for: indexPath)as? ServicesTableViewCell
        
        cell?.servicesLabel.text = dict?.value(forKey: "Name") as? String
        
        return cell!
    }
    
    func getServiceApiCall(){
        
        let urlString = CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getMasterUrl()
        
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(urlString,parameters: ["type":"ServicesCategories" as AnyObject,"mallId":CXAppConfig.sharedInstance.getAppMallID() as AnyObject]) { (responsDict) in
            print(responsDict)
            self.servicesNamesArray = (responsDict.value(forKey: "jobs")as? NSArray)!
            print(self.servicesNamesArray)
            self.tableView.reloadData()
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            //let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let service =  ServiceFormViewController.init()
        
        let nccontroller = UINavigationController(rootViewController: service)
            let dict = servicesNamesArray[indexPath.row]as? NSDictionary
            service.serViceCategory = (dict?.value(forKey: "Name") as? String)!
        service.headerDict = dict!
        service.isFrom = "popup"
        self.present(nccontroller, animated: true, completion: nil)
            //self.present(service, animated: true, completion: nil)
            //appdelegate.window?.rootViewController? = service
    }
    
    @IBAction func closeBtnAction(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
}
