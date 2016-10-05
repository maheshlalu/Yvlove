//
//  ServiceFormViewController.swift
//  NowFloats
//
//  Created by apple on 29/09/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit
import Eureka
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
    
    func getFormData(){
        
        LoadingView.show(true)
        CXDataService.sharedInstance.getTheAppDataFromServer(["type":"allServicesJobTypes","mallId":"530"/*CXAppConfig.sharedInstance.getAppMallID()*/]) { (responseDict) in
            let jobs : NSArray =  responseDict.valueForKey("orgs")! as! NSArray
            let service = Serices(name: "Email", addMore: "", type: "Small Text", dependentFields: "", mandatory: "", allowedValues: "", multiselect: "", groupName: "", propgateValueToSubFormFields: "")
            self.seriveformDataArray.addObject(service)
            for serviceDic in jobs {
                let type:String = (serviceDic.valueForKey("type") as? String)!
                if type == self.serViceCategory {
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.serViceCategory = "Book Appointment"
        self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 50, 0)
        view.tintColor = CXAppConfig.sharedInstance.getAppTheamColor()
        self.getFormData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
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
    
    func serviceFormDesigning(){
        
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        form = XLFormDescriptor(title: self.serViceCategory)
        

        for (index, sectionName) in self.groupNames.enumerate() {
            section = XLFormSectionDescriptor()
            section.title = sectionName as? String
            form.addFormSection(section)
            for service in self.seriveformDataArray {
                let formService : Serices = (service as? Serices)!
                if formService.groupName == sectionName as! String {
                    if formService.type == "Small Text" {
                        row = XLFormRowDescriptor(tag: formService.name, rowType: XLFormRowDescriptorTypeText)
                        row.cellConfigAtConfigure["textField.placeholder"] = formService.name
                        row.cellConfigAtConfigure["textField.textAlignment"] =  NSTextAlignment.Left.rawValue
                        row.required = true
                        section.addFormRow(row)
                    }else if formService.type == "Large Text" {
                        row = XLFormRowDescriptor(tag: formService.name, rowType: XLFormRowDescriptorTypeTextView)
                        row.cellConfigAtConfigure["textView.textAlignment"] =  NSTextAlignment.Left.rawValue
                        row.cellConfigAtConfigure["textView.placeholder"] = formService.name
                        //textView.userInteractionEnabled
                        //row.cellConfigAtConfigure["textView.userInteractionEnabled"] =  true
                        section.addFormRow(row)
                      
                    }else if formService.type == "Date Time" {
                        //Date with time
                        // DateTime
                        row = XLFormRowDescriptor(tag: formService.name, rowType: XLFormRowDescriptorTypeDateTime, title: formService.name)
                        row.value = NSDate()
                        section.addFormRow(row)
                        
                    }else if formService.type == "Date" {
                        //Only date
                        row = XLFormRowDescriptor(tag: formService.name, rowType:XLFormRowDescriptorTypeDate, title:formService.name)
                        //row.value = NSDate()
                        row.cellConfigAtConfigure["minimumDate"] = NSDate()
                        //row.cellConfigAtConfigure["maximumDate"] = NSDate(timeIntervalSinceNow: 60*60*24*3)
                        section.addFormRow(row)
                        
                    }else if formService.type == "Selection" {
                        //
                        row = XLFormRowDescriptor(tag:  formService.name, rowType:XLFormRowDescriptorTypeSelectorPickerView, title:formService.name)
                        let allowedValues : NSArray = (formService.allowedValues.componentsSeparatedByString("|") as? NSArray)!
                        row.selectorOptions =  allowedValues as [AnyObject]
                        row.value = allowedValues.firstObject
                        section.addFormRow(row)
                       
                        
                    }else if formService.type == "Large Selection" {
                        //Not applicable
                        row = XLFormRowDescriptor(tag:  formService.name, rowType:XLFormRowDescriptorTypeSelectorPickerView, title:formService.name)
                        let allowedValues : NSArray = (formService.allowedValues.componentsSeparatedByString("|") as? NSArray)!
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
                        row.cellConfigAtConfigure["textField.textAlignment"] = NSTextAlignment.Right.rawValue
                        row.required = true
                      //  row.addValidator(XLFormRegexValidator(msg: "At least 6, max 32 characters", andRegexString: "^(?=.*\\d)(?=.*[A-Za-z]).{6,32}$"))
                        section.addFormRow(row)
                        
                    }else if formService.type == "Auto Date Time" {
                        //Display Present Date with time
                        row = XLFormRowDescriptor(tag: formService.name, rowType: XLFormRowDescriptorTypeDateTime, title: formService.name)
                        row.value = NSDate()
                        row.disabled = NSNumber(bool: true)
                        section.addFormRow(row)
                        
                    }else if formService.type == "Auto Date" {
                        //Display present date
                        row = XLFormRowDescriptor(tag: formService.name, rowType: XLFormRowDescriptorTypeDate, title: formService.name)
                        row.disabled = NSNumber(bool: true)
                        row.required = true
                        row.value = NSDate()
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
                        row.cellConfigAtConfigure["textField.textAlignment"] =  NSTextAlignment.Left.rawValue
                        //textView.userInteractionEnabled
                        row.cellConfigAtConfigure["textView.userInteractionEnabled"] =  true
                        //section.addFormRow(row)
                    }
                }
                
                
            }
            if index ==  self.groupNames.count-1{
                row = XLFormRowDescriptor(tag: "Submit", rowType: XLFormRowDescriptorTypeButton, title:"Submit")
                row.cellConfigAtConfigure["backgroundColor"] = CXAppConfig.sharedInstance.getAppTheamColor()
                row.cellConfig["textLabel.color"] = UIColor.whiteColor()
                // row.cellConfig["textLabel.font"] = UIFont.systemFontOfSize(40)
                section.addFormRow(row)
            }

           
            // form = Section(sectionName)
            
        }


        
         self.form = form
        
    }
    
    override func didSelectFormRow(formRow: XLFormRowDescriptor!) {
        super.didSelectFormRow(formRow)
        if formRow.tag == "Submit" {
            let formDic : NSDictionary = self.httpParameters()
            print("Form Details \(formDic)")
            
            
            self.submitServiceForm()
        }
        
    }
    
    func submitServiceForm(){
        let parameters : NSMutableDictionary = NSMutableDictionary(dictionary: self.formValues())
        
        var isAtachment : Bool = true
        for service in self.seriveformDataArray {
            let formService : Serices = (service as? Serices)!
            if formService.type == "Attachment" {
                LoadingView.show("Uploading", animated: true)
                isAtachment = false
                let image: UIImage = (parameters.valueForKey(formService.name) as? UIImage)!
                let imageData = NSData(data: UIImagePNGRepresentation(image)!)
                CXDataService.sharedInstance.imageUpload(imageData) { (Response) in
                    print("\(Response)")
                    let status: Int = Int(Response.valueForKey("status") as! String)!
                    if status == 1{
                        dispatch_async(dispatch_get_main_queue(), {
                            let imgStr = Response.valueForKey("filePath") as! String
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
    
    func custructTheDicwithAttachmentKey(attachmentKey:String,attachementUrl:String) -> NSMutableDictionary{
        LoadingView.hide()
        let parameters : NSMutableDictionary = NSMutableDictionary(dictionary: self.formValues())
        parameters.setObject(attachementUrl, forKey: attachmentKey)
        return parameters
    }
    
 
    
    func subMitTheServiceFormData(serviceFormDic:NSMutableDictionary){
        
        print(serviceFormDic)
        var jsonData : NSData = NSData()
        do {
            jsonData = try NSJSONSerialization.dataWithJSONObject(serviceFormDic, options: NSJSONWritingOptions.PrettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
        } catch let error as NSError {
            print(error)
        }
        let jsonStringFormat = String(data: jsonData, encoding: NSUTF8StringEncoding)

        
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getPlaceOrderUrl(), parameters: ["type":self.serViceCategory,"json":jsonStringFormat!,"dt":"CAMPAIGNS","category":"Services","userId":"530"/*CXAppConfig.sharedInstance.getAppMallID()*/,"consumerEmail":"yernagulamahesh@gmail.com"]) { (responseDict) in
            
            let string = responseDict.valueForKeyPath("myHashMap.status")
            
            if ((string?.rangeOfString("1")) != nil){
                
            }
        }
        
    }
    
    
    
    
    func serviceFormDesign(){
        
        let image = UIImage()
        let imageData = NSData(data: UIImagePNGRepresentation(image)!)
        CXDataService.sharedInstance.imageUpload(imageData) { (Response) in
            print("\(Response)")
            let status: Int = Int(Response.valueForKey("status") as! String)!
            if status == 1{
                dispatch_async(dispatch_get_main_queue(), {
                    let imgStr = Response.valueForKey("filePath") as! String
                    NSUserDefaults.standardUserDefaults().setValue(imgStr, forKey: "IMAGE_PATH")
                    LoadingView.hide()
                    
                })
                
            }
        }
        
    }
    

    
    
    func formIntilizer(){
        self.serviceFormDesigning()
        return
   /*     for sectionName in self.groupNames {
            
            let section = Section(sectionName as! String)
            for service in self.seriveformDataArray {
                let formService : Serices = (service as? Serices)!
                if formService.groupName == sectionName as! String {
                    
                    if formService.type == "Small Text" {
                        let row = TextRow(){ row in
                            row.placeholder = formService.name
                            row.tag = formService.name
                            }.onChange({ (textData:TextRow!) in
                                print(textData)
                                
                                print(self.form.values())
                         })
                        section.append(row)
                    }else if formService.type == "Large Text" {
                        
                        let row = TextAreaRow(){ row in
                            row.tag = formService.name
                        }
                        section.append(row)
                    }else if formService.type == "Date Time" {
                        //Date with time
                        
                        let dateRow = DateTimeRow(){ dateRow in
                            dateRow.tag = formService.name
                            dateRow.title = formService.name
                            dateRow.value = NSDate()
                            let formatter = NSDateFormatter()
                            dateRow.dateFormatter = formatter
                        }
                        
                        section.append(dateRow)
                    }else if formService.type == "Date" {
                        //Only date
                        let dateRow = DateRow(){ dateRow in
                            dateRow.tag = formService.name
                            dateRow.title = formService.name
                            dateRow.value  = NSDate(timeIntervalSinceReferenceDate: 0)
                            let formatter = NSDateFormatter()
                            dateRow.dateFormatter = formatter
                        }.cellUpdate({ (cell, row) in
                            print("print date row \(row)")
                        })
                        
                        section.append(dateRow)
                        
                    }else if formService.type == "Selection" {
                        //
                      let row =  ActionSheetRow<String>() {
                            $0.title = "ActionSheetRow"
                            $0.selectorTitle = "Pick a number"
                            $0.options = ["One","Two","Three"]
                            $0.value = "Two"    // initially selected
                            $0.tag = formService.name
                        }
                        section.append(row)

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
                        let row =  ActionSheetRow<String>() {
                            $0.title = "Select"
                            $0.selectorTitle = "Select Gender"
                            $0.options = ["Male","Female"]
                            $0.value = "Male"    // initially selected
                        }
                        section.append(row)
                        
                    }else if formService.type == "Attachment" {
                        //Pic 
                        let imagerow = ImageRow() { imagerow in
                            imagerow.title = formService.name
                            imagerow.tag = formService.name
                            }.cellSetup({ (cell, row) -> () in
                                cell.accessoryView?.layer.cornerRadius = 50
                                row.cell.height = {
                                    return 100
                                }
                            }).cellUpdate({ (cell, row) in
                                
                            })
                        section.append(imagerow)
                        
                    }else if formService.type == "Hidden Text Field" {
                        //Secure text filed like password
                        
                        let row = TextAreaRow(){ row in
                            row.tag = formService.name
                            row.placeholder = formService.name
                        }
                        section.append(row)

                        
                    }else if formService.type == "Auto Date Time" {
                        //Display Present Date with time
                        let row = TextAreaRow(){ row in
                            row.tag = formService.name
                             row.placeholder = formService.name
                        }
                        section.append(row)
                        
                    }else if formService.type == "Auto Date" {
                        //Display present date
                        let row = TextAreaRow(){ row in
                            row.tag = formService.name
                             row.placeholder = formService.name
                        }
                        section.append(row)

                    }else if formService.type == "MultiMedia" {
                        //Not applicable
                    }else if formService.type == "Geo Location" {
                        //Not applicable present
                        let row = TextAreaRow(){ row in
                            row.tag = formService.name
                             row.placeholder = formService.name
                        }
                        section.append(row)

                    }else if formService.type == "Dates_after_today" {
                        //Not applicable present
                        let row = TextAreaRow(){ row in
                            row.tag = formService.name
                            row.placeholder = formService.name
                        }
                        section.append(row)

                    }
                }
                
            }
            
            let submitRow = ButtonRow(){ submitRow in
                submitRow.title = "Form Submit"
                }.onCellSelection({ (cell, row) in
                    self.getFormData()
                    print(self.form.values())
                })
            section.append(submitRow)
            
                
            form.append(section)
            
            // form = Section(sectionName)
            
        }
        
        
*/
        
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


