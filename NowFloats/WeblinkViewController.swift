//
//  WeblinkViewController.swift
//  NowFloats
//
//  Created by apple on 13/09/17.
//  Copyright © 2017 CX. All rights reserved.
//

import UIKit

class WeblinkViewController: CXViewController {
    var payMentWebView: UIWebView!
    var activity: UIActivityIndicatorView = UIActivityIndicatorView()
    var webLink : String!
    var displayName:String!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.backButton()
        self.designWebView()
        
        //self.title = self.displayName
//        self.navigationController?.navigationBar.titleTextAttributes = [
//            NSForegroundColorAttributeName: UIColor.white,
//            NSFontAttributeName: UIFont(name: "Roboto-Bold", size: 20)!
//        ]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func designWebView(){
        self.payMentWebView = UIWebView()
        self.payMentWebView.frame = CGRect(x: 0, y: 0, width: CXAppConfig.sharedInstance.mainScreenSize().width, height: CXAppConfig.sharedInstance.mainScreenSize().height)
        self.view.addSubview(self.payMentWebView)
        payMentWebView.delegate = self
        self.activity.center = CGPoint(x: CXAppConfig.sharedInstance.mainScreenSize().width/2, y: CXAppConfig.sharedInstance.mainScreenSize().height/2)
        
        let requestObj = NSURLRequest(url:  URL(string: self.webLink)!)
        self.payMentWebView.loadRequest(requestObj as URLRequest)
        self.payMentWebView.addSubview(activity)
        self.activity.startAnimating()


    }
    
    func backButton(){

        let backItem = UIBarButtonItem(image: UIImage(named: "back-120"), landscapeImagePhone: nil, style:  .plain, target: self, action: #selector(WeblinkViewController.goBack))
        //   backItem.title = "Back"
        //back-120
        //navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
        self.navigationItem.leftBarButtonItem = backItem
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    func goBack()
    {
        self.navigationController?.popViewController(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
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
        return self.displayName
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

extension WeblinkViewController : UIWebViewDelegate {
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool{
        return true
    }
    func webViewDidStartLoad(_ webView: UIWebView){
        // CXDataService.sharedInstance.showLoader(view: self.view, message: "Processing...")
        //        CXDataService.sharedInstance.showLoader(message: "Processing...")
        activity.isHidden = false
        activity.startAnimating()
    }
    func webViewDidFinishLoad(_ webView: UIWebView){
        // CXDataService.sharedInstance.hideLoader()
     
        activity.isHidden = true
        activity.stopAnimating()
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error){
        activity.isHidden = true
        activity.stopAnimating()
    }
    
    
    
    
}
