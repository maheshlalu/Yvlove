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
    @IBOutlet weak var aboutusDescriptionlabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        aboutuskmLabel.textColor = CXAppConfig.sharedInstance.getAppTheamColor()
    
        aboutusgoogleLabel.setTitleColor(CXAppConfig.sharedInstance.getAppTheamColor(), forState: .Normal)
        aboutusgoogleLabel.backgroundColor = UIColor.clearColor()
        aboutusgoogleLabel.layer.cornerRadius = 12
        aboutusgoogleLabel.layer.borderWidth = 1
        aboutusgoogleLabel.layer.borderColor = CXAppConfig.sharedInstance.getAppTheamColor().CGColor
        aboutusgoogleLabel.hidden = true
        aboutuskmLabel.hidden = true
        

    }

   
    
}
