//
//  ViewController.swift
//  NowfloatsCartView
//
//  Created by Rama kuppa on 31/08/16.
//  Copyright © 2016 Mahesh. All rights reserved.
//

import UIKit

class CartViewController: CXViewController,UITableViewDataSource,UITableViewDelegate {
    var products: NSArray!
    @IBOutlet var tableview: UITableView!
    @IBOutlet weak var cartProductsCountLbl: UILabel!
    @IBOutlet weak var totalCartProductsPriceLabel: UILabel!
    @IBOutlet weak var cartCheckOutNowBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "NowfloatsCartViewTableViewCell", bundle: nil)
        self.tableview.registerNib(nib, forCellReuseIdentifier: "NowfloatsCartViewTableViewCell")
        getTheProducts()
        
        self.tableview.rowHeight = UITableViewAutomaticDimension
        self.tableview.estimatedRowHeight = 10.0
        self.tableview.backgroundColor = UIColor.lightGrayColor()
        /*[self.stepper setMinimumValue:0];
        [self.stepper setContinuous:YES];
        [self.stepper setWraps:NO];
        [self.stepper setStepValue:1];
        [self.stepper setMaximumValue:300];*/
        // Do any additional setup after loading the view, typically from a nib.
    }
    func getTheProducts(){
        let fetchRequest : NSFetchRequest = NSFetchRequest(entityName: "CX_Products")
        self.products  = CX_Products.MR_executeFetchRequest(fetchRequest)
        self.tableview.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return self.products.count
        
    }
    

    @IBAction func cartCheckoutBtnAction(sender: UIButton) {
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return 1
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableview.dequeueReusableCellWithIdentifier("NowfloatsCartViewTableViewCell", forIndexPath: indexPath)as! NowfloatsCartViewTableViewCell
     
        /*cell.plusbutton.backgroundColor = UIColor.lightGrayColor()
        cell.plusbutton.layer.cornerRadius = 11
        cell.plusbutton.layer.borderWidth = 1
        cell.plusbutton.layer.borderColor = UIColor.clearColor().CGColor
        
        cell.minusbutton.backgroundColor = UIColor.lightGrayColor()
        cell.minusbutton.layer.cornerRadius = 11
        cell.minusbutton.layer.borderWidth = 1
        cell.minusbutton.layer.borderColor = UIColor.clearColor().CGColor
        
        cell.textfieldLabel.layer.cornerRadius = 13.0
        cell.textfieldLabel.layer.borderWidth=1
        cell.textfieldLabel.layer.borderColor = UIColor.lightGrayColor().CGColor*/
        let products:CX_Products = (self.products[indexPath.section]as? CX_Products)!
        cell.nameimageView.sd_setImageWithURL(NSURL(string: products.imageUrl!))
        cell.descriptionLabel.font = CXAppConfig.sharedInstance.appMediumFont()
       
        let rupee = "\u{20B9}"
        
        let price = CXDataProvider.sharedInstance.getJobID("MRP", inputDic: products.json!)
        
        let discount:String = CXDataProvider.sharedInstance.getJobID("DiscountAmount", inputDic: products.json!)
        
        let finalPriceNum:Int = Int(price)!-Int(discount)!
        cell.priceLabel.text = "\(rupee) \(String(finalPriceNum))"
        cell.priceLabel.font =  CXAppConfig.sharedInstance.appSmallFont()
        cell.descriptionLabel.text = products.name
        tableView.allowsSelection = false
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

