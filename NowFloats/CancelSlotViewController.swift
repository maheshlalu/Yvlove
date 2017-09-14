//
//  CancelSlotViewController.swift
//  NowFloats
//
//  Created by Rama on 13/09/17.
//  Copyright © 2017 CX. All rights reserved.
//

import UIKit

class CancelSlotViewController: UIViewController {

    @IBOutlet var profileImg: CXImageView!
    
    @IBOutlet var nameLb: UILabel!
    
    @IBOutlet var timeLbl: UILabel!
    
    @IBOutlet var dateLbl: UILabel!
    var displayDetailsDict : NSDictionary!
    var nextJobStatus = NSArray()
    var jobCmtArray = NSArray()
    var cancelID = String()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        CXLog.print("display== \(displayDetailsDict)")
        self.displayDetails()
        self.getStatusofSlots()
        

    }
    func displayDetails()  {
        
        self.nameLb.text = displayDetailsDict.value(forKey: "Name") as? String
        self.dateLbl.text = displayDetailsDict.value(forKey: "StartDate") as? String
        
        self.timeLbl.text = displayDetailsDict.value(forKey: "StartTime") as? String
        

        self.jobCmtArray = displayDetailsDict.value(forKey: "jobComments") as! NSArray
       
        for activityData in  self.jobCmtArray{
            let dict:NSDictionary = activityData as! NSDictionary
        let img_Url_Str = (dict.value(forKey: "logo")) as!String
          
            let img_Url = NSURL(string: img_Url_Str )
            self.profileImg.contentMode = .scaleAspectFit
            self.profileImg.setImageWith(img_Url as URL!)
        
        }
    }

    
    
    func getStatusofSlots() {
        self.nextJobStatus = displayDetailsDict.value(forKey: "Next_Job_Statuses") as! NSArray
        for subJob in self.nextJobStatus{
            let dict:NSDictionary  = subJob as! NSDictionary
            let statusNamestr = dict.value(forKey: "Status_Name") as! String
            let statusID = dict.value(forKey: "Status_Id") as! String
            if statusNamestr == "Rejected" {
                let canID = dict.value(forKey: "Status_Id") as! Int

                self.cancelID = String(canID)
                CXLog.print("cancelID== \( self.cancelID )")
            }
            
        }
    }
    
    func constructCancelApi() {
        
        
        
    }
 
    @IBAction func cancelBtnAction(_ sender: Any) {
    }
}
