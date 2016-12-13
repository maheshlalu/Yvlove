//
//  EditUserProfileViewController.swift
//  NowFloats
//
//  Created by Manishi on 9/14/16.
//  Copyright © 2016 CX. All rights reserved.
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
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


class EditUserProfileViewController: CXViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate{
    
    var firstName:String!
    var lastName:String!
    var emai:String!
    var mobile:String!
    var dpImg:String!
    
    let chooseArticleDropDown = DropDown()
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var staticEmail: SkyFloatingLabelTextField!
    @IBOutlet weak var staticMobileNumber: SkyFloatingLabelTextField!
    @IBOutlet weak var saveChangesBtn: UIButton!
    @IBOutlet weak var editProfileView: UIView!
    @IBOutlet weak var editDPImage: UIImageView!
    @IBOutlet weak var stateTxtField: SkyFloatingLabelTextField!
    @IBOutlet weak var cityTxtField: SkyFloatingLabelTextField!
    @IBOutlet weak var addressTxtField: SkyFloatingLabelTextField!
    @IBOutlet weak var firstNameTxtField: SkyFloatingLabelTextField!
    @IBOutlet weak var lastNameTxtField: SkyFloatingLabelTextField!
    @IBOutlet weak var saveImageBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerViewAlignments()
        dataIntegration()
        editDropDown()
        self.saveImageBtn.isHidden = true
        let imgTap:UIGestureRecognizer = UITapGestureRecognizer.init()
        imgTap.addTarget(self, action: #selector(editBtnAction(_:)))
        editDPImage.addGestureRecognizer(imgTap)

    }
    
    func dataIntegration(){
        staticEmail.text = emai
        staticMobileNumber.text = mobile
        
        firstNameTxtField.text = firstName
        lastNameTxtField.text = lastName
        addressTxtField.text = UserDefaults.standard.value(forKey: "ADDRESS") as? String
        cityTxtField.text = UserDefaults.standard.value(forKey: "CITY") as? String
        stateTxtField.isHidden = true
        
        
    
    }
    @IBAction func editBtnAction(_ sender: AnyObject) {
        chooseArticleDropDown.show()
    }
    
    @IBAction func saveChangesAction(_ sender: AnyObject) {
        self.view.endEditing(true)
            
            self.editProfileDetails()
            
}


