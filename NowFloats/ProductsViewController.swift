//
//  ProductsViewController.swift
//  NowFloats
//
//  Created by Mahesh Y on 8/18/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit

class ProductsViewController: CXViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    //let screenSize:CGRect = UIScreen.mainScreen().bounds
    var screenWidth: CGFloat! = nil
    var products: NSArray!
    @IBOutlet var updatecollectionview: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor.clearColor()
        //print("item 1 loaded")

        let nib = UINib(nibName: "ProductsCollectionViewCell", bundle: nil)
        
        self.updatecollectionview.registerNib(nib, forCellWithReuseIdentifier: "ProductsCollectionViewCell")
        getTheProducts()
        
        
        //self.tableView.rowHeight = UITableViewAutomaticDimension
        //self.tableView.estimatedRowHeight = 10.0
        
        
        /* let screenWidth = screenSize.width
         //let screenHeight = screenSize.height
         
         let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
         layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
         layout.itemSize = CGSize(width: screenWidth/2, height: 200)
         updatecollectionview = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
         //self.view.addSubview(updatecollectionview)*/
    }
    
    func getTheProducts(){
        let fetchRequest : NSFetchRequest = NSFetchRequest(entityName: "CX_Products")
        self.products  = CX_Products.MR_executeFetchRequest(fetchRequest)
        self.updatecollectionview.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        
        
        return self.products.count
        
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ProductsCollectionViewCell", forIndexPath: indexPath)as! ProductsCollectionViewCell
        
        
        let products:CX_Products = (self.products[indexPath.item] as? CX_Products)!
        cell.productdescriptionLabel.text = products.name
        cell.produstimageview.sd_setImageWithURL(NSURL(string: products.imageUrl!))
        cell.productdescriptionLabel.sizeToFit()
        
        // Customize cell height
        cell.cartaddedbutton.backgroundColor = UIColor.clearColor()
        cell.cartaddedbutton.layer.cornerRadius = 12
        cell.cartaddedbutton.layer.borderWidth = 1
        cell.cartaddedbutton.layer.borderColor = UIColor.blueColor().CGColor
        
    cell.productdescriptionLabel.font = CXAppConfig.sharedInstance.appMediumFont()
    //CXAppConfig.sharedInstance.getAppTheamColor()
      cell.cartaddedbutton.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
        return cell
        
       
        /*button.backgroundColor = UIColor.clearColor()
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.blackColor().CGColor*/
        
        
        
        
        /*  if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
         let itemWidth = view.bounds.width / 2
         let itemHeight = layout.itemSize.height
         layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
         layout.invalidateLayout()
         }*/
        
        
        
    }
    //     func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets
    //     {
    //
    //        let screenWidth = screenSize.width
    //        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    //        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
    //        layout.itemSize = CGSize(width: screenWidth/2, height: 200)
    //
    //        updatecollectionview = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
    //        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    //       // self.view.addSubview(updatecollectionview)
    //
    //    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        screenWidth =  UIScreen.mainScreen().bounds.size.width
        return CGSize(width: screenWidth/2-11, height: 200);
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    
}
