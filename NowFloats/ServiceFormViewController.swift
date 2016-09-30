//
//  ServiceFormViewController.swift
//  NowFloats
//
//  Created by apple on 29/09/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit
import Eureka

/*name: "Name",
 addMore: false,
 type: "Small Text",
 mandatory: "false",
 allowedValues: "",
 multiselect: "false",
 groupName: "",
 dependentFields: "",
 propgateValueToSubFormFields: ""
 
 
 
 lang_label: "LBL_JOB_TYPE_67585_NAME",
 name: "Name",
 type: "Small Text",
 mandatory: "true",
 allowedValues: "",
 multiselect: "false",
 groupName: "Patient Information",
 dependentFields: "",
 mask: "",
 propgateValueToSubFormFields: ""
 },
 
 */

//http://storeongo.com:8081/Services/getMasters?type=allServicesJobTypes&mallId=15279
class ServiceFormViewController: FormViewController {
    
    var seriveformDataArray : NSMutableArray = NSMutableArray()
    var groupNames : NSMutableArray = NSMutableArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadingView.show(true)
        CXDataService.sharedInstance.getTheAppDataFromServer(["type":"allServicesJobTypes","mallId":"15279"/*CXAppConfig.sharedInstance.getAppMallID()*/]) { (responseDict) in
            let jobs : NSArray =  responseDict.valueForKey("orgs")! as! NSArray
            let service = Serices(name: "Email", addMore: "", type: "Small Text", dependentFields: "", mandatory: "", allowedValues: "", multiselect: "", groupName: "", propgateValueToSubFormFields: "")
            self.seriveformDataArray.addObject(service)
            for serviceDic in jobs {
                let type:String = (serviceDic.valueForKey("type") as? String)!
                if type == "Book Appointment" {
                    for fieldDic in (serviceDic.valueForKey("Fields") as? NSArray)! {
                        let servicData = Serices(name: self.isContansKey(fieldDic as! NSDictionary, key: "name") ? (fieldDic.valueForKey("name") as? String)! : "",
                                                 addMore: self.isContansKey(fieldDic as! NSDictionary, key: "addMore") ? (fieldDic.valueForKey("addMore") as? String)! : "",
                                                 type: self.isContansKey(fieldDic as! NSDictionary, key: "type") ? (fieldDic.valueForKey("type") as? String)! : "",
                                                 dependentFields: self.isContansKey(fieldDic as! NSDictionary, key: "dependentFields") ? (fieldDic.valueForKey("dependentFields") as? String)! : "",
                                                 mandatory: self.isContansKey(fieldDic as! NSDictionary, key: "mandatory") ? (fieldDic.valueForKey("mandatory") as? String)! : "",
                                                 allowedValues: self.isContansKey(fieldDic as! NSDictionary, key: "allowedValues") ? (fieldDic.valueForKey("allowedValues") as? String)! : "",
                                                 multiselect: self.isContansKey(fieldDic as! NSDictionary, key: "multiselect") ? (fieldDic.valueForKey("multiselect") as? String)! : "",
                                                 groupName: self.isContansKey(fieldDic as! NSDictionary, key: "groupName") ? (fieldDic.valueForKey("groupName") as? String)! : "",
                                                 propgateValueToSubFormFields: self.isContansKey(fieldDic as! NSDictionary, key: "propgateValueToSubFormFields") ? (fieldDic.valueForKey("propgateValueToSubFormFields") as? String)! : "")
                        self.seriveformDataArray.addObject(servicData)
                        self.groupNames.addObject(servicData.groupName)
                    }
                    


                    
                    self.removeTheDublicateValuesInGroup()
                    self.formIntilizer()
                    LoadingView.hide()
                }else{
                    LoadingView.hide()
                }
                
            }

        }
        
