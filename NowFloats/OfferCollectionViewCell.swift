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
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
