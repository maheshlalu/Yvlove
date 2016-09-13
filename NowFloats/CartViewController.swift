//
//  ViewController.swift
//  CartView
//
//  Created by Rama kuppa on 12/09/16.
//  Copyright © 2016 Mahesh. All rights reserved.
//

import UIKit

class CartViewController: CXViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    
    @IBOutlet weak var checkOutNowBtn: UIButton!
    
    @IBOutlet var collectionview: UICollectionView!
    var products: NSArray!
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.collectionview.backgroundColor = UIColor.lightGrayColor()
        let nib = UINib(nibName: "NowfloatscartViewCollectionViewCell", bundle: nil)
        
        self.collectionview.registerNib(nib, forCellWithReuseIdentifier: "NowfloatscartViewCollectionViewCell")
        getTheProducts()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func getTheProducts(){
        let fetchRequest : NSFetchRequest = NSFetchRequest(entityName: "CX_Products")
        self.products  = CX_Products.MR_executeFetchRequest(fetchRequest)
        self.collectionview.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        
      return self.products.count
        
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        
        
        let cell = collectionview.dequeueReusableCellWithReuseIdentifier("NowfloatscartViewCollectionViewCell", forIndexPath: indexPath)as! NowfloatscartViewCollectionViewCell
        
        cell.cartviewminusbutton.backgroundColor = UIColor.lightGrayColor()
        cell.cartviewminusbutton.layer.cornerRadius = 9
        cell.cartviewminusbutton.layer.borderWidth = 1
        cell.cartviewminusbutton.layer.borderColor = UIColor.clearColor().CGColor
        
        
        
        cell.cartviewplusbutton.backgroundColor = UIColor.lightGrayColor()
        cell.cartviewplusbutton.layer.cornerRadius = 9
        cell.cartviewplusbutton.layer.borderWidth = 1
        cell.cartviewplusbutton.layer.borderColor = UIColor.clearColor().CGColor
        
        cell.cartviewLabel.layer.cornerRadius = 5.0
        cell.cartviewLabel.layer.borderWidth=1
        cell.cartviewLabel.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        let products:CX_Products = (self.products[indexPath.item]as?
            CX_Products)!
        
        cell.cartviewimagetitlelabel.text = products.name
        
        cell.cartviewimage.sd_setImageWithURL(NSURL(string: products.imageUrl!))
        
        
       // cell.wishlistdescriptionLabel.font =  CXAppConfig.sharedInstance.appMediumFont()
        
        cell.cartviewimagetitlelabel.font = CXAppConfig.sharedInstance.appLargeFont()
        cell.cartviewpricelabel.font = CXAppConfig.sharedInstance.appLargeFont()
        
        
        let rupee = "\u{20B9}"
        
        let price = CXDataProvider.sharedInstance.getJobID("MRP", inputDic: products.json!)
        
        cell.cartviewpricelabel.text = "\(rupee)\(price)"
        
       // cell.cartviewimagetitlelabel.text = nameArray[indexPath.item]
    return cell
        
        
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

