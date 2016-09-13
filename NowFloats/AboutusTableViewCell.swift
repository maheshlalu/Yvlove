//
//  AboutusTableViewCell.swift
//  NowfloatAboutus
//
//  Created by apple on 13/09/16.
//  Copyright © 2016 apple. All rights reserved.
//

import UIKit

class AboutusTableViewCell: UITableViewCell {

    @IBOutlet weak var aboutusgoogleLabel: UIButton!
    @IBOutlet weak var aboutuskmLabel: UILabel!
    @IBOutlet weak var aboutusrootLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var aboutusDescriptionlabel: UILabel!
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
