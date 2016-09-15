//
//  HistoryViewController.swift
//  MessageEnquiry
//
//  Created by apple on 14/09/16.
//  Copyright © 2016 apple. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var historytableview: UITableView!
var nameArray = ["india","america","newzealand","srilanka","india","america","newzealand","srilanka","india","america","newzealand","srilanka"]
    let cellReuseIdentifier = "cell"
    let cellSpacingHeight: CGFloat = 2

    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "HistoryTableViewCell", bundle: nil)
self.historytableview.rowHeight = UITableViewAutomaticDimension
        self.historytableview.estimatedRowHeight = 10.0

self.historytableview.registerNib(nib, forCellReuseIdentifier: "HistoryTableViewCell")
        // Do any additional setup after loading the view.
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
        
        let cell = historytableview.dequeueReusableCellWithIdentifier("HistoryTableViewCell", forIndexPath: indexPath)as! HistoryTableViewCell
       cell.historynameLabel?.text = nameArray[indexPath.section]
        cell.selectionStyle = .None
        return cell
        
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        tableView.rowHeight = 120
        return 120
        
        //return UITableViewAutomaticDimension
    }
     func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
     {
        
        return cellSpacingHeight
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

}
