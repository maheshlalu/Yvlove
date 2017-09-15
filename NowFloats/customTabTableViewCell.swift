//
//  customTabTableViewCell.swift
//  NowFloats
//
//  Created by Rama on 15/09/17.
//  Copyright © 2017 CX. All rights reserved.
//

import UIKit

class customTabTableViewCell: UITableViewCell {

    @IBOutlet var nameLbl: UILabel!
    
    @IBOutlet var customWebView: UIWebView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
