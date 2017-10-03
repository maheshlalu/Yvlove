//
//  CancelSlotViewController.swift
//  NowFloats
//
//  Created by Rama on 13/09/17.
//  Copyright © 2017 CX. All rights reserved.
//

import UIKit

class CancelSlotViewController: UIViewController {

    @IBOutlet var displayAppointmentTableView: UITableView!
    @IBOutlet var profileImg: CXImageView!
    
    @IBOutlet var nameLb: UILabel!
    
    @IBOutlet var timeLbl: UILabel!
    
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var cancelApptBtn: UIButton!
    @IBOutlet var imgBackView: UIView!
    @IBOutlet var nameNTimeView: UIView!
    
    
    var displayDetailsDict : NSDictionary!
    var nextJobStatus = NSArray()
    var jobCmtArray = NSArray()
    var dictIds = NSDictionary()
    var listofDisplayDetailsArr = ["Appointment Date","Contact No","Email ID"]
    var valueListArray = NSArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cancelApptBtn .layer.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor().cgColor
        //self.imgBackView.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
        self.nameNTimeView.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
        let nib = UINib(nibName: "CancelSlotTableViewCell", bundle: nil)
        self.displayAppointmentTableView.register(nib, forCellReuseIdentifier: "CancelSlotTableViewCell")
        // Do any additional setup after loading the view.
        CXLog.print("display== \(displayDetailsDict)")
        self.displayDetails()
        self.getStatusofSlots()
        

    }
    func displayDetails()  {
        
        self.nameLb.text = displayDetailsDict.value(forKey: "Name") as? String
        self.timeLbl.text = displayDetailsDict.value(forKey: "StartTime") as? String
        self.jobCmtArray = displayDetailsDict.value(forKey: "jobComments") as! NSArray
       
        for activityData in  self.jobCmtArray{
            let dict:NSDictionary = activityData as! NSDictionary
        let img_Url_Str = (dict.value(forKey: "logo")) as!String
          
            let img_Url = NSURL(string: img_Url_Str )
            self.profileImg.contentMode = .scaleAspectFit
            self.profileImg.setImageWith(img_Url as URL!)
        
        }
        
          let dateStr = displayDetailsDict.value(forKey: "StartDate") as? String
        let contactNoStr = UserDefaults.standard.value(forKey: "MOBILE") as? String

        let mailStr = UserDefaults.standard.value(forKey: "USER_EMAIL") as? String

        self.valueListArray = ([dateStr,contactNoStr,mailStr] as? NSArray)!
    }

    
    
    func getStatusofSlots() {
        self.nextJobStatus = displayDetailsDict.value(forKey: "Next_Job_Statuses") as! NSArray
        for subJob in self.nextJobStatus{
            let dict:NSDictionary  = subJob as! NSDictionary
            let statusNamestr = dict.value(forKey: "Status_Name") as! String
            let statusID = dict.value(forKey: "Status_Id") as! String
            let parentJobIDStr =  CXAppConfig.resultString(input: displayDetailsDict.value(forKey: "id") as AnyObject)
           
            if statusNamestr == "Cancel" {
                let canID = dict.value(forKey: "Status_Id") as! String
            self.dictIds = ["parentID":parentJobIDStr,"CancelID":canID] as NSDictionary
                CXLog.print("IDs==\(self.dictIds )")
               
            }
            
        }
    }
    
    func constructCancelApi() {
        
        
        
    }
 
    @IBAction func cancelBtnAction(_ sender: Any) {
        
        
        let alert = UIAlertController.init(title: CXAppConfig.sharedInstance.getTitleOfApp(), message: "Are you sure you want to cancel appointment ", preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "YES", style: .default) { (okAction) in
            let popup = PopupController
                .create(self)
                .customize(
                    [
                        .animation(.slideUp),
                        .scrollable(false),
                        .layout(.center),
                        .backgroundStyle(.blackFilter(alpha: 0.7))
                    ]
                )
                .didShowHandler { popup in
            
                }
                .didCloseHandler { _ in
            }
            let container = CancelAppointmentViewController.instance()
            container.cancelIDsDict = self.dictIds as NSDictionary
            container.closeHandler = { _ in
                
                
                
                popup.dismiss()
            }
            popup.show(container)
            
            
        }
        let cancelAction = UIAlertAction.init(title: "NO", style: .cancel) { (cancelAction) in
            
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
extension CancelSlotViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.listofDisplayDetailsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CancelSlotTableViewCell", for: indexPath)as? CancelSlotTableViewCell
        cell?.typeOfDisplayLbl.text = self.listofDisplayDetailsArr[indexPath.row]
        cell?.valueDisplayLbl.text = self.valueListArray[indexPath.row] as? String
               return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
}
