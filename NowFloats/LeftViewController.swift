//
//  LeftViewController.swift
//  NowFloats
//
//  Created by Mahesh Y on 8/17/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit
class LeftViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var contentsTableView: UITableView!
    var profileDPImageView:UIImageView!
    var callUsBtn: UIButton!
    var messageBtn: UIButton!
    var viewMapBtn: UIButton!
    var titleLable: UILabel!
    var mailLable: UILabel!
    
    var navController : CXNavDrawer = CXNavDrawer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "LeftViewTableViewCell", bundle: nil)
        self.contentsTableView.registerNib(nib, forCellReuseIdentifier: "LeftViewTableViewCell")
        self.view.backgroundColor = UIColor.whiteColor()
        //self.detailsView.backgroundColor = UIColor.greenColor()
        sidepanelView()

    }
    func sidepanelView(){

        
        self.profileDPImageView = UIImageView.init(frame: CGRectMake(self.detailsView.frame.origin.x+10,self.detailsView.frame.origin.y-25,60,60))
        self.profileDPImageView .image = UIImage(named: "pp.jpg")
        self.profileDPImageView .layer.cornerRadius = self.profileDPImageView.frame.size.width / 2
        self.profileDPImageView .clipsToBounds = true
        self.detailsView.addSubview(self.profileDPImageView )
        
        self.titleLable = UILabel.init(frame: CGRectMake(self.profileDPImageView.frame.size.width + self.detailsView.frame.origin.x+15 ,self.detailsView.frame.origin.y-32,self.detailsView.frame.size.width - (self.profileDPImageView.frame.size.width)-45 ,55 ))
        self.titleLable.textColor = CXAppConfig.sharedInstance.getAppTheamColor()
        titleLable.lineBreakMode = .ByWordWrapping
        titleLable.numberOfLines = 0
        titleLable.font = UIFont(name: "Roboto-Bold", size: 15)
        titleLable.text = "68M Holidays Hyderabad"
        self.detailsView.addSubview(titleLable)
        
//        let mailImage = UIImageView.init(frame: CGRectMake())
//        mailImage.image = UIImage(named: "storeongo_gray.png")
//        self.sidePanelView.addSubview(mailImage)
        
        self.mailLable = UILabel.init(frame: CGRectMake(self.profileDPImageView.frame.size.width + self.detailsView.frame.origin.x+15 ,self.detailsView.frame.origin.y-32+self.titleLable.frame.size.height-10,self.detailsView.frame.size.width - (self.profileDPImageView.frame.size.width)-50 ,20 ))
        mailLable.font = mailLable.font.fontWithSize(10)
       // self.mailLable.backgroundColor = UIColor.yellowColor()
        mailLable.text = "iamsky.mme@gmail.com"
        self.detailsView.addSubview(mailLable)
        
        
        /*
        self.callUsBtn = self.createImageButton(CGRectMake(self.detailsView.frame.origin.x+5, self.detailsView.frame.size.height-60, 70 ,30), tag: 100, bImage:UIImage.init(imageLiteral: "callusBtnImage"))
         self.detailsView.addSubview(self.callUsBtn)
        
        self.messageBtn = self.createImageButton(CGRectMake(self.callUsBtn.frame.size.width+self.detailsView.frame.origin.x+5, self.detailsView.frame.size.height-60, 70 ,30), tag: 200, bImage:UIImage.init(imageLiteral: "callusBtnImage"))
        self.detailsView.addSubview(self.messageBtn)
        
        self.viewMapBtn = self.createImageButton(CGRectMake(self.messageBtn.frame.size.width+callUsBtn.frame.size.width+self.detailsView.frame.origin.x+5, self.detailsView.frame.size.height-60, 70 ,30), tag: 300, bImage:UIImage.init(imageLiteral: "callusBtnImage"))
        self.detailsView.addSubview(self.viewMapBtn)
        */

    
    }
    
    func createButton(frame:CGRect,title: String,tag:Int, bgColor:UIColor) -> UIButton {
        let button: UIButton = UIButton()
        button.frame = frame
        button.setTitle(title, forState: .Normal)
        button.titleLabel?.font = UIFont.init(name:"Roboto-Regular", size: 18)
        button.titleLabel?.textAlignment = NSTextAlignment.Left
        button.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        button.layer.cornerRadius = 5.0
        button.layer.masksToBounds = true
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        button.backgroundColor = bgColor
        return button
    }
    
    func createImageButton(frame:CGRect,tag:Int,bImage:UIImage) -> UIButton {
        let button: UIButton = UIButton()
        button.frame = frame
        button.backgroundColor = UIColor.yellowColor()
        button.setImage(bImage, forState: UIControlState.Normal)
        button.backgroundColor = UIColor.clearColor()
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        return button
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CXAppConfig.sharedInstance.getSidePanelList().count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("LeftViewTableViewCell", forIndexPath: indexPath) as! LeftViewTableViewCell
        cell.contentsLbl.text = CXAppConfig.sharedInstance.getSidePanelList()[indexPath.row] as? String
        cell.iconImage.image = UIImage.init(imageLiteral: (CXAppConfig.sharedInstance.getSidePanelList()[indexPath.row] as? String)!)
        cell.contentsLbl.textColor = UIColor.grayColor()
        cell.contentsLbl.font = cell.contentsLbl.font.fontWithSize(15)
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.navController.drawerToggle()
        let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())

        
        let itemName : String =  (CXAppConfig.sharedInstance.getSidePanelList()[indexPath.row] as? String)!
        if itemName == "Home"{
            if CXDataProvider.sharedInstance.getTheTableDataFromDataBase("CX_FeaturedProducts", predicate: NSPredicate(), ispredicate: false,orederByKey: "").totalCount == 0{
                let home = storyBoard.instantiateViewControllerWithIdentifier("UPDATE") as! UpdatesViewController
                self.navController.pushViewController(home, animated: true)
                
            }else{
                let home = storyBoard.instantiateViewControllerWithIdentifier("OFFERS") as! OffersViewController
                self.navController.pushViewController(home, animated: true)
            }
        }else if itemName == "About us"{
            let aboutUs = storyBoard.instantiateViewControllerWithIdentifier("ABOUT_US") as! AboutUsViewController
            self.navController.pushViewController(aboutUs, animated: true)
        }else if itemName == "Orders"{
            let orders = storyBoard.instantiateViewControllerWithIdentifier("ORDERS") as! OrdersViewController
            self.navController.pushViewController(orders, animated: true)
        }else if itemName == "Wishlist" {
            let wishlist = storyBoard.instantiateViewControllerWithIdentifier("WISHLIST") as! NowfloatWishlistViewController
            self.navController.pushViewController(wishlist, animated: true)
        }
 
    }
    
    @IBAction func callUsAction(sender: UIButton) {
        callNumber("9640339556")
    }
    
    @IBAction func messageAction(sender: UIButton) {
    }
    
    @IBAction func viewMapAction(sender: UIButton) {
        self.navController.drawerToggle()
        let mapViewCnt : MapViewCntl = MapViewCntl()
        self.navController.pushViewController(mapViewCnt, animated: true)
        
    }

    private func callNumber(phoneNumber:String) {
        //UIApplication.sharedApplication().openURL(NSURL(string: "tel:\("digits")")!)
        UIApplication.sharedApplication().openURL(NSURL(string: "tel://\(phoneNumber)")!)
        
//        if let phoneCallURL:NSURL = NSURL(string:"tel://\(phoneNumber)") {
//            let application:UIApplication = UIApplication.sharedApplication()
//            if (application.canOpenURL(phoneCallURL)) {
//                application.openURL(phoneCallURL);
//            }
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

}
