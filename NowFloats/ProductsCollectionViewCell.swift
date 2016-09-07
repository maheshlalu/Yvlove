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
    @IBAction func productaddcartAction(sender: UIButton) {
    }
    @IBOutlet var productpriceLabel: UILabel!
    @IBOutlet var productdescriptionLabel: UILabel!
    @IBAction func productlikebuttonAction(sender: UIButton) {
        
      sender.selected = !sender.selected
    }
    @IBOutlet var produstimageview: UIImageView!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
