//
//  MyordersTableViewCell.swift
//  NowfloatsMyorders
//
//  Created by apple on 14/09/16.
//  Copyright © 2016 apple. All rights reserved.
//

import UIKit

class MyordersTableViewCell: UITableViewCell {

    @IBOutlet weak var placedButton: UIButton!
    @IBOutlet weak var orederPlacedonLabel: UILabel!
    @IBOutlet weak var orderPriceLabel: UILabel!
    @IBOutlet weak var orderdidLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.placedButton.backgroundColor = UIColor.clearColor()
        self.placedButton.layer.cornerRadius = 19
        self.placedButton.layer.borderWidth = 2
        self.placedButton.layer.borderColor = UIColor.init(colorLiteralRed: 61.0/255.0, green: 130.0/255.0, blue: 41.0/255.0, alpha: 1).CGColor
        
        
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
