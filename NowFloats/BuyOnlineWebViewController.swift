//
//  BuyOnlineWebViewController.swift
//  NowFloats
//
//  Created by Manishi on 1/9/17.
//  Copyright © 2017 CX. All rights reserved.
//

import UIKit

class BuyOnlineWebViewController: CXViewController {
    
    var url:String!
    var productName:String!
    
    @IBOutlet weak var myWebView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.myWebView.scalesPageToFit = true
        self.myWebView.contentMode = UIViewContentMode.scaleAspectFit
        let requestObj = NSURLRequest(url:NSURL(string: self.url) as! URL)
        myWebView.loadRequest(requestObj as URLRequest)
        
    }
    
    //MAR:Heder options enable
    override  func shouldShowRightMenu() -> Bool{
        return true
    }
    
    override func shouldShowNotificatoinBell() ->Bool{
        return false
    }
    
    override  func shouldShowCart() -> Bool{
        return false
    }
    
    override func headerTitleText() -> String{
        return productName
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
