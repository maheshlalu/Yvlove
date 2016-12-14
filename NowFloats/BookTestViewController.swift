//
//  BookTestViewController.swift
//  NowFloats
//
//  Created by Manishi on 12/13/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit

class BookTestViewController: CXViewController ,UITextFieldDelegate,UIScrollViewDelegate{
    
    @IBOutlet weak var fullNameTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var add1TxtField: UITextField!
    @IBOutlet weak var add2TxtField: UITextField!
    @IBOutlet weak var mobileTxtField: UITextField!
    @IBOutlet weak var chooseTimeTxtField: UITextField!
    @IBOutlet weak var chooseDateTxtField: UITextField!
    @IBOutlet weak var bookNowBt: UIButton!
    @IBOutlet weak var cScrollView: UIScrollView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bookNowBt.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()

        
        let tap = UITapGestureRecognizer(target: self, action: #selector(BookTestViewController.handleTap(sender:)))
        self.view.addGestureRecognizer(tap)
    }
    
    @IBAction func chooseTimeAction(_ sender: UITextField) {
        let datePickerView  : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.time
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(handleTimePicker(sender:)), for: .valueChanged)
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
    
    func handleTimePicker(sender:UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        chooseTimeTxtField.text = dateFormatter.string(from: sender.date)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.cScrollView.endEditing(true)
    }
    
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        // handling code
        
        self.view.endEditing(true)
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let scrollPoint = CGPoint(x: 0, y: textField.frame.origin.y)
        self.cScrollView.setContentOffset(scrollPoint, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.cScrollView.setContentOffset(CGPoint.zero, animated: true)
    }
}