        // Do any additional setup after loading the view.
    }
    
    
    func removeTheDublicateValuesInGroup(){
        //self.groupNames.removeObject("")
        let orderSet : NSOrderedSet = NSOrderedSet(array: self.groupNames as [AnyObject])
        self.groupNames.removeAllObjects()
        self.groupNames.addObjectsFromArray(orderSet.array)
        print( self.groupNames)

    }
    
    func isContansKey(responceDic : NSDictionary , key : String) -> Bool{
        let allKeys : NSArray = responceDic.allKeys
        return  allKeys.containsObject(key)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func formIntilizer(){
        
        for sectionName in self.groupNames {
            
            let section = Section(sectionName as! String)
            for service in self.seriveformDataArray {
                let formService : Serices = (service as? Serices)!
                if formService.groupName == sectionName as! String {
                    
                    if formService.type == "Small Text" {
                        let row = TextRow(){ row in
                            row.placeholder = formService.name
                        }
                        section.append(row)
                    }else if formService.type == "Large Text" {
                        
                        let row = TextAreaRow(){ row in
                            
                            
                        }
                        section.append(row)
                    }else if formService.type == "Date Time" {
                        //Date with time
                        
                    }else if formService.type == "Date" {
                        //Only date
                        
                    }else if formService.type == "Selection" {
                        //
                        
                    }else if formService.type == "Large Selection" {
                        //Not applicable

                    }else if formService.type == "Small Heading" {
                        let row = LabelRow(){ row in
                            row.title = formService.name
                        }
                        section.append(row)
                        
                    }else if formService.type == "Large Headingt" {
                        let row = TextAreaRow(){ row in
                            row.title = formService.name
                            row.hidden = true
                        
                        }
                        section.append(row)
                    }else if formService.type == "Radio OR CheckBox" {
                        //Drop Down
                        
                    }else if formService.type == "Attachment" {
                        //Pic 
                        
                    }else if formService.type == "Hidden Text Field" {
                        //Secure text filed like password
                        
                    }else if formService.type == "Auto Date Time" {
                        //Display Present Date with time
                        
                    }else if formService.type == "Auto Date" {
                        //Display present date
                        
                    }else if formService.type == "MultiMedia" {
                        //Not applicable
                    }else if formService.type == "Geo Location" {
                        //Not applicable present

                    }else if formService.type == "Dates_after_today" {
                        //Not applicable present
                    }
                }
                
            }
            
            form.append(section)
            
            // form = Section(sectionName)
            
        }
        
      /*  form = Section("Section1")
            
            <<< TextRow(){ row in
                //row.title = "Text Row"
                row.placeholder = "Enter text here"
            }
            <<< PhoneRow(){
                $0.title = "Phone Row"
                $0.placeholder = "And numbers here"
            }
            +++ Section("Section2")
            <<< DateRow(){
                $0.title = "Date Row"
                $0.value = NSDate(timeIntervalSinceReferenceDate: 0)
        }
    */
    
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


/*
 
 <select class="additionaldetailstextfld" name="additionalDetails[0].type" title="Field Type">
  <option value="Small Text" selected="selected">Small Text</option>
 
 <option value="ReadOnly Small Text">ReadOnly Small Text</option>
 
 <option value="Large Text">Large Text</option>
 
 <option value="Date Time">Date Time</option>
 
 <option value="Date">Date</option>
 
 <option value="Selection">Selection</option>
 
 <option value="Large Selection">Large Selection</option>
 
 <option value="Small Heading">Small Heading</option>
 
 <option value="Large Heading">Large Heading</option>
 
 <option value="Radio OR CheckBox">Radio OR CheckBox</option>
  <option value="Attachment">Attachment</option>
 
  <option value="Hidden Text Field">Hidden Text Field</option>
 option value="Auto Date Time">Auto Date Time</option>
 <option value="Auto Date">Auto Date</option>
 
 <option value="MultiMedia">MultiMedia</option>
 
 <option value="Geo Location">Geo Location</option>
 
 <option value="Dates_after_today">Dates_after_today</option>
 
 
 </select>
 */


