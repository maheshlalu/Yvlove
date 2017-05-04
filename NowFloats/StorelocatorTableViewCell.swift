//
//  StorelocatorTableViewCell.swift
//  NowFloats
//
//  Created by Rama kuppa on 02/05/17.
//  Copyright © 2017 CX. All rights reserved.
//

import UIKit

class StorelocatorTableViewCell: UITableViewCell {
    @IBOutlet weak var mobileNumberLabel: UILabel!
   
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var citeNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var mapBtn: UIButton!
    
    
    
}
