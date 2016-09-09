//
//  NowfloatsCartViewTableViewCell.swift
//  NowfloatsCartView
//
//  Created by Rama kuppa on 31/08/16.
//  Copyright © 2016 Mahesh. All rights reserved.
//

import UIKit

class NowfloatsCartViewTableViewCell: UITableViewCell {
    @IBOutlet var stepperLabel: UILabel!
    
    @IBOutlet var stepper: UIStepper!
    @IBAction func stepperAction(sender: UIStepper) {
        
        
        stepperLabel.text = Int(sender.value).description
        
     
    }
    
    @IBOutlet var wishlist: UIButton!
   
    
    @IBOutlet var nameimageView: UIImageView!
    @IBOutlet var priceLabel: UILabel!

    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    
    
    
    
    @IBAction func plusbuttonAction(sender: UIButton) {
        
    

    }
    
    
    
    
    
    @IBAction func minusbuttonAction(sender: UIButton) {
        
        
    }
    
    
    @IBAction func wishlistbuttonAction(sender: UIButton) {
    }
    
    @IBAction func deletebuttonAction(sender: UIButton) {
    }
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.wishlist.imageView?.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
        self.wishlist.setTitleColor(CXAppConfig.sharedInstance.getAppTheamColor(), forState: UIControlState.Normal)
        
        
        /*[self.stepper setMinimumValue:0];
         [self.stepper setContinuous:YES];
         [self.stepper setWraps:NO];
         [self.stepper setStepValue:1];
         [self.stepper setMaximumValue:300];*/
        
        stepper.wraps = true
        stepper.autorepeat = true
        stepper.maximumValue = 10
        
        // Configure the view for the selected state
    }
    
}
