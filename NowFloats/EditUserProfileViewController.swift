//
//  EditUserProfileViewController.swift
//  NowFloats
//
//  Created by Manishi on 9/14/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit

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
        self.saveImageBtn.hidden = true
        let imgTap:UIGestureRecognizer = UITapGestureRecognizer.init()
        imgTap.addTarget(self, action: #selector(editBtnAction(_:)))
        editDPImage.addGestureRecognizer(imgTap)

    }
    
    func dataIntegration(){
        staticEmail.text = emai
        staticMobileNumber.text = mobile
        
        firstNameTxtField.text = firstName
        lastNameTxtField.text = lastName
        addressTxtField.text = NSUserDefaults.standardUserDefaults().valueForKey("ADDRESS") as? String
        cityTxtField.text = NSUserDefaults.standardUserDefaults().valueForKey("CITY") as? String
        stateTxtField.hidden = true
        
        
    
    }
    @IBAction func editBtnAction(sender: AnyObject) {
        chooseArticleDropDown.show()
    }
    
    @IBAction func saveChangesAction(sender: AnyObject) {
        self.view.endEditing(true)
            
            self.editProfileDetails()
            
}


    func editProfileDetails(){
        let alert = UIAlertController(title:"Save Changes?", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { (UIAlertAction) in
            LoadingView.show("Uploading!!", animated: true)
            let imgStr = NSUserDefaults.standardUserDefaults().valueForKey("IMAGE_PATH") as! String
                CXAppDataManager.sharedInstance.profileUpdate(self.staticEmail.text!, address:self.addressTxtField.text!, firstName: self.firstNameTxtField.text!, lastName: self.lastNameTxtField.text!, mobileNumber: self.staticMobileNumber.text!, city: self.cityTxtField.text!, state:"",country:"",image:imgStr ) { (responseDict) in
                    print(responseDict)
                    let status: Int = Int(responseDict.valueForKey("status") as! String)!
                    if status == 1{
                        dispatch_async(dispatch_get_main_queue(), {
                            
                           // NSUserDefaults.standardUserDefaults().setObject(responseDict.valueForKey("state"), forKey: "STATE")
                            NSUserDefaults.standardUserDefaults().setObject(responseDict.valueForKey("emailId"), forKey: "USER_EMAIL")
                            NSUserDefaults.standardUserDefaults().setObject(responseDict.valueForKey("firstName"), forKey: "FIRST_NAME")
                            NSUserDefaults.standardUserDefaults().setObject(responseDict.valueForKey("lastName"), forKey: "LAST_NAME")
                            NSUserDefaults.standardUserDefaults().setObject(responseDict.valueForKey("UserId"), forKey: "USER_ID")
                            NSUserDefaults.standardUserDefaults().setObject(responseDict.valueForKey("macId"), forKey: "MAC_ID")
                            NSUserDefaults.standardUserDefaults().setObject(responseDict.valueForKey("mobile"), forKey: "MOBILE")
                            NSUserDefaults.standardUserDefaults().setObject(responseDict.valueForKey("address"), forKey: "ADDRESS")
                            NSUserDefaults.standardUserDefaults().setObject(responseDict.valueForKey("fullName"), forKey: "FULL_NAME")
                            NSUserDefaults.standardUserDefaults().setObject(responseDict.valueForKey("city"), forKey: "CITY")
                            NSUserDefaults.standardUserDefaults().setObject(responseDict.valueForKey("orgId"), forKey: "ORG_ID")
                            NSUserDefaults.standardUserDefaults().setObject(responseDict.valueForKey("macIdJobId"), forKey: "MACID_JOBID")
                            NSUserDefaults.standardUserDefaults().setObject(responseDict.valueForKey("organisation"), forKey: "ORGANIZATION")
                            LoadingView.hide()
                            self.showAlertView("Profile Updated Successfully!!!", status: 1)
                        })
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Destructive) {
            (UIAlertAction) in
                
            }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.presentViewController(alert, animated: true, completion: nil)
        
        }
    
    @IBAction func saveImageAction(sender: AnyObject) {
        LoadingView.show("Uploading!!", animated: true)
        let image = self.editDPImage.image! as UIImage
        let imageData = NSData(data: UIImagePNGRepresentation(image)!)
        CXDataService.sharedInstance.imageUpload(imageData) { (Response) in
            print("\(Response)")
            
            let status: Int = Int(Response.valueForKey("status") as! String)!
            if status == 1{
                 dispatch_async(dispatch_get_main_queue(), {
                let imgStr = Response.valueForKey("filePath") as! String
                NSUserDefaults.standardUserDefaults().setValue(imgStr, forKey: "IMAGE_PATH")
                self.saveImageBtn.hidden = true
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
                image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                image.allowsEditing = false
                self.presentViewController(image, animated: true, completion: nil)
                
            }else if index == 1{
                print("choose from fb")
    
            }else if index == 2{
                self.editDPImage.image = UIImage(named:"placeholder")
                self.editDPImage.alpha = 0.4
                self.saveImageBtn.hidden = false
            }
        }
    
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.saveImageBtn.hidden = false
            editDPImage.contentMode = .ScaleToFill
            editDPImage.image = pickedImage
            editDPImage.alpha = 1
            editDPImage.backgroundColor = UIColor.clearColor()
            
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
       
    }
    
    func headerViewAlignments(){
        saveChangesBtn.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
        stateTxtField.selectedLineColor = CXAppConfig.sharedInstance.getAppTheamColor()
        cityTxtField.selectedLineColor = CXAppConfig.sharedInstance.getAppTheamColor()
        addressTxtField.selectedLineColor = CXAppConfig.sharedInstance.getAppTheamColor()
        firstNameTxtField.selectedLineColor = CXAppConfig.sharedInstance.getAppTheamColor()
        lastNameTxtField.selectedLineColor = CXAppConfig.sharedInstance.getAppTheamColor()
        self.editProfileView.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
        
        self.editDPImage.layer.cornerRadius = self.editDPImage.frame.size.width / 4
        self.editDPImage.clipsToBounds = true
        self.editDPImage.layer.borderWidth = 3.0
        self.editDPImage.layer.borderColor = UIColor.whiteColor().CGColor
        
        let imageUrl = NSUserDefaults.standardUserDefaults().valueForKey("IMAGE_PATH") as? String
        if (imageUrl != ""){
            editDPImage.sd_setImageWithURL(NSURL(string: (NSUserDefaults.standardUserDefaults().valueForKey("IMAGE_PATH") as?String)!))
            editDPImage.alpha = 1
            editDPImage.backgroundColor = UIColor.clearColor()
        }else{
            editDPImage.image = UIImage(named: "placeholder")
            editDPImage.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
            editDPImage.alpha = 0.5
        }
        
       
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
    
    func isValidEmail(email: String) -> Bool {
        // print("validate email: \(email)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if emailTest.evaluateWithObject(email) {
            return true
        }
        return false
    }
    // AlertView
    func showAlertView(message:String, status:Int) {
        dispatch_async(dispatch_get_main_queue(), {
            let alert = UIAlertController(title: "Alert!!!", message: message, preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                if status == 1 {
                    self.navigationController?.popToRootViewControllerAnimated(true)
                }
            }
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true, completion: nil)
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
