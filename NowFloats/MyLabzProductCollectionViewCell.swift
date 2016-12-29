//
//  MyLabzProductCollectionViewCell.swift
//  NowFloats
//
//  Created by Manishi on 12/28/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit

class MyLabzProductCollectionViewCell: UICollectionViewCell {

    @IBOutlet var productpriceLabel: UILabel!
    @IBOutlet var productdescriptionLabel: UILabel!
    @IBOutlet var produstimageview: UIImageView!
    @IBOutlet weak var productFinalPriceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
