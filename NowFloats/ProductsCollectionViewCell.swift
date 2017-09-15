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
    @IBOutlet weak var askAQuoteBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.cartaddedbutton.setTitleColor(CXAppConfig.sharedInstance.getAppTheamColor(), for: UIControlState())
        self.cartaddedbutton.imageView?.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
        self.cartaddedbutton.backgroundColor = UIColor.white
        self.cartaddedbutton.layer.cornerRadius = 12
        self.cartaddedbutton.layer.borderWidth = 1
        self.cartaddedbutton.layer.borderColor = CXAppConfig.sharedInstance.getAppTheamColor().cgColor
        
        self.productpriceLabel.textColor = CXAppConfig.sharedInstance.getAppTheamColor()        
    }
}
