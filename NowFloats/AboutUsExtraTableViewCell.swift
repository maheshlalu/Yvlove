//
//  AboutUsExtraTableViewCell.swift
//  NowFloats
//
//  Created by Manishi on 9/15/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit

class AboutUsExtraTableViewCell: UITableViewCell {

    @IBOutlet weak var extraTitleLbl: UILabel!
    @IBOutlet weak var extraDescLbl: UILabel!
    @IBOutlet weak var callBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        callBtn.setTitleColor(CXAppConfig.sharedInstance.getAppTheamColor(), for: UIControlState())
        callBtn.backgroundColor = UIColor.clear
        callBtn.layer.cornerRadius = 15
        callBtn.layer.borderWidth = 1
        callBtn.layer.borderColor = CXAppConfig.sharedInstance.getAppTheamColor().cgColor
        callBtn.isHidden = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
