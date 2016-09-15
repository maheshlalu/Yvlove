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
    @IBOutlet weak var orderstableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "ordersTableViewCell", bundle: nil)
        
        self.orderstableview.registerNib(nib, forCellReuseIdentifier: "ordersTableViewCell")
        
        self.orderstableview.rowHeight = UITableViewAutomaticDimension
        self.orderstableview.estimatedRowHeight = 10.0
        self.orderstableview.backgroundColor = UIColor.lightGrayColor()
        
        // Do any additional setup after loading the view, typically from a nib.
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
        
        
        let cell = orderstableview.dequeueReusableCellWithIdentifier("ordersTableViewCell", forIndexPath: indexPath)as! ordersTableViewCell
        cell.selectionStyle = .None
        
        return cell
        
    }
     func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
     {
        
        orderstableview.rowHeight = 15.0
        return 15.0
        
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 100.0
        //return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let productDetails = storyBoard.instantiateViewControllerWithIdentifier("MY_ORDERS") as! MyOrderViewController
        self.navigationController?.pushViewController(productDetails, animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

