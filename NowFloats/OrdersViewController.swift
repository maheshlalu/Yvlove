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
        
        self.orderstableview.register(nib, forCellReuseIdentifier: "ordersTableViewCell")
        
        self.orderstableview.rowHeight = UITableViewAutomaticDimension
        self.orderstableview.estimatedRowHeight = 10.0
        self.orderstableview.backgroundColor = UIColor.clear
        self.view.backgroundColor = CXAppConfig.sharedInstance.getAppBGColor()
        
        CXAppDataManager.sharedInstance.getOrders { (responseDict) in
            //  print("print the my orders \(responseDict)")
            let jobs : NSArray =  responseDict.value(forKey: "jobs")! as! NSArray
            self.ordersArray = jobs
            self.orderstableview.reloadData()
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        
        return ordersArray.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return 1
        
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        
        let cell = orderstableview.dequeueReusableCell(withIdentifier: "ordersTableViewCell", for: indexPath)as! ordersTableViewCell
        cell.backgroundView?.backgroundColor = UIColor.clear
        let orederDataDic : NSDictionary = self.ordersArray[indexPath.section] as! NSDictionary
        cell.orderidresultlabel.text = CXConstant.resultString(orederDataDic.value(forKey: "id")! as AnyObject)
        cell.orderpriceresultlabel.text = orederDataDic.value(forKey: "Total") as?String
        cell.statusresultlabel.text = "Placed"
        cell.placedonresultlabel.text = orederDataDic.value(forKey: "createdOn") as?String
        cell.selectionStyle = .none
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 3
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        
        //orderstableview.rowHeight = 15.0
        return 3
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100.0
        //return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let orederDataDic : NSDictionary = self.ordersArray[indexPath.section] as! NSDictionary
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let productDetails = storyBoard.instantiateViewController(withIdentifier: "MY_ORDERS") as! MyOrderViewController
        
        productDetails.orderData = self.ordersArray[indexPath.section] as! NSDictionary
        
        productDetails.orderIdStr = CXConstant.resultString(orederDataDic.value(forKey: "id")! as AnyObject)
        productDetails.priceStr = orederDataDic.value(forKey: "Total") as?String
        productDetails.placedStr = orederDataDic.value(forKey: "createdOn") as?String
        
        self.navigationController?.pushViewController(productDetails, animated: true)
        
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
    override func showLogoForAboutUs() -> Bool{
        return false
    }
    
    override func shouldShowLeftMenuWithLogo() -> Bool{
        
        return false
    }
    
    override func profileDropdown() -> Bool{
        return false
    }
    
    override func profileDropdownForSignIn() -> Bool{
        return false
    }

    
    
}

