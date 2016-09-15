//
//  ViewController.swift
//  NowfloatAboutus
//
//  Created by apple on 13/09/16.
//  Copyright © 2016 apple. All rights reserved.
//

import UIKit

class AboutUsViewController: CXViewController,UITableViewDataSource,UITableViewDelegate {
    
    var nameArray = ["indiadhasgdhjgashjgdjhagsdhjgasdsadsadsadasgfhdgsafhdsjhfghjdsgfjhgdsjhfgjhgdfhgsgfjshdgfhgsdjgfsdgfgsdjgfdsgfgsdjfgsdgfjsdgfjgsdjfgsdgfjshdgfhsgd","america","newzealand"]
    
    @IBOutlet weak var timingsLbl: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var questionBtn: UIButton!
    @IBOutlet weak var aboutusimageview: UIImageView!
    @IBOutlet weak var aboutustableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.timingsLbl.layer.cornerRadius = 14.0
        self.questionBtn.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
        self.aboutustableview?.registerNib(UINib(nibName: "AboutusTableViewCell", bundle: nil), forCellReuseIdentifier: "AboutusTableViewCell")
        self.aboutustableview?.registerNib(UINib(nibName: "AboutUsExtraTableViewCell", bundle: nil), forCellReuseIdentifier: "AboutUsExtraTableViewCell")
        
        self.aboutustableview.separatorStyle = .None
        self.aboutustableview.rowHeight = UITableViewAutomaticDimension
        self.aboutustableview.estimatedRowHeight = 10.0
        
        self.aboutustableview.backgroundColor = UIColor.lightGrayColor()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return nameArray.count
 
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if indexPath.section == 0 {
            
            let aboutUs:AboutusTableViewCell! = tableView.dequeueReusableCellWithIdentifier("AboutusTableViewCell") as? AboutusTableViewCell
            aboutUs.selectionStyle = .None
            aboutUs.aboutusDescriptionlabel.text = nameArray[indexPath.section]
            aboutUs.aboutusrootLabel.text = "We are Located in"
            aboutUs.aboutuskmLabel.hidden = false
            aboutUs.aboutusgoogleLabel.hidden = false

            return aboutUs
            
        }else {
            
            let aboutUsExtra:AboutUsExtraTableViewCell! = tableView.dequeueReusableCellWithIdentifier("AboutUsExtraTableViewCell") as? AboutUsExtraTableViewCell
            aboutUsExtra.selectionStyle = .None
            
            if indexPath.section == 1{
                aboutUsExtra.extraTitleLbl.text = "We're happily available from"
                aboutUsExtra.extraDescLbl.text = "12:00Am to 11:30PM"
            }else if indexPath.section == 2{
                aboutUsExtra.extraTitleLbl.text = "You can reacdh us at"
                aboutUsExtra.extraDescLbl.text = "9640339556"
                aboutUsExtra.callBtn.hidden = false
            }
            return aboutUsExtra
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 5.0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if indexPath.section == 0{
        return UITableViewAutomaticDimension
        }else{
            return 70
        }
    }
    
    /*func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }*/
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

