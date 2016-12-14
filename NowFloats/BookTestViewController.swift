//
//  BookTestViewController.swift
//  NowFloats
//
//  Created by Manishi on 12/13/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit

class BookTestViewController: CXViewController ,UITextFieldDelegate,UIScrollViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource{
    
    @IBOutlet weak var fullNameTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var add1TxtField: UITextField!
    @IBOutlet weak var add2TxtField: UITextField!
    @IBOutlet weak var mobileTxtField: UITextField!
    @IBOutlet weak var chooseTimeTxtField: UITextField!
    @IBOutlet weak var chooseDateTxtField: UITextField!
    @IBOutlet weak var bookNowBt: UIButton!
    @IBOutlet weak var cScrollView: UIScrollView!

    var pickOption = ["9:30 AM - 10:00AM", "10:00 AM - 10:30AM", "10:30 AM - 11:00AM", "11:00 AM - 11:30AM", "11:30 AM - 12:00PM","12:00 PM - 12:30PM", "12:30 PM - 1:00PM", "1:00 PM - 1:30PM", "1:30 PM - 2:00PM", "2:00 PM - 2:30PM","2:30 PM - 3:00PM", "3:00 PM - 3:30PM","3:30 PM - 4:00PM", "4:00 PM - 4:30PM","4:30 PM - 5:00PM", "5:00 PM - 5:30PM"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bookNowBt.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
        let pickerView = UIPickerView()
        
        pickerView.delegate = self
        chooseTimeTxtField.inputView = pickerView
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(BookTestViewController.handleTap(sender:)))
        self.view.addGestureRecognizer(tap)
    }
    
    
    @IBAction func chooseCollectionDateAction(_ sender: UITextField) {
        let currentDate: NSDate = NSDate()
        let datePickerView  : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        let gregorian: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let components: NSDateComponents = NSDateComponents()
        
        components.day = 0
        let minDate: NSDate = gregorian.date(byAdding: components as DateComponents, to: currentDate as Date, options: NSCalendar.Options(rawValue: 0))! as NSDate
        
        components.day = 7
        let maxDate: NSDate = gregorian.date(byAdding: components as DateComponents, to: currentDate as Date, options: NSCalendar.Options(rawValue: 0))! as NSDate
        
        datePickerView.minimumDate = minDate as Date
        datePickerView.maximumDate = maxDate as Date
        
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
    }
    
    func handleDatePicker(sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        chooseDateTxtField.text = dateFormatter.string(from: sender.date)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.cScrollView.endEditing(true)
    }
    
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        // handling code
        
        self.view.endEditing(true)
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickOption.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickOption[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        chooseTimeTxtField.text = pickOption[row]
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
        return ""
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
