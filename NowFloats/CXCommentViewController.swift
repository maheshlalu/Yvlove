//
//  CXCommentViewController.swift
//  Silly Monks
//
//  Created by Sarath on 20/05/16.
//  Copyright © 2016 Sarath. All rights reserved.
//

import UIKit

class CXCommentViewController: CXViewController {
    
    var writeBtn:UIButton!
    var ratingBtn:UIButton!
    var headerTitle:String!
    var orgID: String!
    var jobID : String!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.smBackgroundColor()
        self.customizeMainView()
        

        // Do any additional setup after loading the view.
    }
    
    func customizeMainView() {
        
//       let height = UIScreen.mainScreen().bounds.size.height
//        
//        let vHeight = self.view.frame.size.height
        //print("Screen height \(height) and view frame \(vHeight)")
        
        let comentImageView = UIImageView.init(frame: CGRectMake((self.view.frame.size.width - 60)/2,(self.view.frame.size.height-65-60-50)/2 , 60, 60))
        //comentImageView.backgroundColor = UIColor.redColor()
        //comentImageView.center = self.view.center
        comentImageView.image = UIImage(named: "writeComment")
        self.view.addSubview(comentImageView)
        
        let writeLbl = UILabel.init(frame: CGRectMake(20, comentImageView.frame.size.height+comentImageView.frame.origin.y, self.view.frame.size.width-40, 30))
        writeLbl.text = "Be the first to write"
        writeLbl.textColor = UIColor.blackColor()
        writeLbl.font = UIFont(name: "Roboto-Regular", size: 15)
        writeLbl.textAlignment = NSTextAlignment.Center
        self.view.addSubview(writeLbl)
        
        
        let btnsView = UIView.init(frame: CGRectMake(0, self.view.frame.size.height-65-50, self.view.frame.size.width, 50))
        btnsView.backgroundColor = UIColor.yellowColor()
        self.view.addSubview(btnsView)
        
        let writeColor = UIColor(red: 68.0/255.0, green: 68.0/255.0, blue: 68.0/255.0, alpha: 1.0)
        
        self.writeBtn = self.createButton(CGRectMake(0, 0, btnsView.frame.size.width/2, 50), title: "WRITE", tag: 1, bgColor: writeColor)
        self.writeBtn.addTarget(self, action: #selector(CXCommentViewController.writeCommentAction), forControlEvents: UIControlEvents.TouchUpInside)
        btnsView.addSubview(self.writeBtn)
        
        self.ratingBtn = self.createButton(CGRectMake(self.writeBtn.frame.size.width+self.writeBtn.frame.origin.x, 0, btnsView.frame.size.width/2, 50), title: "OVERALL RATING", tag: 2, bgColor:CXAppConfig.sharedInstance.getAppTheamColor())
        self.ratingBtn.addTarget(self, action: #selector(CXCommentViewController.overallRatingAction), forControlEvents: UIControlEvents.TouchUpInside)
        btnsView.addSubview(self.ratingBtn)
        
    }
    
    func writeCommentAction() {
        let comRatView = CXCommentRatingViewController.init()
        comRatView.jobID = self.jobID
        self.navigationController?.pushViewController(comRatView, animated: true)
    }
    
    func overallRatingAction() {
        
    }

    func backAction() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func createButton(frame:CGRect,title: String,tag:Int, bgColor:UIColor) -> UIButton {
        let button: UIButton = UIButton()
        button.frame = frame
        button.setTitle(title, forState: .Normal)
        button.titleLabel?.font = UIFont.init(name:"Roboto-Bold", size: 15)
        button.titleLabel?.textAlignment = NSTextAlignment.Center
        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        button.backgroundColor = bgColor
        return button
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MAR:Heder options enable
    override  func shouldShowRightMenu() -> Bool{
        
        return true
    }
    
    override func shouldShowNotificatoinBell() ->Bool{
        
        return false
    }
    
    override  func shouldShowCart() -> Bool{
        
        return true
    }
    
    override func shouldShowLeftMenu() -> Bool{
        
        return false
    }
    override func showLogoForAboutUs() -> Bool{
        return false
    }
    override func shouldShowLeftMenuWithLogo() -> Bool{
        
        return false
    }
    override func headerTitleText() -> String{
        return "Profile"
    }
    
    override func profileDropdown() -> Bool{
        return true
    }
    
    override func profileDropdownForSignIn() -> Bool{
        return false
    }
    

}
