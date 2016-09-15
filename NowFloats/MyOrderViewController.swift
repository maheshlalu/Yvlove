//
//  ViewController.swift
//  NowfloatsMyorders
//
//  Created by apple on 14/09/16.
//  Copyright © 2016 apple. All rights reserved.
//

import UIKit

class MyOrderViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var nameArray = ["Order id : 30704","Singapore & Malaysia Package for 06 Nights / 07 Days:[1 items]","pakisthan","newzealand","india","america","pakisthan","newzealand","india","america","pakisthan","newzealand"]
    
    let cellReuseIdentifier = "cell"
    let cellSpacingHeight: CGFloat = 1
    
    @IBOutlet weak var MyorderstableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.MyorderstableView?.registerNib(UINib(nibName: "MyordersTableViewCell", bundle: nil), forCellReuseIdentifier: "MyordersTableViewCell")
        self.MyorderstableView?.registerNib(UINib(nibName: "MyorderTableViewCell1", bundle: nil), forCellReuseIdentifier: "MyorderTableViewCell1")
        
        self.MyorderstableView.rowHeight = UITableViewAutomaticDimension
        self.MyorderstableView.estimatedRowHeight = 10.0
        self.MyorderstableView.backgroundColor = UIColor.lightGrayColor()
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
            
            let myordercell:MyordersTableViewCell! = tableView.dequeueReusableCellWithIdentifier("MyordersTableViewCell") as? MyordersTableViewCell
            myordercell.orderdidLabel?.text = nameArray[indexPath.section]
            myordercell.selectionStyle = .None
            return myordercell
        }else {
            
            let myordercell1:MyorderTableViewCell1! = tableView.dequeueReusableCellWithIdentifier("MyorderTableViewCell1") as? MyorderTableViewCell1
            myordercell1.myorderDescriptionLabel.text = nameArray[indexPath.section]
            myordercell1.selectionStyle = .None
            return myordercell1
        }
        
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        
        return UITableViewAutomaticDimension
        
        
    }
    func tableView(tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat
    {
        
        return 20.0
        
        
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        
        return cellSpacingHeight
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

