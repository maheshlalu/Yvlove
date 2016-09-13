///
//  NowfloatscartViewCollectionViewCell.swift
//  CartView
//
//  Created by Rama kuppa on 12/09/16.
//  Copyright © 2016 Mahesh. All rights reserved.
//

import UIKit

class NowfloatscartViewCollectionViewCell: UICollectionViewCell {
    
    
    
    @IBOutlet var cartdeletebutton: UIButton!
    @IBOutlet var cartwishlistbutton: UIButton!

    @IBOutlet var cartviewplusbutton: UIButton!

    @IBOutlet var cartviewminusbutton: UIButton!
    @IBAction func cartviewdeletebuttonAction(sender: UIButton) {
    }
    @IBAction func cartviewwishlistbuttonAction(sender: UIButton) {
    }
    @IBOutlet var cartviewpricelabel: UILabel!
    @IBOutlet var cartviewuiview1: UIView!
    @IBOutlet var cartviewuiview: UIView!
    @IBAction func cartviewplusbuttonAction(sender: UIButton) {
    }
    @IBOutlet var cartviewLabel: UILabel!
    @IBAction func cartviewminusbuttonAction(sender: UIButton) {
    }
    @IBOutlet var cartviewquantity: UILabel!
    @IBOutlet var cartviewimagetitlelabel: UILabel!
    @IBOutlet var cartviewimage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
//self.cartwishlistbutton.imageView?.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
        //self.cartwishlistbutton.setTitleColor(CXAppConfig.sharedInstance.getAppTheamColor(), forState: UIControlState.Normal)
        
        self.cartwishlistbutton.imageView?.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
        self.cartwishlistbutton.setTitleColor(CXAppConfig.sharedInstance.getAppTheamColor(), forState: UIControlState.Normal)
        
        // Initialization code
    }

}
