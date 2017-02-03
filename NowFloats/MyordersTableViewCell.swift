//
//  MyordersTableViewCell.swift
//  NowfloatsMyorders
//
//  Created by apple on 14/09/16.
//  Copyright © 2016 apple. All rights reserved.
//

import UIKit

class MyordersTableViewCell: UITableViewCell {

    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var orederPlacedonLabel: UILabel!
    @IBOutlet weak var orderPriceLabel: UILabel!
    @IBOutlet weak var orderdidLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.statusLbl.backgroundColor = UIColor.clear
        self.statusLbl.layer.cornerRadius = 19
        self.statusLbl.layer.borderWidth = 2
        self.statusLbl.layer.borderColor = UIColor.init(colorLiteralRed: 61.0/255.0, green: 130.0/255.0, blue: 41.0/255.0, alpha: 1).cgColor
        
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
