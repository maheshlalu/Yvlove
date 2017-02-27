//
//  InfoQueryViewController.swift
//  NowFloats
//
//  Created by Manishi on 1/9/17.
//  Copyright © 2017 CX. All rights reserved.
//

import UIKit

class InfoQueryViewController: UIViewController, PopupContentViewController, UITextFieldDelegate {
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var queryTxtView: UITextView!
    @IBOutlet weak var contactTxtField: UITextField!
    @IBOutlet weak var sendMsgBtn: UIButton!
    
    var textViewString:String! = nil
    var emailTxt = String()
    
    var closeHandler:(() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cancelBtn.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
        self.sendMsgBtn.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
        
        self.queryTxtView.layer.cornerRadius = 4
        self.contactTxtField.layer.cornerRadius = 4
        
        self.queryTxtView.layer.borderColor = UIColor.lightGray.cgColor
        self.contactTxtField.layer.borderColor = UIColor.lightGray.cgColor
        
        self.queryTxtView.layer.borderWidth = 1
        self.contactTxtField.layer.borderWidth = 1
        
        queryTxtView.text = textViewString!
        emailTxt = UserDefaults.standard.value(forKey: "USER_EMAIL")! as! String

        contactTxtField.text = emailTxt
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.layer.cornerRadius = 4
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    class func instance() -> InfoQueryViewController {
        
        let stryBrd = UIStoryboard(name: "InfoQuery", bundle: nil)
        return stryBrd.instantiateViewController(withIdentifier: "InfoQueryViewController") as! InfoQueryViewController

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sizeForPopup(_ popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        return CGSize(width: 280, height: 300)
    }
 
    @IBAction func closeBtnAction(_ sender: Any) {
        self.closeHandler?()
    }
    
    @IBAction func sendMessageAction(_ sender: Any) {
        self.sendMessage()
    }
    
    func sendMessage(){
        
        self.view.endEditing(true)
        if (self.queryTxtView.text?.characters.count)! > 0 && (self.contactTxtField.text?.characters.count)! > 0 {
            
            if !self.isValidEmail(self.contactTxtField.text!) {
                
                let alert = UIAlertController(title: "Alert!!!", message: "Please enter valid email address.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
                
            }else{
                
                let dict:NSMutableDictionary = NSMutableDictionary()
                let str = self.queryTxtView.text.replacingOccurrences(of: "\"", with: "")
                let userName = UserDefaults.standard.value(forKey: "FULL_NAME") as! String
                dict.setObject(str, forKey: "Message" as NSCopying)
                dict.setObject(userName, forKey: "Name" as NSCopying)
                print(dict)
                
                let listArray : NSMutableArray = NSMutableArray()
                
                listArray.add(dict)
                
                let cartJsonDict :NSMutableDictionary = NSMutableDictionary()
                cartJsonDict.setObject(listArray, forKey: "list" as NSCopying)
                
                var jsonData : Data = Data()
                do {
                    jsonData = try JSONSerialization.data(withJSONObject: cartJsonDict, options: JSONSerialization.WritingOptions.prettyPrinted)
                    // here "jsonData" is the dictionary encoded in JSON data
                } catch let error as NSError {
                    print(error)
                }
                let jsonStringFormat = String(data: jsonData, encoding: String.Encoding.utf8)
                
                
                CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl() + CXAppConfig.sharedInstance.getPlaceOrderUrl(), parameters: ["type":"Enquiry" as AnyObject ,"json":jsonStringFormat! as AnyObject,"dt":"CAMPAIGNS" as AnyObject,"category":"Services" as AnyObject,"userId":CXAppConfig.sharedInstance.getAppMallID() as AnyObject,"consumerEmail":self.contactTxtField.text as AnyObject]) { (responseDict) in
                    print(responseDict)
                
                    let status: Int = Int(responseDict.value(forKeyPath: "myHashMap.status") as! String)!
                    
                    if status == 1{
                    self.showAlertView("Success!!!", status: 1)
                    
                    }else{
                        self.showAlertView("Something went wrong!! Please Try Again!!", status: 0)
                    }
                }
                
            }
            
        } else {
            let alert = UIAlertController(title: "Alert!!!", message: "All fields are mandatory. Please enter all fields.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        // print("validate email: \(email)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if emailTest.evaluate(with: email) {
            return true
        }
        return false
    }
    
    func showAlertView(_ message:String, status:Int) {
        
        let alert = UIAlertController(title: "Alert!!!", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.default) {
            UIAlertAction in
            if status == 1 {
                self.navigationController?.popViewController(animated: true)
            }else{
            
            }
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}
