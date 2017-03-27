//
//  customColorCell.swift
//  NowFloats
//
//  Created by SRINIVASULU on 24/03/17.
//  Copyright © 2017 CX. All rights reserved.
//

import UIKit

class customColorCell: UITableViewCell {

    @IBOutlet weak var checkBtncolor: UIButton!
    @IBOutlet weak var viewColor: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
