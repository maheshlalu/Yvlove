//
//  NowfloatWishlistTableViewCell.swift
//  NowfloatsCartView
//
//  Created by Rama kuppa on 01/09/16.
//  Copyright © 2016 Mahesh. All rights reserved.
//

import UIKit

class NowfloatWishlistTableViewCell: UITableViewCell {
    @IBOutlet var strippricelabel: UILabel!
    @IBOutlet var wishlistPriceLabel: UILabel!

    @IBAction func wishlistdeletebuttonAction(sender: UIButton) {
    }
    @IBAction func addtocartbuttonAction(sender: UIButton) {
    }
    @IBOutlet var wishlistuiview: UIView!
    @IBOutlet var wishlistdescriptionLabel: UILabel!
    
    @IBOutlet var iconimageView: UIImageView!
    
   
    @IBOutlet var wishlistaddtocartbtn: UIButton!
   
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.wishlistaddtocartbtn.imageView?.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
        self.wishlistaddtocartbtn.setTitleColor(CXAppConfig.sharedInstance.getAppTheamColor(), forState: UIControlState.Normal)
        self.wishlistdescriptionLabel.font = CXAppConfig.sharedInstance.appLargeFont()
        
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
