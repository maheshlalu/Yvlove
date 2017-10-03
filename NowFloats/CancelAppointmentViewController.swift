//
//  CancelAppointmentViewController.swift
//  NowFloats
//
//  Created by Rama on 19/09/17.
//  Copyright © 2017 CX. All rights reserved.
//

import UIKit

class CancelAppointmentViewController: UIViewController, PopupContentViewController, UITextFieldDelegate {
  
   var closeHandler:(() -> Void)?
   var cancelIDsDict : NSDictionary!
   var jobArray = NSArray()
    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var resonTxtView: UITextView!
    
    @IBOutlet var cancelAptmBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    CXLog.print("IDS== \(cancelIDsDict)")
        // Do any additional setup after loading the view.
        self.backgroundView.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
        self.cancelAptmBtn.layer.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor().cgColor
    }
    class func instance() -> CancelAppointmentViewController {
        let storyboard = UIStoryboard(name: "InfoQuery", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "CancelAppointmentViewController") as! CancelAppointmentViewController

    }
    func sizeForPopup(_ popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        return CGSize(width: 280, height: 300)
    }
 

    @IBAction func cancelBtnAction(_ sender: Any) {
        self.cancelOrderApi()
       //self.closeHandler?()
    }
    
    func cancelOrderApi() {
        let dict:NSMutableDictionary = NSMutableDictionary()
        let str = self.resonTxtView.text.replacingOccurrences(of: "\"", with: "")
//        let userName = UserDefaults.standard.value(forKey: "FULL_NAME") as! String
        let consumerEmail =  UserDefaults.standard.value(forKey: "USER_EMAIL") as? String
        dict.setObject(str, forKey: "Message" as NSCopying)
//        dict.setObject(userName, forKey: "Name" as NSCopying)
        
        let listArray : NSMutableArray = NSMutableArray()
        
        listArray.add(dict)
        
        let cartJsonDict :NSMutableDictionary = NSMutableDictionary()
        cartJsonDict.setObject(listArray, forKey: "list" as NSCopying)
        
        var jsonData : Data = Data()
        do {
            jsonData = try JSONSerialization.data(withJSONObject: cartJsonDict, options: JSONSerialization.WritingOptions.prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
        } catch let error as NSError {
        }
        let jsonStringFormat = String(data: jsonData, encoding: String.Encoding.utf8)
        
        
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getPlaceOrderUrl(), parameters: ["parentJobId":cancelIDsDict.value(forKey: "parentID") as AnyObject,"type":"Cancel" as AnyObject ,"json":jsonStringFormat! as AnyObject,"dt":"STORES" as AnyObject,"category":"CalenderEvents" as AnyObject,"userId":CXAppConfig.sharedInstance.getAppMallID() as AnyObject,"consumerEmail":consumerEmail as AnyObject]) { (responseDict) in
            CXLog.print(responseDict)
            var msg:String!
            
            let string = responseDict.value(forKeyPath: "myHashMap.status") as! String
            
            if (string.contains("1")){
                CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getCancelOrderUrl(),parameters: ["userId":CXAppConfig.sharedInstance.getAppMallID() as AnyObject,"jobId":self.cancelIDsDict.value(forKey: "parentID") as AnyObject,"op":self.cancelIDsDict.value(forKey: "CancelID") as AnyObject]){(responseDict) in
                    CXLog.print(responseDict)
                    let stringStst = responseDict.value(forKeyPath: "status") as! String
                    
                    if (stringStst.contains("1")){
                        self.closeHandler?()
                    }else{
                        msg = "Error,Sorry please cancel again."
                    }
                    
                }
              
            }else{
                msg = "Error,Sorry please try again."
            }

            
            
            
   // }
}
}
}
