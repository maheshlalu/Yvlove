//
//  EditUserProfileViewController.swift
//  NowFloats
//
//  Created by Manishi on 9/14/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit

class EditUserProfileViewController: CXViewController {
    
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
     
        
        
    }
    
    func headerViewAlignments(){
        
        stateTxtField.selectedLineColor = CXAppConfig.sharedInstance.getAppTheamColor()
        cityTxtField.selectedLineColor = CXAppConfig.sharedInstance.getAppTheamColor()
        addressTxtField.selectedLineColor = CXAppConfig.sharedInstance.getAppTheamColor()
        firstNameTxtField.selectedLineColor = CXAppConfig.sharedInstance.getAppTheamColor()
        lastNameTxtField.selectedLineColor = CXAppConfig.sharedInstance.getAppTheamColor()
        
        
        self.editProfileView.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
        self.editDPImage.clipsToBounds = true
        self.editDPImage.layer.cornerRadius = self.editDPImage.frame.size.width/5
        self.editDPImage.layer.borderWidth = 3.0
        self.editDPImage.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
