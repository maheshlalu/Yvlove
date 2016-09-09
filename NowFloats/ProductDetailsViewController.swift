//
//  ProductDetailsViewController.swift
//  NowFloats
//
//  Created by Manishi on 9/9/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit

class ProductDetailsViewController: CXViewController {

    @IBOutlet weak var productDetailsTableView: UITableView!
    var productString : String!
    override func viewDidLoad() {
        super.viewDidLoad()
//        let nib = UINib(nibName: "", bundle: nil)
//        self.productDetailsTableView.registerNib(nib, forCellReuseIdentifier: "NowfloatsCartViewTableViewCell")
        //getTheProducts()
        
        self.productDetailsTableView.rowHeight = UITableViewAutomaticDimension
        self.productDetailsTableView.estimatedRowHeight = 10.0
        print(CXConstant.sharedInstance.convertStringToDictionary(productString))

    }
    
//    func getTheProducts(){
//        let fetchRequest : NSFetchRequest = NSFetchRequest(entityName: "CX_Products")
//        self.products  = CX_Products.MR_executeFetchRequest(fetchRequest)
//        self.tableview.reloadData()
//    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 4
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return 1
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        //let cell = productDetailsTableView.dequeueReusableCellWithIdentifier("ImageView", forIndexPath: indexPath)
        var cell: UITableViewCell? = nil
        cell?.selectionStyle = .None
        if indexPath.section == 0{
            let imageCellIdentifier = "ImageCell"
            cell = tableView.dequeueReusableCellWithIdentifier(imageCellIdentifier)!
        }else if indexPath.section == 1{
            let headerCellIdentifier = "Headercell"
            cell = tableView.dequeueReusableCellWithIdentifier(headerCellIdentifier)!
            
        }else if indexPath.section == 2{
            let productInfoIdentifier = "ProductInfoCell"
            cell = tableView.dequeueReusableCellWithIdentifier(productInfoIdentifier)!
            
        }else if indexPath.section == 3{
            let footerIdentifier = "FooterCell"
            cell = tableView.dequeueReusableCellWithIdentifier(footerIdentifier)!
            
        }
   
        return cell!
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {

        return UITableViewAutomaticDimension
        
    }
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        
        return UITableViewAutomaticDimension
        
    }

}
