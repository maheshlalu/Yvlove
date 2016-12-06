//
//  UpdateTableViewCell.swift
//  updateScreen
//
//  Created by Rama kuppa on 30/08/16.
//  Copyright © 2016 Mahesh. All rights reserved.
//

import UIKit

class UpdateTableViewCell: UITableViewCell {
    
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet var monthLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var nameimageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
       
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
