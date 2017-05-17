//
//  NotificationTableViewCell.swift
//  NowFloats
//
//  Created by Rama kuppa on 17/05/17.
//  Copyright © 2017 CX. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!

    @IBOutlet weak var desc: UILabel!
    
    @IBOutlet weak var date: UILabel!
    
    
    @IBOutlet weak var viewMoreBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
