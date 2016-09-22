//
//  ViewController.swift
//  MessageEnquiry
//
//  Created by apple on 14/09/16.
//  Copyright © 2016 apple. All rights reserved.
//

import UIKit

class FormViewController: CXViewController {

    @IBAction func formSubmitbuttonAction(sender: UIButton) {
    }
    @IBOutlet weak var formtextf3: UITextField!
    @IBOutlet weak var formtextf2: UITextField!
    @IBOutlet weak var formtextf1: UITextField!
    @IBOutlet weak var formUIview: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

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
        return "Enquiry"
    }
    
    override func shouldShowLeftMenu() -> Bool{
        
        return true
    }
    override func showLogoForAboutUs() -> Bool{
        return false
    }
    
    override func shouldShowLeftMenuWithLogo() -> Bool{
        
        return true
    }
    
    override func profileDropdown() -> Bool{
        return false
    }
    
    override func profileDropdownForSignIn() -> Bool{
        return false
    }

}

