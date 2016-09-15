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
    @IBOutlet weak var productsCountLbl: UILabel!
    @IBOutlet weak var totalPriceLbl: UILabel!
    var totalPriceString:NSString!
    
    @IBOutlet var collectionview: UICollectionView!
    var products: NSArray!
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "NowfloatscartViewCollectionViewCell", bundle: nil)
        self.collectionview.registerNib(nib, forCellWithReuseIdentifier: "NowfloatscartViewCollectionViewCell")
        getTheProducts()
        
        self.productsCountLbl.text = "\(self.products.count) Products"
        
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
        
        cell.cartviewimagetitlelabel.font = CXAppConfig.sharedInstance.appLargeFont()
        cell.cartviewpricelabel.font = CXAppConfig.sharedInstance.appLargeFont()
        
        
        let rupee = "\u{20B9}"
        
        let price = CXDataProvider.sharedInstance.getJobID("MRP", inputDic: products.json!)
        
        cell.cartviewpricelabel.text = "\(rupee)\(price)"
        
        
//        cell.shareBtn.tag = indexPath.section+1
//        cell.shareBtn.addTarget(self, action: #selector(UpdatesViewController.shareBtnAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        cell.cartdeletebutton.tag = indexPath.section+1
        cell.cartdeletebutton.addTarget(self, action: #selector(CartViewController.cartDeleteBtnAction(_:)), forControlEvents: .TouchUpInside)
        
    return cell
  
    }
    func cartDeleteBtnAction(button : UIButton!){
       // let updateDic : NSDictionary = self.p[button.tag-1] as! NSDictionary
      //  array.removeAtIndex(indexPath.section)
        //self.collectionview.deleteItemsAtIndexPaths([indexPath])

        print("delete the cell");
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func checkoutNowBtn(sender: UIButton) {
        
        PopupController
            .create(self)
            .customize(
                [
                    .Animation(.SlideUp),
                    .Scrollable(false),
                    .Layout(.Center),
                    .BackgroundStyle(.BlackFilter(alpha: 0.7))
                ]
            )
            .didShowHandler { popup in
                print("showed popup!")
            }
            .didCloseHandler { _ in
                print("closed popup!")
            }
            .show(DemoPopupViewController2.instance())
        
    }

}

