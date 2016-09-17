//
//  EnquiryTableViewCell.swift
//  Nowfloatsenquiry
//
//  Created by Rama kuppa on 15/09/16.
//  Copyright © 2016 Mahesh. All rights reserved.
//

import UIKit

class EnquiryTableViewCell: UITableViewCell {

    @IBAction func enquiry1buttonAction(sender: UIButton) {
    }
    @IBAction func enquiry0buttonAction(sender: UIButton) {
    }
   
    @IBOutlet var enquiryUIview1: UIView!
    @IBOutlet var enquiryUIview: UIView!
    @IBOutlet var enquirylabel: UILabel!
    @IBOutlet var enquiryItemorderTimelabel: UILabel!
    @IBOutlet var enquiryfpldTextlabel: UILabel!
    @IBOutlet var enquiryfpldLabel: UILabel!
    @IBOutlet var enquirymessageTextlabel: UILabel!
    @IBOutlet var enquirymessagelabel: UILabel!
    @IBOutlet var enquiryActivebutton: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
