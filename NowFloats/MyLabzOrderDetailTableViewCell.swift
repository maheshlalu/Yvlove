//
//  MyLabzOrderDetailTableViewCell.swift
//  NowFloats
//
//  Created by Manishi on 12/16/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit

class MyLabzOrderDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var orderIdLbl: UILabel!
    @IBOutlet weak var orderIdTxtLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var priceTxtLbl: UILabel!
    @IBOutlet weak var placedDateLbl: UILabel!
    @IBOutlet weak var placedOnTxtLbl: UILabel!
    @IBOutlet weak var collectionTimeLbl: UILabel!
    @IBOutlet weak var collectionTimeTxtLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.orderIdLbl.textColor = CXAppConfig.sharedInstance.getAppTheamColor()
        
        self.statusLbl.layer.cornerRadius = 17.5
        self.statusLbl.layer.borderColor = UIColor(red: 87.0/255.0, green: 146.0/255.0, blue: 33.0/255.0, alpha: 1.0).cgColor
        self.statusLbl.layer.borderWidth = 2
        self.statusLbl.clipsToBounds = true
        
        self.priceLbl.textColor = CXAppConfig.sharedInstance.getAppTheamColor()
        self.placedDateLbl.textColor = CXAppConfig.sharedInstance.getAppTheamColor()
        self.collectionTimeLbl.textColor = CXAppConfig.sharedInstance.getAppTheamColor()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
