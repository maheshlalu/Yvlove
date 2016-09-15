//
//  HistoryTableViewCell.swift
//  MessageEnquiry
//
//  Created by apple on 14/09/16.
//  Copyright © 2016 apple. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var historylabel2: UILabel!
    @IBOutlet weak var historylabel1: UILabel!
    @IBOutlet weak var historymonthlabel: UILabel!
    @IBAction func historybuttonAction(sender: UIButton) {
    }
    @IBOutlet weak var historynameLabel: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
