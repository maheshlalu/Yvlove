//
//  EditUserProfileViewController.swift
//  NowFloats
//
//  Created by Manishi on 9/14/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit

class EditUserProfileViewController: CXViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerViewAlignments()
        dataIntegration()
        editDropDown()
        
        let imgTap:UIGestureRecognizer = UITapGestureRecognizer.init()
        imgTap.addTarget(self, action: #selector(editBtnAction(_:)))
        editDPImage.addGestureRecognizer(imgTap)

    }
    
    func dataIntegration(){
        staticEmail.text = emai
        staticMobileNumber.text = mobile
        
        firstNameTxtField.text = firstName
        lastNameTxtField.text = lastName
    
    }
    @IBAction func editBtnAction(sender: AnyObject) {
        chooseArticleDropDown.show()
    }
    
    @IBAction func saveChangesAction(sender: AnyObject) {
        //  func profileUpdate(email:String,address:String,firstName:String,lastName:String,mobileNumber:String,city:String,state:String,country:String,image:UIImage,completion:(responseDict:NSDictionary)-> Void){
        CXAppDataManager.sharedInstance.profileUpdate(self.staticEmail.text!, address:self.addressTxtField.text!, firstName: self.firstNameTxtField.text!, lastName: self.lastNameTxtField.text!, mobileNumber: self.staticMobileNumber.text!, city: self.cityTxtField.text!, state: self.stateTxtField.text!, country:"", image: self.editDPImage.image!) { (responseDict) in
            print(responseDict)
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
            }
        }
    
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
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
