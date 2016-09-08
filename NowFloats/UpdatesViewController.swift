//
//  UpdatesViewController.swift
//  NowFloats
//
//  Created by Mahesh Y on 8/18/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit

class UpdatesViewController: CXViewController {

    @IBOutlet weak var updateTableView: UITableView!
    @IBOutlet weak var updatesSearch: UISearchBar!
    var updatesArray : NSArray! = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updatesArray = NSArray()
        view.backgroundColor = UIColor.greenColor()
        self.setUpTableView()
        self.getUpdates()
        // Do any additional setup after loading the view.
    }
    
    func getUpdates(){
        CXDataService.sharedInstance.getTheUpdatesFromServer(["clientId":"5FAE0707506C43BAB8B8C9F554586895577B22880B834423A473E797607EFCF6","skipBy":"0","fpid":"\(CXConstant.sharedInstance.getTheFid())"]) { (responseDict) in
            self.updatesArray = NSArray(array: (responseDict.valueForKey("floats") as? NSArray)!)
            self.updateTableView.reloadData()
            print(self.updatesArray)
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
        
        self.updateTableView.backgroundColor = UIColor.lightGrayColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    /*
     https://api.withfloats.com/Discover/v2/floatingPoint/bizFloats?clientId=5FAE0707506C43BAB8B8C9F554586895577B22880B834423A473E797607EFCF6&skipBy=0&fpid=kljadlkcjasd898979
     */

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
        
        return 8.0
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        self.updateTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        return 1
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("UpdateTableViewCell", forIndexPath: indexPath)as! UpdateTableViewCell
        let updateDic : NSDictionary = self.updatesArray[indexPath.section] as! NSDictionary
        cell.descriptionLabel.text = updateDic.valueForKey("message") as?String
               return cell
        
        /*
         
         @IBOutlet var monthLabel: UILabel!
         @IBOutlet var descriptionLabel: UILabel!
         @IBOutlet var nameimageView: UIImageView!
         {
         "_id" = 560d47f94ec0a41d447c1a32;
         createdOn = "/Date(1443710969222)/";
         imageUri = "/BizImages/Actual/560d47fd4ec0a41d447c1a34.jpg";
         message = "Singapore Flyer:\nThe Singapore flyer is the World s largest observation wheel, giving amazing spectacular View of the city.It takes around 30min ride you can have view of Sentosa, Singapore River, Marina Bay, Changi Airport, Even You can see Malaysia and Indonesia\nSingapore flyer operating hours: 8:30am to 10:30 pm\nDuration : 30 Min\nCost Aprrox  starts from 25 USD\n";
         tileImageUri = "/BizImages/Actual/560d47fd4ec0a41d447c1a34.jpg";
         type = "<null>";
         url = "http://68mholidays.com/bizFloat/560d47f94ec0a41d447c1a32/Singapore-Flyer-The-Singapore-flyer-is-the-World-s-largest-observation-wheel-giving-amazing-spectacular-View-of-the-city-It-takes-around-30min-ride-you-can-have-view-of-Sentosa-Singapore-River-Marina-Bay-Changi-Airport-Even-You-can-see-Malaysia-and-Indonesia-Singapore-flyer-operating-hours-8-30am-to-10-30-pm-Duration-30-Min-Cost-Aprrox-starts-from-25-USD-";
         },
         */
    }
    
}
