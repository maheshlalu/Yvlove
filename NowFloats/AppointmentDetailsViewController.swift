//
//  AppointmentDetailsViewController.swift
//  NowFloats
//
//  Created by Rama kuppa on 07/09/17.
//  Copyright © 2017 CX. All rights reserved.
//

import UIKit

class AppointmentDetailsViewController: CXViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var detailsTableView: UITableView!
    
    
    let name = ["Name","Mail","Description","MobileNo","Date","Time"]
    
   
    var nameTextFiled = UITextField()
    var mailTextField = UITextField()
    var descriptionTextField = UITextField()
    var mobleNoTextField = UITextField()
    var dateTextField = UITextField()
    var timeTextField = UITextField()
    var cellArray = NSMutableArray()
    var dateNtimeDict : NSDictionary!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    let nib = UINib(nibName: "AppointmentDetailsTableViewCell", bundle: nil)
        self.detailsTableView.register(nib, forCellReuseIdentifier: "AppointmentDetailsTableViewCell")
        
        
        for obj in name {
            let cell = Bundle.main.loadNibNamed("AppointmentDetailsTableViewCell",
                                                owner: nil,
                                                options: nil)?.first as! AppointmentDetailsTableViewCell
            cellArray.add(cell)
        }
        
        self.detailsTableView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0)
        self.automaticallyAdjustsScrollViewInsets = false

        
        
        CXLog.print(dateNtimeDict)
        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cellArray.count
    
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       /* let cell = tableView.dequeueReusableCell(withIdentifier: "AppointmentDetailsTableViewCell", for: indexPath)as? AppointmentDetailsTableViewCell*/
        let cell = cellArray[indexPath.row] as! AppointmentDetailsTableViewCell
        if indexPath.row == 0{
            
            self.nameTextFiled = cell.detailTextField
            self.nameTextFiled.placeholder = "Name"
            self.nameTextFiled.text = UserDefaults.standard.value(forKey: "FULL_NAME") as? String
            self.nameTextFiled.isUserInteractionEnabled = false
            
        }else if indexPath.row == 1{
            self.mailTextField = cell.detailTextField
            self.mailTextField.placeholder = "Mail"
             self.mailTextField.text = UserDefaults.standard.value(forKey: "USER_EMAIL") as? String
            self.mailTextField.isUserInteractionEnabled = false
        }else if indexPath.row == 2{
            
            self.descriptionTextField = cell.detailTextField
            self.descriptionTextField.placeholder = "Description"
        }else if indexPath.row == 3{
            
            
            self.mobleNoTextField = cell.detailTextField
            self.mobleNoTextField.placeholder = "MobileNo"
             self.mobleNoTextField.text = UserDefaults.standard.value(forKey: "MOBILE") as? String
        }else if indexPath.row == 4{
            
            self.dateTextField = cell.detailTextField
            self.dateTextField.placeholder = "Date"
            let str = dateNtimeDict.value(forKey: "date") as? String
            self.dateTextField.text = str
            self.dateTextField.isUserInteractionEnabled = false
        }else if indexPath.row == 5{
            
            self.timeTextField = cell.detailTextField
            self.timeTextField.placeholder = "Time"
            self.timeTextField.text = dateNtimeDict.value(forKey: "time") as? String
            self.timeTextField.isUserInteractionEnabled = false
        }
        cell.selectionStyle = .none
        return cell
    }
    
    @IBAction func detailsSubmitBtnAction(_ sender: UIButton) {
        
        
      if  ValidationAllTextFields(){
            
            self.postSlotRequest()
        
        }
       
    }
    func postSlotRequest() {
    CXDataService.sharedInstance.showLoader(view: self.view, message: "Loading")
         let parameterDic : NSDictionary = NSDictionary(objects: [self.nameTextFiled.text!,self.mailTextField.text!,self.descriptionTextField.text!,self.mailTextField.text!,self.dateTextField.text!,self.timeTextField.text! ], forKeys:["Name" as NSCopying,"Contact Number" as NSCopying,"Description" as NSCopying,"Email" as NSCopying,"StartDate" as NSCopying,"StartTime" as NSCopying,] )
        CXLog.print(parameterDic)
        
    
        let listArray : NSMutableArray = NSMutableArray()
        
        listArray.add(parameterDic)
        
        let formDict :NSMutableDictionary = NSMutableDictionary()
        formDict.setObject(listArray, forKey: "list" as NSCopying)
        
        var jsonData : Data = Data()
        do {
            jsonData = try JSONSerialization.data(withJSONObject: formDict, options: JSONSerialization.WritingOptions.prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
        } catch let error as NSError {
        }
        let jsonStringFormat = String(data: jsonData, encoding: String.Encoding.utf8)
        
        
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getPlaceOrderUrl(),parameters: ["type":"Resource Allocation"as AnyObject,"json":jsonStringFormat as AnyObject,"userId":CXAppConfig.sharedInstance.getAppMallID() as AnyObject,"category":"CalenderEvents" as AnyObject,"dt":"STORES" as AnyObject,"consumerEmail":self.mailTextField.text! as AnyObject,"parentJobId":dateNtimeDict.value(forKey: "jobID") as AnyObject]) { (responseDict) in
            CXDataService.sharedInstance.hideLoader()
            CXLog.print(responseDict)
            let  status = responseDict.value(forKey: "status") as! String
            var msg:String!
            if status == "1"{
                 msg = "Your appointment has been booked."
            }else{
                 msg = "Error,Sorry please book again."
            }
            let alert = UIAlertController.init(title: "YVOLV", message: msg, preferredStyle: .alert)
            let okAction = UIAlertAction.init(title: "Ok", style: .default) { (okAction) in
                
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)

            
            
        }
        
    }
    
    func ValidationAllTextFields() -> Bool{
        
            if self.nameTextFiled.text?.characters.count == 0 {
                CXDataService.sharedInstance.showAlert(message: "Please Enter Name", viewController: self)
                return false
            }
            else if self.mailTextField.text?.characters.count == 0 {
                CXDataService.sharedInstance.showAlert(message: "Please Enter mail", viewController: self)
                return false
            }
            else if self.descriptionTextField.text?.characters.count == 0 {
                
                
                CXDataService.sharedInstance.showAlert(message: "Please Enter the description", viewController: self)
                return false
            }
            else if self.mobleNoTextField.text?.characters.count == 0 {
                CXDataService.sharedInstance.showAlert(message: "Please Enter Mobile No", viewController: self)
                return false
            }
            else if self.dateTextField.text?.characters.count == 0 {
                CXDataService.sharedInstance.showAlert(message: "Please Enter Date", viewController: self)
                return false
            }
            else if self.timeTextField.text?.characters.count == 0 {
                CXDataService.sharedInstance.showAlert(message: "Please Enter Time", viewController: self)
                return false
            }
            else {
                return true
            }
        }
    func showAlert(){
        
        let alertController = UIAlertController(title: "YVOLVE", message: "Please Enter all fields", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    //MAR:Heder options enable
    override  func shouldShowRightMenu() -> Bool{
        return false
    }
    
    override func shouldShowNotificatoinBell() ->Bool{
        return false
    }
    
    override  func shouldShowCart() -> Bool{
        return false
    }
    
    override func headerTitleText() -> String{
        return "Booking Slot Time"
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
