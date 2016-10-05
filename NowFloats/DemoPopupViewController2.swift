//
//  DemoPopupViewController2.swift
//  PopupController
//
//  Created by 佐藤 大輔 on 2/4/16.
//  Copyright © 2016 Daisuke Sato. All rights reserved.
//

import UIKit

class DemoPopupViewController2: UIViewController, PopupContentViewController, UITextFieldDelegate{
    var closeHandler: (() -> Void)?
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var addressLine2TxtField: UITextField!
    @IBOutlet weak var addressLine1TxtField: UITextField!
    @IBOutlet weak var mobileNoTxtField: UITextField!
    
    @IBOutlet weak var okBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.topView.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
        self.mobileNoTxtField.tag = 3
        mobileNoTxtField.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.view.layer.cornerRadius = 4
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }

    
    class func instance() -> DemoPopupViewController2 {
        let storyboard = UIStoryboard(name: "DemoPopupViewController2", bundle: nil)
        return storyboard.instantiateInitialViewController() as! DemoPopupViewController2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sizeForPopup(popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        return CGSizeMake(280, 300)
    }
    @IBAction func okButtonAction(sender: AnyObject) {
        signUpBtnAction()
    }
    
    func signUpBtnAction() {
        self.view.endEditing(true)
        if self.nameTxtField.text?.characters.count > 0
            && self.emailTxtField.text?.characters.count > 0
            && self.addressLine2TxtField.text?.characters.count > 0
            && self.addressLine1TxtField.text?.characters.count > 0 &&
            self.mobileNoTxtField.text?.characters.count > 0 {
            if !self.isValidEmail(self.emailTxtField.text!) {
                let alert = UIAlertController(title: "Alert!!!", message: "Please enter valid email address.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                return
            }
            
            if self.mobileNoTxtField.text?.characters.count < 10 {
                let alert = UIAlertController(title: "Alert!!!", message: "Please enter valid Phone number.", preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default) {
                    UIAlertAction in
                    //self.navigationController?.popViewControllerAnimated(true)
                    
                }
                alert.addAction(okAction)
                self.presentViewController(alert, animated: true, completion: nil)
                
                
                return
            }
            closeHandler?()
            
        } else {
            let alert = UIAlertController(title: "Alert!!!", message: "All fields are mandatory. Please enter all fields.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func isValidEmail(email: String) -> Bool {
        // print("validate email: \(email)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if emailTest.evaluateWithObject(email) {
            return true
        }
        return false
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 3 {
            if  range.length==1 && string.characters.count == 0 {
                return true
            }
            if textField.text?.characters.count >= 10 {
                return false
            }
            let invalidCharacters = NSCharacterSet(charactersInString: "0123456789").invertedSet
            return string.rangeOfCharacterFromSet(invalidCharacters, options: [], range: string.startIndex ..< string.endIndex) == nil
        }
        return true
    }

}


