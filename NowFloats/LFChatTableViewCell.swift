//
//  LFChatTableViewCell.swift
//  Lefoodie
//
//  Created by apple on 24/03/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class LFChatTableViewCell: UITableViewCell {

    @IBOutlet weak var chatDscrLbl: UILabel!
    @IBOutlet weak var chatTimeLbl: UILabel!
    @IBOutlet weak var chatNameLbl: UILabel!
    @IBOutlet weak var chatImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
