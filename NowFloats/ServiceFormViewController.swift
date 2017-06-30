//
//  ServiceFormViewController.swift
//  NowFloats
//
//  Created by apple on 29/09/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit
import XLForm
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
class ServiceFormViewController: XLFormViewController {
    
    var seriveformDataArray : NSMutableArray = NSMutableArray()
    var groupNames : NSMutableArray = NSMutableArray()
    var serViceCategory : String = String()
    var addmoreBool:Bool = Bool()
    var navController:UINavigationController = UINavigationController()
    func getFormData(){
        
        LoadingView.show(true)
        CXDataService.sharedInstance.getTheAppDataFromServer(["type":"allServicesJobTypes" as AnyObject,"mallId":CXAppConfig.sharedInstance.getAppMallID() as AnyObject/*CXAppConfig.sharedInstance.getAppMallID()*/]) { (responseDict) in
            let jobs : NSArray =  responseDict.value(forKey: "orgs")! as! NSArray
            let service = Serices(name: "Email", addMore: false, type: "Small Text", dependentFields: "", mandatory: "", allowedValues: "", multiselect: "", groupName: "", propgateValueToSubFormFields: "")
            self.seriveformDataArray.add(service)
            
            for srDic in jobs {
                let serviceDic : NSDictionary =  (srDic as? NSDictionary)!
                
                let type:String = (serviceDic.value(forKey: "type") as? String)!
                if type == self.serViceCategory {
                    for fldDic in (serviceDic.value(forKey: "Fields") as? NSArray)! {
                        
                        let fieldDic : NSDictionary =  (fldDic as? NSDictionary)!
                        print("\(self.isContansKey(fieldDic , key: "addMore") as Bool)")
                        
                        
                        let servicData = Serices(name: self.isContansKey(fieldDic , key: "name") ? (fieldDic.value(forKey: "name") as? String)! : "",
                                                 addMore:self.isContansKey(fieldDic , key: "addMore") as Bool ? (fieldDic.value(forKey: "addMore") as! Bool):false,
                                                 type: self.isContansKey(fieldDic , key: "type") ? (fieldDic.value(forKey: "type") as? String)! : "",
                                                 dependentFields: self.isContansKey(fieldDic , key: "dependentFields") ? (fieldDic.value(forKey: "dependentFields") as? String)! : "",
                                                 mandatory: self.isContansKey(fieldDic , key: "mandatory") ? (fieldDic.value(forKey: "mandatory") as? String)! : "",
                                                 allowedValues: self.isContansKey(fieldDic , key: "allowedValues") ? (fieldDic.value(forKey: "allowedValues") as? String)! : "",
                                                 multiselect: self.isContansKey(fieldDic , key: "multiselect") ? (fieldDic.value(forKey: "multiselect") as? String)! : "",
                                                 groupName: self.isContansKey(fieldDic , key: "groupName") ? (fieldDic.value(forKey: "groupName") as? String)! : "",
                                                 propgateValueToSubFormFields: self.isContansKey(fieldDic , key: "propgateValueToSubFormFields") ? (fieldDic.value(forKey: "propgateValueToSubFormFields") as? String)! : "")
                        self.seriveformDataArray.add(servicData)
                        self.groupNames.add(servicData.groupName)
                        
                        
                    }
                    
                    self.removeTheDublicateValuesInGroup()
                    self.formIntilizer()
                    LoadingView.hide()
                    
                }else{
                    LoadingView.hide()
                }
                
            }
            
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.serViceCategory = "Enquiry"
        self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 50, 0)
        view.tintColor = CXAppConfig.sharedInstance.getAppTheamColor()
        self.navController.navigationBar.isHidden = true
        self.getFormData()
    }
    override func viewWillAppear(_ animated: Bool) {
    }
    func removeTheDublicateValuesInGroup(){
        
        //self.groupNames.removeObject("")
        let orderSet : NSOrderedSet = NSOrderedSet(array: self.groupNames as [AnyObject])
        self.groupNames.removeAllObjects()
        self.groupNames.addObjects(from: orderSet.array)
    }
    func isContansKey(_ responceDic : NSDictionary , key : String) -> Bool{
        let allKeys : NSArray = responceDic.allKeys as NSArray
        return  allKeys.contains(key)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func serviceFormDesigning(){
        
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        form = XLFormDescriptor(title: self.serViceCategory)
        
        
        for (index, sectionName) in self.groupNames.enumerated() {
            section = XLFormSectionDescriptor()
            section.title = sectionName as? String
            form.addFormSection(section)
            for service in self.seriveformDataArray {
                let formService : Serices = (service as? Serices)!
                if formService.groupName == sectionName as! String {
                    if formService.type == "Small Text" {
                        row = XLFormRowDescriptor(tag: formService.name, rowType: XLFormRowDescriptorTypeText)
                        row.cellConfigAtConfigure["textField.placeholder"] = formService.name
                        row.cellConfigAtConfigure["textField.textAlignment"] =  NSTextAlignment.left.rawValue
                        row.isRequired = true
                        row.cellConfigAtConfigure["textField.userInteractionEnabled"] =  true
                        section.addFormRow(row)
                    }else if formService.type == "Large Text" {
                        row = XLFormRowDescriptor(tag: formService.name, rowType: XLFormRowDescriptorTypeTextView)
                        row.cellConfigAtConfigure["textView.textAlignment"] =  NSTextAlignment.left.rawValue
                        row.cellConfigAtConfigure["textView.placeholder"] = formService.name
                        //textView.userInteractionEnabled
                        row.cellConfigAtConfigure["textView.userInteractionEnabled"] =  true
                        
                        section.addFormRow(row)
                        
                    }else if formService.type == "Date Time" {
                        //Date with time
                        // DateTime
                        row = XLFormRowDescriptor(tag: formService.name, rowType: XLFormRowDescriptorTypeDateTime, title: formService.name)
                        row.value = Date()
                        row.cellConfigAtConfigure["textView.userInteractionEnabled"] = true
                        section.addFormRow(row)
                        
                    }else if formService.type == "Date" {
                        //Only date
                        row = XLFormRowDescriptor(tag: formService.name, rowType:XLFormRowDescriptorTypeDate, title:formService.name)
                        //row.value = NSDate()
                        row.cellConfigAtConfigure["minimumDate"] = Date()
                        //row.cellConfigAtConfigure["maximumDate"] = NSDate(timeIntervalSinceNow: 60*60*24*3)
                        section.addFormRow(row)
                        
                    }else if formService.type == "Selection" {
                        //
                        row = XLFormRowDescriptor(tag:  formService.name, rowType:XLFormRowDescriptorTypeSelectorPickerView, title:formService.name)
                        let allowedValues : NSArray = (formService.allowedValues.components(separatedBy: "|") as? NSArray)!
                        row.selectorOptions =  allowedValues as [AnyObject]
                        row.value = allowedValues.firstObject
                        section.addFormRow(row)
                        
                        
                    }else if formService.type == "Large Selection" {
                        //Not applicable
                        row = XLFormRowDescriptor(tag:  formService.name, rowType:XLFormRowDescriptorTypeSelectorPickerView, title:formService.name)
                        let allowedValues : NSArray = (formService.allowedValues.components(separatedBy: "|") as? NSArray)!
                        row.selectorOptions =  allowedValues as [AnyObject]
                        row.value = allowedValues.firstObject
                        section.addFormRow(row)
                        
                        
                    }else if formService.type == "Small Heading" {
                        
                        section = XLFormSectionDescriptor()
                        //section.title = "Dependent section"
                        section.footerTitle = formService.name
                        form.addFormSection(section)
                        
                    }else if formService.type == "Large Heading" {
                        
                        section = XLFormSectionDescriptor()
                        //section.title = "Dependent section"
                        section.footerTitle = formService.name
                        form.addFormSection(section)
                        
                        
                    }else if formService.type == "Radio OR CheckBox" {
                        //Drop Down
                        
                    }else if formService.type == "Attachment" {
                        // Image
                        row = XLFormRowDescriptor(tag: formService.name, rowType: XLFormRowDescriptorTypeImage, title: "Image")
                        row.value = UIImage(named: "default_avatar")
                        row.cellConfigAtConfigure["accessoryView.layer.cornerRadius"] = 50
                        section.addFormRow(row)
                    }else if formService.type == "Hidden Text Field" {
                        //Secure text filed like password
                        row = XLFormRowDescriptor(tag: formService.name, rowType: XLFormRowDescriptorTypePassword, title:formService.name)
                        //row.cellConfigAtConfigure["textField.placeholder"] = "Required..."
                        row.cellConfigAtConfigure["textField.textAlignment"] = NSTextAlignment.right.rawValue
                        row.isRequired = true
                        //  row.addValidator(XLFormRegexValidator(msg: "At least 6, max 32 characters", andRegexString: "^(?=.*\\d)(?=.*[A-Za-z]).{6,32}$"))
                        section.addFormRow(row)
                        
                    }else if formService.type == "Auto Date Time" {
                        //Display Present Date with time
                        row = XLFormRowDescriptor(tag: formService.name, rowType: XLFormRowDescriptorTypeDateTime, title: formService.name)
                        row.value = Date()
                        row.disabled = NSNumber(value: true as Bool)
                        section.addFormRow(row)
                        
                    }else if formService.type == "Auto Date" {
                        //Display present date
                        row = XLFormRowDescriptor(tag: formService.name, rowType: XLFormRowDescriptorTypeDate, title: formService.name)
                        row.disabled = NSNumber(value: true as Bool)
                        row.isRequired = true
                        row.value = Date()
                        section.addFormRow(row)
                        
                    }else if formService.type == "MultiMedia" {
                        //Not applicable
                    }else if formService.type == "Geo Location" {
                        //Not applicable present
                        
                        
                    }else if formService.type == "Dates_after_today" {
                        //Not applicable present
                        
                    }else if formService.type == "ReadOnly Small Text" {
                        //Not applicable present
                        //XLFormRowDescriptorTypeTextView
                        row = XLFormRowDescriptor(tag: formService.name, rowType: XLFormRowDescriptorTypeTextView, title: formService.name)
                        row.cellConfigAtConfigure["textField.textAlignment"] =  NSTextAlignment.left.rawValue
                        //textView.userInteractionEnabled
                        row.cellConfigAtConfigure["textView.userInteractionEnabled"] =  true
                        //section.addFormRow(row)
                    }
                }
            }
            if index ==  self.groupNames.count-1{
                row = XLFormRowDescriptor(tag: "Submit", rowType: XLFormRowDescriptorTypeButton, title:"Submit")
                row.cellConfigAtConfigure["backgroundColor"] = CXAppConfig.sharedInstance.getAppTheamColor()
                row.cellConfig["textLabel.color"] = UIColor.white
                // row.cellConfig["textLabel.font"] = UIFont.systemFontOfSize(40)
                section.addFormRow(row)
            }
            // form = Section(sectionName)
        }
        self.form = form
    }
    
    override func didSelectFormRow(_ formRow: XLFormRowDescriptor!) {
        super.didSelectFormRow(formRow)
        if formRow.tag == "Submit" {
            let formDic : NSDictionary = self.httpParameters() as NSDictionary
            
            self.submitServiceForm()
        }
       
        
    }
    
    func submitServiceForm(){
        let parameters : NSMutableDictionary = NSMutableDictionary(dictionary: self.formValues())
        
        print(parameters.allKeys)
        print(parameters.allValues)
        for key in parameters.allKeys {
            let keyvalue = key as? String
            if keyvalue != "Submit"{
                if parameters.value(forKey: key as! String)!  is NSNull {
                    self.showAlertView("Please fill the all fields", status: 0)
                    return
                }
            }
        }
        var isAtachment : Bool = true
        for service in self.seriveformDataArray {
            let formService : Serices = (service as? Serices)!
            if formService.type == "Attachment" {
                LoadingView.show("Uploading", animated: true)
                isAtachment = false
                let image: UIImage = (parameters.value(forKey: formService.name) as? UIImage)!
                let imageData = NSData(data: UIImagePNGRepresentation(image)!) as Data
                CXDataService.sharedInstance.imageUpload(imageData) { (Response) in
                    let status: Int = Int(Response.value(forKey: "status") as! String)!
                    if status == 1{
                        DispatchQueue.main.async(execute: {
                            let imgStr = Response.value(forKey: "filePath") as! String
                            self.subMitTheServiceFormData(self.custructTheDicwithAttachmentKey(formService.name, attachementUrl: imgStr))
                            
                        })
                        
                    }
                }
                
                break
                
            }
            
            
        }
        
        if isAtachment {
            self.subMitTheServiceFormData(parameters)
        }
        
        
        /*  CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getPlaceOrderUrl(), parameters: ["type":self.serViceCategory,"json":"","dt":"CAMPAIGNS","category":"Services","userId":CXAppConfig.sharedInstance.getAppMallID(),"consumerEmail":""]) { (responseDict) in
         
         let string = responseDict.valueForKeyPath("myHashMap.status")
         
         if ((string?.rangeOfString("1")) != nil){
         
         }
         }
         */
        
    }
    
    func custructTheDicwithAttachmentKey(_ attachmentKey:String,attachementUrl:String) -> NSMutableDictionary{
        LoadingView.hide()
        let parameters : NSMutableDictionary = NSMutableDictionary(dictionary: self.formValues())
        parameters.setObject(attachementUrl, forKey: attachmentKey as NSCopying)
        return parameters
    }
    
    
    
    func subMitTheServiceFormData(_ serviceFormDic:NSMutableDictionary){
        
        serviceFormDic.removeObject(forKey: "Submit")
        
        let dict:NSMutableDictionary = NSMutableDictionary()
        dict.setObject(serviceFormDic.value(forKey: "Name")!, forKey: "Name" as NSCopying)
        dict.setObject(serviceFormDic.value(forKey: "Message")!, forKey: "Message" as NSCopying)
        //dict.setObject(serviceFormDic.value(forKey: "Address")!, forKey: "Address" as NSCopying)
        dict.setObject(serviceFormDic.value(forKey: "Phone number")!, forKey: "Phone number" as NSCopying)
        //dict.setObject(mobile, forKey: "Phone Number" as NSCopying)
        
        let listArray : NSMutableArray = NSMutableArray()
        
        listArray.add(dict)
        
        let formDict :NSMutableDictionary = NSMutableDictionary()
        formDict.setObject(listArray, forKey: "list" as NSCopying)
        
        var jsonData : Data = Data()
        do {
            jsonData = try JSONSerialization.data(withJSONObject: formDict, options: JSONSerialization.WritingOptions.prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
        } catch let error as NSError {
        }
        let jsonStringFormat = String(data: jsonData, encoding: String.Encoding.utf8)
        
        
        if UserDefaults.standard.value(forKey: "USER_EMAIL") as? String != nil {
            
            let email = UserDefaults.standard.value(forKey: "USER_EMAIL")
            CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getPlaceOrderUrl(), parameters: ["type":self.serViceCategory as AnyObject,"json":jsonStringFormat! as AnyObject,"dt":"CAMPAIGNS" as AnyObject,"category":"Services" as AnyObject,"userId":CXAppConfig.sharedInstance.getAppMallID() as AnyObject,"consumerEmail": email as AnyObject]) { (responseDict) in
                
                let status: Int = Int(responseDict.value(forKeyPath: "status") as! String)!
                
                if status == 1{
                    self.showAlertView("Success!!!", status: 1)
                    
                }else{
                    self.showAlertView("Something went wrong!! Please Try Again!!", status: 0)
                }
            }
            
        }else{
            
            CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getPlaceOrderUrl(), parameters: ["type":self.serViceCategory as AnyObject,"json":jsonStringFormat! as AnyObject,"dt":"CAMPAIGNS" as AnyObject,"category":"Services" as AnyObject,"userId":CXAppConfig.sharedInstance.getAppMallID() as AnyObject]) { (responseDict) in
                
                let status: Int = Int(responseDict.value(forKeyPath: "myHashMap.status") as! String)!
                
                if status == 1{
                    self.showAlertView("Success!!!", status: 1)
                    
                }else{
                    self.showAlertView("Something went wrong!! Please Try Again!!", status: 0)
                }
            }
        }
    }
    
    
    func serviceFormDesign(){
        
        let image = UIImage()
        let imageData = NSData(data: UIImagePNGRepresentation(image)!) as Data
        CXDataService.sharedInstance.imageUpload(imageData) { (Response) in
            let status: Int = Int(Response.value(forKey: "status") as! String)!
            if status == 1{
                DispatchQueue.main.async(execute: {
                    let imgStr = Response.value(forKey: "filePath") as! String
                    UserDefaults.standard.setValue(imgStr, forKey: "IMAGE_PATH")
                    LoadingView.hide()
                    
                })
            }
        }
    }
    
    func formIntilizer(){
        self.serviceFormDesigning()
        return
    }
    func showAlertView(_ message:String, status:Int) {
        let alert = UIAlertController(title: "Alert!!!", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.default) {
            UIAlertAction in
            if status == 1 {
                self.navController.popViewController(animated: true)
            }else{
            }
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
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


