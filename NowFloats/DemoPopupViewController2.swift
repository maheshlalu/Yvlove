//
//  DemoPopupViewController2.swift
//  PopupController
//
//  Created by 佐藤 大輔 on 2/4/16.
//  Copyright © 2016 Daisuke Sato. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


class DemoPopupViewController2: CXViewController, PopupContentViewController, UITextFieldDelegate{
    var closeHandler: (() -> Void)?
    var sendDetails: (() -> Void)?
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var addressLine2TxtField: UITextField!
    @IBOutlet weak var addressLine1TxtField: UITextField!
    @IBOutlet weak var mobileNoTxtField: UITextField!
    let dataDict:NSMutableDictionary = NSMutableDictionary()
    @IBOutlet weak var okBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.topView.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
        self.mobileNoTxtField.tag = 3
        mobileNoTxtField.delegate = self
        dataForTextFields()
    }
    
    func dataForTextFields(){
        self.nameTxtField.text = UserDefaults.standard.value(forKey: "FULL_NAME") as? String
        self.emailTxtField.text = UserDefaults.standard.value(forKey: "USER_EMAIL") as? String
        self.mobileNoTxtField.text = UserDefaults.standard.value(forKey: "MOBILE") as? String
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.layer.cornerRadius = 4
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
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
    
    func sizeForPopup(_ popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        return CGSize(width: 280, height: 300)
    }
    @IBAction func okButtonAction(_ sender: AnyObject) {
        signUpBtnAction()
    }
    @IBAction func cancelBtnAction(_ sender: Any) {
        self.closeHandler?()
    }
    
    func signUpBtnAction() {
        self.view.endEditing(true)
        if self.nameTxtField.text?.characters.count > 0
            && self.emailTxtField.text?.characters.count > 0
            && self.addressLine2TxtField.text?.characters.count > 0
            && self.addressLine1TxtField.text?.characters.count > 0 &&
            self.mobileNoTxtField.text?.characters.count > 0 {
            if !self.isValidEmail(self.emailTxtField.text!) {
                let alert = UIAlertController(title: "Alert!!!", message: "Please enter valid email address.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            if self.mobileNoTxtField.text?.characters.count < 10 {
                let alert = UIAlertController(title: "Alert!!!", message: "Please enter valid Phone number.", preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    //self.navigationController?.popViewControllerAnimated(true)
                    
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                
                
                return
            }else{
            UserDefaults.standard.set(self.mobileNoTxtField.text!, forKey: "MOBILE")
            }
            
            dataDict.setObject(self.nameTxtField.text!, forKey: "name" as NSCopying)
            dataDict.setObject(self.emailTxtField.text!, forKey: "email" as NSCopying)
            dataDict.setObject(self.addressLine1TxtField.text!, forKey: "addressLine1" as NSCopying)
            dataDict.setObject(self.addressLine2TxtField.text!, forKey: "addressLine2" as NSCopying)
            dataDict.setObject(self.mobileNoTxtField.text!, forKey: "mobile" as NSCopying)
            
            sendDetails?()
            
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 3 {
            if  range.length==1 && string.characters.count == 0 {
                return true
            }
            if textField.text?.characters.count >= 10 {
                return false
            }
            let invalidCharacters = CharacterSet(charactersIn: "0123456789").inverted
            //return string.rangeOfCharacter(from: invalidCharacters, options: [], range: string.characters.indices) == nil
        }
        return true
    }

}


