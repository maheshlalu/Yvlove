//
//  UpdatesViewController.swift
//  NowFloats
//
//  Created by Mahesh Y on 8/18/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit

class UpdatesViewController: CXViewController {

    let monthsMillisecond:Int64 = 2592000000
    @IBOutlet weak var updateTableView: UITableView!
    @IBOutlet weak var updatesSearch: UISearchBar!
    var updatesArray : NSArray! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateTableView.backgroundView?.backgroundColor = UIColor.clearColor()
        self.updateTableView.backgroundColor = UIColor.clearColor()
        self.view.backgroundColor =  CXAppConfig.sharedInstance.getAppBGColor()
        self.updatesArray = NSArray()
        self.setUpTableView()
        self.getUpdates()
        // Do any additional setup after loading the view.
    }
    
    func getUpdates(){
        CXDataService.sharedInstance.getTheUpdatesFromServer(["clientId":"5FAE0707506C43BAB8B8C9F554586895577B22880B834423A473E797607EFCF6","skipBy":"0","fpid":"\(CXConstant.sharedInstance.getTheFid())"]) { (responseDict) in
            self.updatesArray = NSArray(array: (responseDict.valueForKey("floats") as? NSArray)!)
            self.updateTableView.reloadData()
        }
    }
    
    func setUpTableView(){
        
        let nib = UINib(nibName: "UpdateTableViewCell", bundle: nil)
        self.updateTableView.registerNib(nib, forCellReuseIdentifier: "UpdateTableViewCell")
        self.updateTableView.rowHeight = UITableViewAutomaticDimension
        self.updateTableView.estimatedRowHeight = 10.0
        //self.tableview.contentInset = UIEdgeInsetsMake(0,5, 0,5)
        self.updateTableView.delegate =  self
        self.updateTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}



extension UpdatesViewController : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        
        return self.updatesArray.count
        
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        
        return UITableViewAutomaticDimension
        
    }
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        
        return 0.0
        
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 7.0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        self.updateTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        return 1
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("UpdateTableViewCell", forIndexPath: indexPath)as! UpdateTableViewCell
        //cell.backgroundColor = UIColor.clearColor()
        cell.backgroundView?.backgroundColor = UIColor.clearColor()
        let updateDic : NSDictionary = self.updatesArray[indexPath.section] as! NSDictionary
        cell.selectionStyle = .None
        cell.descriptionLabel.text = updateDic.valueForKey("message") as?String
        
        let createdDate = updateDic.valueForKey("createdOn") as?String
        let createdTimeStr = getCreatedTime(createdDate!)
        cell.monthLabel.text = createdTimeStr
        
        
        let imgUrl = updateDic.valueForKey("imageUri") as?String
        if (imgUrl!.lowercaseString.rangeOfString("https") != nil){
            cell.nameimageView.sd_setImageWithURL(NSURL(string:imgUrl!))
        }
        cell.shareBtn.tag = indexPath.section+1
        cell.shareBtn.addTarget(self, action: #selector(UpdatesViewController.shareBtnAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        cell.descriptionLabel.font = CXAppConfig.sharedInstance.appMediumFont()
        cell.monthLabel.font = CXAppConfig.sharedInstance.appSmallFont()


        
        return cell

    }
    
    func shareBtnAction(button : UIButton!){
        
        let updateDic : NSDictionary = self.updatesArray[button.tag-1] as! NSDictionary
        let description = updateDic.valueForKey("message") as?String
        let url = updateDic.valueForKey("url") as? String
        
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: [description!,url!], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivityTypePrint, UIActivityTypePostToWeibo, UIActivityTypeCopyToPasteboard, UIActivityTypeAddToReadingList, UIActivityTypePostToVimeo]
        self.presentViewController(activityViewController, animated: true, completion: nil)
        
    }
    
    func getCreatedTime(createdDate:String) -> String{

        let component = createdDate.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
        let list = component.filter({ $0 != "" })
        let number: Int64? = Int64(list[0])
        
        let mydate = NSDate()
        let currentTime = Int64(mydate.timeIntervalSince1970 * 1000)
        
        let finalDate = currentTime - number!
        
        var milliseconds : double_t = double_t(finalDate);
        
        milliseconds =  floor(milliseconds/1000);
        let seconds = milliseconds //29825913.019
        let minutes = floor(milliseconds/60) //497098.55031667
        let hours = floor(minutes/60) //8284.9758386111661821
        let days = floor(hours/24) //345.20732660879860987
        let weeks = floor(days/7) //49.31533237268551062
        let months = finalDate/monthsMillisecond
        let years = months/12
        
        if years == 0 {
            return "\(months) Months Ago"
        }else if months == 0 {
            return "\(weeks) Weeks Ago"
        }else if weeks == 0 {
            return "\(days) Days Ago"
        }else if days == 0 {
            return "\(hours) Hours Ago"
        }else if hours == 0 {
            return "\(minutes) Minutes Ago"
        }else if minutes == 0 {
            return "\(seconds) Seconds Ago"
        }
        return ""
    }
}
