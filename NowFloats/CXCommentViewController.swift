//
//  CXCommentViewController.swift
//  Silly Monks
//
//  Created by Sarath on 20/05/16.
//  Copyright © 2016 Sarath. All rights reserved.
//

import UIKit

class CXCommentViewController: CXViewController,UITableViewDataSource,UITableViewDelegate{
    
    var writeBtn:UIButton!
    var ratingBtn:UIButton!
    var headerTitle:String!
    var orgID: String!
    var jobID : String!
    var array = ["Rating"]
    var tableView = UITableView()
    var itemCode = String()
    var compareString = String()
    var jobDocumentArray = NSArray()
    var refresher : UIRefreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
     
        //smBackgroundColor()
        //self.customizeMainView()
        refresher = UIRefreshControl()
        refresher.tintColor = UIColor.blue
        self.designCommentTableView()
        getTheComments()

        // Do any additional setup after loading the view.
    }
    
    func designCommentTableView(){
    
        let table: UITableViewController = UITableViewController()
        let tableView: UITableView = UITableView()
        tableView.frame = CGRect(x: 0, y: 10, width: self.view.frame.size.width, height: 500)
        tableView.dataSource = table
        tableView.delegate = table
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return jobDocumentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dictionary =  jobDocumentArray[indexPath.row] as? NSDictionary
        let cellId = "MyCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        let screen =  UIScreen.main.bounds
        
        if cell  == nil{
            
            cell = UITableViewCell.init(style: .default, reuseIdentifier: cellId)
            
            //cell?.contentView.backgroundColor = UIColor.lightGray
            let title = UILabel()
            title.frame  = CGRect(x: 40, y: 10, width: 140, height: 20)
            //title.backgroundColor = UIColor.redColor()
            title.tag = 101
            title.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
            cell?.contentView.addSubview(title)
            
            let deslabel = UILabel()
            deslabel.frame  = CGRect(x: 40, y: 50, width: 245, height: 40)
            // deslabel.backgroundColor = UIColor.yellowColor()
            deslabel.tag = 102
            deslabel.numberOfLines = 0
            deslabel.font = UIFont(name: "HelveticaNeue-Italic", size: 16)
            cell?.contentView.addSubview(deslabel)
            
            let view = UIView()
            view.frame = CGRect(x: screen.size.width-50, y: 5, width: 40, height: 40)
            view.tag = 103
            view.layer.cornerRadius = 20
            view.layer.borderWidth = 1
            view.layer.masksToBounds = true
            view.backgroundColor = UIColor.black
            cell?.contentView.addSubview(view)
            
            let ratingLabel = UILabel()
            ratingLabel.frame = CGRect(x: 0, y: 4, width: 40, height: 30)
            ratingLabel.tag = 104
            ratingLabel.backgroundColor = UIColor.clear
            ratingLabel.textColor = UIColor.white
            ratingLabel.textAlignment = .center
            view.addSubview(ratingLabel)
            
            
            let timeLabel = UILabel()
            timeLabel.frame  = CGRect(x: 40, y: 100, width: 200, height: 40)
            timeLabel.tag = 105
            timeLabel.numberOfLines = 0
            timeLabel.font = UIFont(name: "HelveticaNeue-Italic", size: 16)
            cell?.contentView.addSubview(timeLabel)
        }
        
        let titlelabel = cell?.contentView.viewWithTag(101) as! UILabel
        let deslabel = cell?.contentView.viewWithTag(102) as! UILabel
        let Ratinglabel = cell?.contentView.viewWithTag(104) as! UILabel
        let timingLabel = cell?.contentView.viewWithTag(105) as! UILabel
        titlelabel.text = dictionary?.value(forKey: "postedBy_Name") as? String
        deslabel.text = dictionary?.value(forKey: "comment") as? String
        Ratinglabel.text = dictionary?.value(forKey: "rating") as? String
        timingLabel.text = dictionary?.value(forKey: "time") as? String
        cell?.selectionStyle = .none
        
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 160
    }
    func getTheComments(){
        CXDataService.sharedInstance.showLoader(view: self.view, message: "Loading..")
        CXDataService.sharedInstance.getTheAppDataFromServer(["type":"Stores" as AnyObject,"mallId":CXAppConfig.sharedInstance.getAppMallID() as AnyObject]) { (responseDict) in
            CXDataService.sharedInstance.hideLoader()
            let commentArray = responseDict.value(forKey: "jobs") as! NSArray
            for obj in commentArray{
                let dict = (obj as? NSDictionary)!
                self.itemCode = (dict.value(forKey: "ItemCode") as? String)!
                if self.itemCode.contains(CXAppConfig.sharedInstance.getAppMallID()) {
                    self.jobDocumentArray = dict.value(forKey: "jobComments") as! NSArray
                    self.tableView.reloadData()
                    CXDataService.sharedInstance.hideLoader()
                }
            }
        }
    }
    
    func customizeMainView() {
        
        //       let height = UIScreen.mainScreen().bounds.size.height
        //
        //        let vHeight = self.view.frame.size.height
        
        let comentImageView = UIImageView.init(frame: CGRect(x: (self.view.frame.size.width - 60)/2,y: (self.view.frame.size.height-65-60-50)/2 , width: 60, height: 60))
        //comentImageView.backgroundColor = UIColor.redColor()
        //comentImageView.center = self.view.center
        comentImageView.image = UIImage(named: "writeComment")
        self.view.addSubview(comentImageView)
        
        let writeLbl = UILabel.init(frame: CGRect(x: 20, y: comentImageView.frame.size.height+comentImageView.frame.origin.y, width: self.view.frame.size.width-40, height: 30))
        writeLbl.text = "Be the first to write"
        writeLbl.textColor = UIColor.black
        writeLbl.font = UIFont(name: "Roboto-Regular", size: 15)
        writeLbl.textAlignment = NSTextAlignment.center
        self.view.addSubview(writeLbl)
        
        
        let btnsView = UIView.init(frame: CGRect(x: 0, y: self.view.frame.size.height-65-30, width: self.view.frame.size.width, height: 50))
        btnsView.backgroundColor = UIColor.yellow
        self.view.addSubview(btnsView)
        
        let writeColor = UIColor(red: 68.0/255.0, green: 68.0/255.0, blue: 68.0/255.0, alpha: 1.0)
        
        self.writeBtn = self.createButton(CGRect(x: 0, y: 0, width: btnsView.frame.size.width/2, height: 50), title: "WRITE", tag: 1, bgColor: writeColor)
        self.writeBtn.addTarget(self, action: #selector(CXCommentViewController.writeCommentAction), for: UIControlEvents.touchUpInside)
        btnsView.addSubview(self.writeBtn)
        
        self.ratingBtn = self.createButton(CGRect(x: self.writeBtn.frame.size.width+self.writeBtn.frame.origin.x, y: 0, width: btnsView.frame.size.width/2, height: 50), title: "OVERALL RATING", tag: 2, bgColor:CXAppConfig.sharedInstance.getAppTheamColor())
        self.ratingBtn.addTarget(self, action: #selector(CXCommentViewController.overallRatingAction), for: UIControlEvents.touchUpInside)
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
        self.navigationController?.popViewController(animated: true)
    }
    
    func createButton(_ frame:CGRect,title: String,tag:Int, bgColor:UIColor) -> UIButton {
        let button: UIButton = UIButton()
        button.frame = frame
        button.setTitle(title, for: UIControlState())
        button.titleLabel?.font = UIFont.init(name:"Roboto-Bold", size: 15)
        button.titleLabel?.textAlignment = NSTextAlignment.center
        button.setTitleColor(UIColor.white, for: UIControlState())
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
