//
//  CXPayMentController.swift
//  Coupocon
//
//  Created by apple on 07/11/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit
@objc  protocol paymentDelegate
{
    
   @objc optional func pamentSuccessFully(resultDiuct:NSDictionary)
}

class CXPayMentController: UIViewController {
    
    var paymentDelegate:paymentDelegate?
    
    typealias CompletionBlock = (_ paymentSuccesDic:NSDictionary) -> Void

    var paymentUrl : NSURL! = nil
    var webRequestArry: NSMutableArray = NSMutableArray()
     var payMentWebView: UIWebView!
      var activity: UIActivityIndicatorView = UIActivityIndicatorView()
    var completion: CompletionBlock = { reason in print(reason) }

    override func viewDidLoad() {
        
        //self.navigationItem.hidesBackButton = true
        
        super.viewDidLoad()
       // CXDataService.sharedInstance.showLoader(view: self.view, message: "Processing...")
      //  CXDataService.sharedInstance.showLoader(message: "Processing...")
        self.designWebView()
        payMentWebView.delegate = self
        let requestObj = NSURLRequest(url: paymentUrl as URL)
        self.payMentWebView.loadRequest(requestObj as URLRequest)
        //self.navigationItem.setHidesBackButton(true, animated:true);
        self.title = "Payment Gateway"
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "Roboto-Bold", size: 20)!
        ]

        self.activity = UIActivityIndicatorView()
        self.activity.tintColor = CXAppConfig.sharedInstance.getAppTheamColor()
        // Do any additional setup after loading the view.
        
        
        
        let backItem = UIBarButtonItem(image: UIImage(named: "back-120"), landscapeImagePhone: nil, style:  .plain, target: self, action: #selector(CXPayMentController.goBack))
        //   backItem.title = "Back"
        //back-120
        //navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
        self.navigationItem.leftBarButtonItem = backItem
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }

    
    func goBack()
    {
        self.showAlertView(message: "", status: 0)
    }
    
    func showAlertView(message:String, status:Int) {
        
        let refreshAlert = UIAlertController(title: "", message: "Do you want to cancel this transaction and go back?", preferredStyle: .alert)
        refreshAlert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
            //Stay same place
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
            //Go back
           // self.goBackcompletion(isGoBack: true)
            self.navigationController?.popToRootViewController(animated: true)
            
        }))
        
        self.present(refreshAlert, animated: true, completion: nil)
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func designWebView(){
        self.payMentWebView = UIWebView()
        self.payMentWebView.frame = CGRect(x: 0, y: 0, width: CXAppConfig.sharedInstance.mainScreenSize().width, height: CXAppConfig.sharedInstance.mainScreenSize().height)
        self.view.addSubview(self.payMentWebView)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CXPayMentController : UIWebViewDelegate {
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool{
        self.webRequestArry.add(String(describing: request.url!))
        print(request)
        return true
    }
    func webViewDidStartLoad(_ webView: UIWebView){
       // CXDataService.sharedInstance.showLoader(view: self.view, message: "Processing...")
//        CXDataService.sharedInstance.showLoader(message: "Processing...")
        activity.isHidden = false
        activity.startAnimating()
    }
    func webViewDidFinishLoad(_ webView: UIWebView){
      //  print(self.webRequestArry.lastObject)
       // CXDataService.sharedInstance.hideLoader()
        let lastRequest : String = String(describing: self.webRequestArry.lastObject!)
        print(lastRequest)
        if ((lastRequest.range(of:"paymentOrderResponse")) != nil)  {
          //  CXDataService.sharedInstance.showLoader(message: "Processing...")
            //CXDataService.sharedInstance.showLoader(view: self.view, message: "Processing...")
            CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(lastRequest, completion: { (responseDict) in
               // print(responseDict)
                let status : String = (responseDict.value(forKey: "status") as? String)!
                if status == "Completed" {
                    self.completion(responseDict)
                
//                    if (self.paymentDelegate != nil) {
//                        self.paymentDelegate?.pamentSuccessFully!(resultDiuct: responseDict)
//                    }
                }else{
                    
                }
                //LoadingView.hide()
               // CXDataService.sharedInstance.hideLoader()
            })
        }
        activity.isHidden = true
        activity.stopAnimating()
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error){
        activity.isHidden = true
        activity.stopAnimating()
    }
    
}
