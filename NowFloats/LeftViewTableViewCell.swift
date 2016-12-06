//
//  LeftViewTableViewCell.swift
//  NowFloats
//
//  Created by CX_One on 9/1/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit

class LeftViewTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var contentsLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
