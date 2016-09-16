//
//  ViewController.swift
//  Nowfloatorders
//
//  Created by apple on 13/09/16.
//  Copyright © 2016 apple. All rights reserved.
//

import UIKit

class OrdersViewController: CXViewController,UITableViewDataSource,UITableViewDelegate {
    var nameArray = ["india","america","newzealand"]
    var ordersArray:NSArray = NSArray()
    @IBOutlet weak var orderstableview: UITableView!
    var oredrDic : NSDictionary!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "ordersTableViewCell", bundle: nil)
        
        self.orderstableview.registerNib(nib, forCellReuseIdentifier: "ordersTableViewCell")
        
        self.orderstableview.rowHeight = UITableViewAutomaticDimension
        self.orderstableview.estimatedRowHeight = 10.0
        self.orderstableview.backgroundColor = UIColor.clearColor()
        self.view.backgroundColor = CXAppConfig.sharedInstance.getAppBGColor()
        
        CXAppDataManager.sharedInstance.getOrders { (responseDict) in
            //  print("print the my orders \(responseDict)")
            let jobs : NSArray =  responseDict.valueForKey("jobs")! as! NSArray
            self.ordersArray = jobs
            self.orderstableview.reloadData()
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        
        return ordersArray.count
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return 1
        
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        
        let cell = orderstableview.dequeueReusableCellWithIdentifier("ordersTableViewCell", forIndexPath: indexPath)as! ordersTableViewCell
        cell.backgroundView?.backgroundColor = UIColor.clearColor()
        let orederDataDic : NSDictionary = self.ordersArray[indexPath.section] as! NSDictionary
        cell.orderidresultlabel.text = CXConstant.resultString(orederDataDic.valueForKey("id")!)
        cell.orderpriceresultlabel.text = orederDataDic.valueForKey("Total") as?String
        cell.statusresultlabel.text = "Placed"
        cell.placedonresultlabel.text = orederDataDic.valueForKey("createdOn") as?String
        cell.selectionStyle = .None
        
        return cell
        
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 3
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        
        //orderstableview.rowHeight = 15.0
        return 3
        
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 100.0
        //return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let productDetails = storyBoard.instantiateViewControllerWithIdentifier("MY_ORDERS") as! MyOrderViewController
        productDetails.orderData = self.ordersArray[indexPath.section] as! NSDictionary
       // self.navigationController?.pushViewController(productDetails, animated: true)
        
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
        
        return true
    }
    
    override  func shouldShowCart() -> Bool{
        
        return true
    }
    

    override func headerTitleText() -> String{
        return "Orders"
    }
    
    override func shouldShowLeftMenu() -> Bool{
        
        return true
    }

    
    
}