    func editProfileDetails(){
        let alert = UIAlertController(title:"Save Changes?", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) { (UIAlertAction) in
            LoadingView.show("Uploading!!", animated: true)
            let imgStr = UserDefaults.standard.value(forKey: "IMAGE_PATH") as! String
                CXAppDataManager.sharedInstance.profileUpdate(self.staticEmail.text!, address:self.addressTxtField.text!, firstName: self.firstNameTxtField.text!, lastName: self.lastNameTxtField.text!, mobileNumber: self.staticMobileNumber.text!, city: self.cityTxtField.text!, state:"",country:"",image:imgStr ) { (responseDict) in
                    print(responseDict)
                    let status: Int = Int(responseDict.value(forKey: "status") as! String)!
                    if status == 1{
                        DispatchQueue.main.async(execute: {
                            
                           // NSUserDefaults.standardUserDefaults().setObject(responseDict.valueForKey("state"), forKey: "STATE")
                            UserDefaults.standard.set(responseDict.value(forKey: "emailId"), forKey: "USER_EMAIL")
                            UserDefaults.standard.set(responseDict.value(forKey: "firstName"), forKey: "FIRST_NAME")
                            UserDefaults.standard.set(responseDict.value(forKey: "lastName"), forKey: "LAST_NAME")
                            UserDefaults.standard.set(responseDict.value(forKey: "UserId"), forKey: "USER_ID")
                            UserDefaults.standard.set(responseDict.value(forKey: "macId"), forKey: "MAC_ID")
                            UserDefaults.standard.set(responseDict.value(forKey: "mobile"), forKey: "MOBILE")
                            UserDefaults.standard.set(responseDict.value(forKey: "address"), forKey: "ADDRESS")
                            UserDefaults.standard.set(responseDict.value(forKey: "fullName"), forKey: "FULL_NAME")
                            UserDefaults.standard.set(responseDict.value(forKey: "city"), forKey: "CITY")
                            UserDefaults.standard.set(responseDict.value(forKey: "orgId"), forKey: "ORG_ID")
                            UserDefaults.standard.set(responseDict.value(forKey: "macIdJobId"), forKey: "MACID_JOBID")
                            UserDefaults.standard.set(responseDict.value(forKey: "organisation"), forKey: "ORGANIZATION")
                            UserDefaults.standard.synchronize()
                            LoadingView.hide()
                            self.showAlertView("Profile Updated Successfully!!!", status: 1)
                        })
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive) {
            (UIAlertAction) in
                
            }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
        }
    
    @IBAction func saveImageAction(_ sender: AnyObject) {
        LoadingView.show("Uploading!!", animated: true)
        let image = self.editDPImage.image! as UIImage
        let imageData = NSData(data: UIImagePNGRepresentation(image)!) as Data
        CXDataService.sharedInstance.imageUpload(imageData) { (Response) in
            print("\(Response)")
            
            let status: Int = Int(Response.value(forKey: "status") as! String)!
            if status == 1{
                 DispatchQueue.main.async(execute: {
                let imgStr = Response.value(forKey: "filePath") as! String
                UserDefaults.standard.setValue(imgStr, forKey: "IMAGE_PATH")
                self.saveImageBtn.isHidden = true
                LoadingView.hide()
                self.showAlertView("Photo Uploaded Successfully!!!", status: 1)

                })
               
            }
        }
        
    }
    func editDropDown(){
        
        chooseArticleDropDown.anchorView = editDPImage
        chooseArticleDropDown.anchorView = editBtn
        chooseArticleDropDown.bottomOffset = CGPoint(x:-10, y:self.editBtn.bounds.size.height+2)
        chooseArticleDropDown.dataSource = [
            "Choose from Photos", "Get from Facebook", "Remove profile pic"
        ]
        chooseArticleDropDown.selectionAction = {(index, item) in
            if index == 0{
                print("choose from photos")
                let image = UIImagePickerController()
                image.delegate = self
                image.sourceType = UIImagePickerControllerSourceType.photoLibrary
                image.allowsEditing = false
                self.present(image, animated: true, completion: nil)
                
            }else if index == 1{
                print("choose from fb")
    
            }else if index == 2{
                self.editDPImage.image = UIImage(named:"placeholder")
                self.editDPImage.alpha = 0.4
                self.saveImageBtn.isHidden = false
            }
        }
    
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.saveImageBtn.isHidden = false
            editDPImage.contentMode = .scaleToFill
            editDPImage.image = pickedImage
            editDPImage.alpha = 1
            editDPImage.backgroundColor = UIColor.clear
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
       
    }
    
    func headerViewAlignments(){
        saveChangesBtn.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
        stateTxtField.selectedLineColor = CXAppConfig.sharedInstance.getAppTheamColor()
        cityTxtField.selectedLineColor = CXAppConfig.sharedInstance.getAppTheamColor()
        addressTxtField.selectedLineColor = CXAppConfig.sharedInstance.getAppTheamColor()
        firstNameTxtField.selectedLineColor = CXAppConfig.sharedInstance.getAppTheamColor()
        lastNameTxtField.selectedLineColor = CXAppConfig.sharedInstance.getAppTheamColor()
        self.editProfileView.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
        
        self.editDPImage.layer.cornerRadius = 50
        self.editDPImage.clipsToBounds = true
        self.editDPImage.layer.borderWidth = 3.0
        self.editDPImage.layer.borderColor = UIColor.white.cgColor
        
        let imageUrl = UserDefaults.standard.value(forKey: "IMAGE_PATH") as? String
        if (imageUrl != ""){
            editDPImage.sd_setImage(with: URL(string: (UserDefaults.standard.value(forKey: "IMAGE_PATH") as?String)!))
            editDPImage.alpha = 1
            editDPImage.backgroundColor = UIColor.clear
        }else{
            editDPImage.image = UIImage(named: "placeholder")
            editDPImage.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
            editDPImage.alpha = 0.5
        }
        
       
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
    
    func isValidEmail(_ email: String) -> Bool {
        // print("validate email: \(email)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if emailTest.evaluate(with: email) {
            return true
        }
        return false
    }
    // AlertView
    func showAlertView(_ message:String, status:Int) {
        DispatchQueue.main.async(execute: {
            let alert = UIAlertController(title: "Alert!!!", message: message, preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.default) {
                UIAlertAction in
                if status == 1 {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override  func shouldShowRightMenu() -> Bool{
        
        return true
    }
    
    override func shouldShowNotificatoinBell() ->Bool{
        
        return false
    }
    
    override  func shouldShowCart() -> Bool{
        
        return false
    }
    
    override func shouldShowLeftMenu() -> Bool{
        
        return false
    }
    override func showLogoForAboutUs() -> Bool{
        return false
    }
    override func shouldShowLeftMenuWithLogo() -> Bool{
        
        return true
    }
    
    override func headerTitleText() -> String{
        return "Edit Profile"
    }
    
    override func profileDropdown() -> Bool{
        return true
    }
    
    override func profileDropdownForSignIn() -> Bool{
        return false
        
    }
}
