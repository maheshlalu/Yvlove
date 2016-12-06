//
//  OfferPagerCelll.swift
//  NowFloats
//
//  Created by apple on 01/09/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit

class OfferPagerCelll: UITableViewCell {

    @IBOutlet weak var pagerView: KIImagePager!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        pagerView.frame = self.frame
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
