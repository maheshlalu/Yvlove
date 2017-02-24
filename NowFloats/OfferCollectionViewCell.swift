//
//  OfferCollectionViewCell.swift
//  NowFloats
//
//  Created by apple on 02/09/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit

class OfferCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var finalPriceLbl: UILabel!
    @IBOutlet weak var productPriceLbl: UILabel!
    @IBOutlet weak var orderNowBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.orderNowBtn.setTitleColor(CXAppConfig.sharedInstance.getAppTheamColor(), for: UIControlState())
        self.orderNowBtn.titleLabel?.font = CXAppConfig.sharedInstance.appLargeFont()

//        self.productImageView.layer.borderWidth = 3.0
//        self.productImageView.layer.borderColor = UIColor.red.cgColor
//        self.productImageView.layer.cornerRadius = 10.0
        self.finalPriceLbl.font = CXAppConfig.sharedInstance.appMediumFont()
       // self.productPriceLbl.font = CXAppConfig.sharedInstance.appMediumFont()
        self.productName.font = CXAppConfig.sharedInstance.appLargeFont()

    }

}
