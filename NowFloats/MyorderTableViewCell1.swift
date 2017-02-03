//
//  MyorderTableViewCell1.swift
//  NowfloatsMyorders
//
//  Created by apple on 14/09/16.
//  Copyright © 2016 apple. All rights reserved.
//

import UIKit

class MyorderTableViewCell1: UITableViewCell {

    @IBOutlet weak var myorderimageView: UIImageView!
    @IBOutlet weak var myordertotalpriceLabel: UILabel!
    @IBOutlet weak var myorderDescriptionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        myorderimageView.layer.borderColor = UIColor.white.cgColor
        myorderimageView.layer.borderWidth = 3
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
