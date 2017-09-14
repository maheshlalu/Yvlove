//
//  MyAppointmentTableViewCell.swift
//  NowFloats
//
//  Created by Rama kuppa on 07/09/17.
//  Copyright © 2017 CX. All rights reserved.
//

import UIKit

class MyAppointmentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageVIew:UIImageView!

    @IBOutlet weak var doctorNameLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
}
