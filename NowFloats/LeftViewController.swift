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
        
        self.titleLable = UILabel.init(frame: CGRectMake(self.profileDPImageView.frame.size.width + self.detailsView.frame.origin.x+15 ,self.detailsView.frame.origin.y-32,self.detailsView.frame.size.width - (self.profileDPImageView.frame.size.width)-50 ,70 ))
       // self.titleLable.backgroundColor = UIColor.redColor()
        titleLable.lineBreakMode = .ByWordWrapping
        titleLable.numberOfLines = 0
        titleLable.font = UIFont(name: "Roboto-Bold", size: 15)
        titleLable.text = "68M Holidays Hyderabad"
        self.detailsView.addSubview(titleLable)
        
        
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

        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

}
