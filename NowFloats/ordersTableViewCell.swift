//
//  ordersTableViewCell.swift
//  Nowfloatorders
//
//  Created by apple on 13/09/16.
//  Copyright © 2016 apple. All rights reserved.
//

import UIKit

class ordersTableViewCell: UITableViewCell {

    @IBOutlet weak var statusresultlabel: UILabel!
    @IBOutlet weak var orderstatuslabel: UILabel!
    @IBOutlet weak var orderpriceresultlabel: UILabel!
    @IBOutlet weak var orderpricelabel: UILabel!
    @IBOutlet weak var placedonresultlabel: UILabel!
    @IBOutlet weak var orderplacedonlabel: UILabel!
    @IBOutlet weak var orderidresultlabel: UILabel!
    @IBOutlet weak var urderidlabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
