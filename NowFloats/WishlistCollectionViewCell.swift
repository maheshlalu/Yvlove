//
//  WishlistCollectionViewCell.swift
//  Nowfloatwishlist
//
//  Created by apple on 13/09/16.
//  Copyright © 2016 apple. All rights reserved.
//

import UIKit

class WishlistCollectionViewCell: UICollectionViewCell {


    @IBOutlet var wishlistView: UIView!
    @IBOutlet weak var wishlistdeletebutton: UIButton!
    @IBOutlet weak var wishlistaddtocartbutton: UIButton!
    @IBOutlet weak var wishlistpricelabel: UILabel!
    @IBOutlet weak var imagetitleLabel: UILabel!
    @IBOutlet weak var wishlistimageview: UIImageView!
    @IBOutlet weak var mrpLbl: UILabel!
    @IBOutlet weak var discountBdgeLb: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        self.wishlistaddtocartbutton.imageView?.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
        self.wishlistaddtocartbutton.setTitleColor(CXAppConfig.sharedInstance.getAppTheamColor(), forState: UIControlState.Normal)
 

        
        
        // Initialization code
    }

}
