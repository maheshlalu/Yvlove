//
//  BookTestViewController.swift
//  NowFloats
//
//  Created by Manishi on 12/13/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit

class BookTestViewController: CXViewController {
    
    @IBOutlet weak var fullNameTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var add1TxtField: UITextField!
    @IBOutlet weak var add2TxtField: UITextField!
    @IBOutlet weak var mobileTxtField: UITextField!
    @IBOutlet weak var chooseTimeTxtField: UITextField!
    @IBOutlet weak var chooseDateTxtField: UITextField!
    @IBOutlet weak var bookNowBt: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bookNowBt.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
        
    }
    
    @IBAction func chooseTimeAction(_ sender: Any) {
        
    }
    
    @IBAction func chooseCollectionDateAction(_ sender: UITextField) {
        
        let datePickerView  : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
    }
    
    func handleDatePicker(sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        chooseDateTxtField.text = dateFormatter.string(from: sender.date)
    }
    
    //MAR:Heder options enable
    override  func shouldShowRightMenu() -> Bool{
        
        return false
    }
    
    override func shouldShowNotificatoinBell() ->Bool{
        
        return false
    }
    
    override  func shouldShowCart() -> Bool{
        
        return false
    }

    override func headerTitleText() -> String{
        return "BOOKING DETAILS"
    }
    
    override func shouldShowLeftMenu() -> Bool{
        
        return false
    }
    override func shouldShowLeftMenuWithLogo() -> Bool{
        
        return false
    }
    override func showLogoForAboutUs() -> Bool{
        return false
    }
    override func profileDropdown() -> Bool{
        return false
    }
    
    override func profileDropdownForSignIn() -> Bool{
        return false
    }
}
