//
//  ProductsCollectionViewCell.swift
//  NowFloats
//
//  Created by CX_One on 9/1/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit

class ProductsCollectionViewCell: UICollectionViewCell {

  
  
    @IBOutlet var cartaddedbutton: UIButton!
    @IBOutlet var likebutton: UIButton!
    @IBOutlet var productpriceLabel: UILabel!
    @IBOutlet var productdescriptionLabel: UILabel!
    @IBOutlet var produstimageview: UIImageView!
    @IBOutlet weak var productFinalPriceLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.cartaddedbutton.setTitleColor(CXAppConfig.sharedInstance.getAppTheamColor(), forState: .Normal)
        self.cartaddedbutton.imageView?.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
        self.cartaddedbutton.backgroundColor = UIColor.whiteColor()
        self.cartaddedbutton.layer.cornerRadius = 12
        self.cartaddedbutton.layer.borderWidth = 1
        self.cartaddedbutton.layer.borderColor = CXAppConfig.sharedInstance.getAppTheamColor().CGColor
        
        //self.productdescriptionLabel.font = CXAppConfig.sharedInstance.appLargeFont()
        self.productpriceLabel.textColor = CXAppConfig.sharedInstance.getAppTheamColor()
        
    }
    
//    @IBAction func productaddcartAction(sender: UIButton) {
//        sender.selected = !sender.selected
//        if !sender.selected{
//            self.cartaddedbutton.setTitleColor(CXAppConfig.sharedInstance.getAppTheamColor(), forState: .Normal)
//            self.cartaddedbutton.imageView?.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
//            self.cartaddedbutton.backgroundColor = UIColor.whiteColor()
//        }else{
//            self.cartaddedbutton.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
//            self.cartaddedbutton.imageView?.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
//            self.cartaddedbutton.setTitleColor(UIColor.whiteColor(), forState: .Selected)
//        }
//
//    }
    
    @IBAction func productlikebuttonAction(sender: UIButton) {
        sender.selected = !sender.selected
    }


}
