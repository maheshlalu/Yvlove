//
//  MyAppointmentViewController.swift
//  NowFloats
//
//  Created by Rama kuppa on 07/09/17.
//  Copyright © 2017 CX. All rights reserved.
//

import UIKit

class MyAppointmentViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var myAppointmentTableView: UITableView!
    @IBOutlet var bookapptBtn: UIButton!
    var jobArray = NSArray()
    var imageArray = NSArray()
    var nextJobStatusArr = NSArray()
    var statusID = String()
    var statusName = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let nib = UINib(nibName: "MyAppointmentTableViewCell", bundle: nil)
        self.myAppointmentTableView.register(nib, forCellReuseIdentifier: "MyAppointmentTableViewCell")
//bookapptBtn.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
        self.myAppointmentApiCall()
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyAppointmentTableViewCell", for: indexPath)as? MyAppointmentTableViewCell
        let dict = jobArray[indexPath.row] as? NSDictionary
        self.imageArray = (dict?.value(forKey: "jobComments") as? NSArray)!
        print(self.imageArray)
        if imageArray.count != 0{
            let attachmentesDict = imageArray.firstObject as! NSDictionary
            print(attachmentesDict)
            
            let img = attachmentesDict.value(forKey: "logo")
                let imgUrlStr = img
                cell?.imageVIew.setImageWith(URL(string:imgUrlStr as! String), usingActivityIndicatorStyle: .white)
            
        }else{
            
                cell?.imageVIew.image = UIImage(named: "placeholder")
        }
        cell?.imageVIew.layer.cornerRadius = 30
        cell?.imageVIew.layer.borderWidth = 1
        cell?.imageVIew.layer.masksToBounds = true
        
         cell?.selectionStyle = .none
        cell?.doctorNameLabel.text = dict?.value(forKey: "Name") as? String
        cell?.dateLabel.text = dict?.value(forKey: "StartDate") as? String
        cell?.timeLabel.text = dict?.value(forKey: "StartTime") as? String
                return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CancelSlotViewController") as? CancelSlotViewController
        storyboard?.displayDetailsDict = self.jobArray[indexPath.row] as! NSDictionary
        self.navigationController?.pushViewController(storyboard!, animated: true)
       

    }
   
    @IBAction func bookAppointmentBtnAction(_ sender: UIButton) {
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BookingSlotViewController") as? BookingSlotViewController
        
        self.navigationController?.pushViewController(storyboard!, animated: true)
        
    }
    
    func myAppointmentApiCall(){
        
        if UserDefaults.standard.value(forKey: "USER_EMAIL") == nil
        {let alert = UIAlertController.init(title: "YVOLV", message: "Please signIn to view", preferredStyle: .alert)
            let okAction = UIAlertAction.init(title: "Ok", style: .default, handler: { (okAction) in
                self.myAppointmentTableView.isHidden = true
                let name = CXSignInSignUpViewController()
                self.navigationController?.pushViewController(name, animated: true)
                self.dismiss(animated: true, completion: nil)
                
            })
            let cancelAction = UIAlertAction.init(title: "Cancel", style: .destructive, handler: { (cancelAction) in
                
            })
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }else{  self.myAppointmentTableView.isHidden = false
            
            
            
            
            CXDataService.sharedInstance.showLoader(view: self.view, message: "Loading")
            let url = CXAppConfig.sharedInstance.getBaseUrl() + CXAppConfig.sharedInstance.getMasterUrl()
            //CXAppConfig.sharedInstance.getAppMallID()
            CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(url,parameters: ["type":"Resource Allocation" as AnyObject,"mallid":CXAppConfig.sharedInstance.getAppMallID() as AnyObject]) { (responseDict) in
                CXDataService.sharedInstance.hideLoader()
                print(responseDict)
                
                self.jobArray = responseDict.value(forKey: "jobs") as! NSArray
                print(self.jobArray)
                
                
                
                
                self.myAppointmentTableView.reloadData()
            }
        }
    }

}
