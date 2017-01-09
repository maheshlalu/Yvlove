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
    
    var textViewString:String!
    
    var closeHandler: (() -> Void)?
    
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
            
            //            if !self.isValidEmail(self.emailTxtField.text!) {
            //                let alert = UIAlertController(title: "Alert!!!", message: "Please enter valid email address.", preferredStyle: UIAlertControllerStyle.alert)
            //                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            //                self.present(alert, animated: true, completion: nil)
            //                return
            //            }
            //
            //            if self.mobileNoTxtField.text?.characters.count < 10 {
            //                let alert = UIAlertController(title: "Alert!!!", message: "Please enter valid Phone number.", preferredStyle: UIAlertControllerStyle.alert)
            //                let okAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.default) {
            //                    UIAlertAction in
            //                    //self.navigationController?.popViewControllerAnimated(true)
            //
            //                }
            //                alert.addAction(okAction)
            //                self.present(alert, animated: true, completion: nil)
            //                return
            //            }
            closeHandler?()
            
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
    
}
