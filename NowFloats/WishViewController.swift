//
//  ViewController.swift
//  NowfloatsWishlist
//
//  Created by Rama kuppa on 09/09/16.
//  Copyright © 2016 Mahesh. All rights reserved.
//

import UIKit

class WishViewController: CXViewController,UITableViewDataSource,UITableViewDelegate {
    var products: NSArray!
    @IBOutlet var wishtableView: UITableView!
    var nameArray = ["indiasahdggfhjasgfjhdghsgdhgsjhdgjshgdghas","newzealand","america","england","india","newzealand","america","england","india","newzealand","america","england"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let nib = UINib(nibName: "NowfloatWishlistTableViewCell", bundle: nil)
        self.wishtableView.registerNib(nib, forCellReuseIdentifier: "NowfloatWishlistTableViewCell")
        //self.tableview.rowHeight = UITableViewAutomaticDimension
        //self.tableview.estimatedRowHeight = 10.0
        self.wishtableView.rowHeight = UITableViewAutomaticDimension
        self.wishtableView.estimatedRowHeight = 10.0
        
        self.wishtableView.backgroundColor = UIColor.lightGrayColor()
        getTheProducts()
        // Do any additional setup after loading the view, typically from a nib.
    }
    func getTheProducts(){
        let fetchRequest : NSFetchRequest = NSFetchRequest(entityName: "CX_Products")
        self.products  = CX_Products.MR_executeFetchRequest(fetchRequest)
        self.wishtableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {

        return self.products.count

    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return 1
        
        
    }
        
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell = wishtableView.dequeueReusableCellWithIdentifier("NowfloatWishlistTableViewCell", forIndexPath: indexPath)as! NowfloatWishlistTableViewCell
        
        //plusbutton.backgroundColor = UIColor.()
        //plusbutton.layer.cornerRadius = 10
        //plusbutton.layer.borderWidth = 1
        //plusbutton.layer.borderColor = UIColor.blackColor().CGColor
        /*cell.plusbutton.backgroundColor = UIColor.lightGrayColor()
         cell.plusbutton.layer.cornerRadius = 11
         cell.plusbutton.layer.borderWidth = 1
         cell.plusbutton.layer.borderColor = UIColor.clearColor().CGColor*/
        
        
        
        
        /*cell.minusbutton.backgroundColor = UIColor.lightGrayColor()
         cell.minusbutton.layer.cornerRadius = 11
         cell.minusbutton.layer.borderWidth = 1
         cell.minusbutton.layer.borderColor = UIColor.clearColor().CGColor
         cell.descriptionLabel.text = nameArray[indexPath.section]*/
        
        
        //nameOfTextField.layer.cornerRadius = 15.0
        //nameOfTextField.layer.borderWidth = 2.0
        //nameOfTextField.layer.borderColor = UIColor.redColor().CGColor
        //tableView.contentInset = UIEdgeInsetsMake(0, 0, 0,0)
        /*cell.textfieldLabel.layer.cornerRadius = 13.0
         cell.textfieldLabel.layer.borderWidth=1
         cell.textfieldLabel.layer.borderColor = UIColor.lightGrayColor().CGColor*/
        
        
       // [08/09/16, 4:59:19 PM] Suresh Kumar Yadavalli: let rupee = "\u{20B9}"
        //[08/09/16, 5:00:42 PM] Suresh Kumar Yadavalli: cell.productpriceLabel.text = "\(rupee) \(price)"
        //let rupee = "\u{20B9}"
        //let price = "20000"
        
        //cell.wishlistPriceLabel.text = "\(rupee)\(price)"
        
        //cell.wishlistdescriptionLabel.text = nameArray[indexPath.section]
        
        let products:CX_Products = (self.products[indexPath.section]as?
            CX_Products)!
        
        cell.wishlistdescriptionLabel.text = products.name
        
        cell.iconimageView.sd_setImageWithURL(NSURL(string: products.imageUrl!))
        
        let rupee = "\u{20B9}"
        
        let price = CXDataProvider.sharedInstance.getJobID("MRP", inputDic: products.json!)
        
        let discount:String = CXDataProvider.sharedInstance.getJobID("DiscountAmount", inputDic: products.json!)
        
        let finalPriceNum:Int = Int(price)!-Int(discount)!
        cell.wishlistPriceLabel.text = "\(rupee) \(String(finalPriceNum))"
        tableView.allowsSelection = false
        cell.wishlistdescriptionLabel.font =  CXAppConfig.sharedInstance.appMediumFont()
       // cell.wishlistdescriptionLabel.text = nameArray[indexPath.section]
        return cell
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        // tableView.rowHeight = 125.0
        //return 145.0
        return UITableViewAutomaticDimension
        
    }
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        
        return UITableViewAutomaticDimension
        
        
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        
        return 7.0
        
        
    }
    /*func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath)
     {
     
     self.tableView.contentInset = UIEdgeInsetsMake(-10, -5, -10, -5)
     
     
     }*/
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

