//
//  BookingCollectionViewCell.swift
//  AnimationsProject
//
//  Created by Rama on 07/09/17.
//  Copyright © 2017 ongoStore. All rights reserved.
//

import UIKit

protocol BookingSlotDelegate {
    
    func didSelectSlot(cellObject:Any)
}

class BookingCollectionViewCell: UICollectionViewCell {

    @IBOutlet var timeSlotLbl: UILabel!
    
    @IBOutlet var timeSlotBtn: UIButton!
    var delegate : BookingSlotDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.timeSlotBtn.layer.cornerRadius = 5
        self.timeSlotBtn.layer.borderWidth = 1
        self.timeSlotBtn.layer.borderColor = UIColor.init(red: 37/255.0, green: 151/255.0, blue: 126/255.0, alpha: 1).cgColor
        self.timeSlotBtn.layer.masksToBounds = true
        self.timeSlotBtn.clipsToBounds = true
        // Initialization code
        
       
    }
    func unSelectButtons()
    {
        for btn in [timeSlotBtn] {
            btn?.isUserInteractionEnabled = true
            btn?.layer.borderColor = UIColor.init(red: 37/255.0, green: 151/255.0, blue: 126/255.0, alpha: 1).cgColor
            btn?.backgroundColor = UIColor.clear
        }
    }

    @IBAction func timeSlotBtnAction(_ sender: UIButton) {
      // unSelectButtons()
        
       /* if (self.delegate != nil) {
            self.delegate.didSelectSlot(cellObject: self)
        }*/
       /* print(sender.tag)
       self.timeSlotBtn.layer.borderColor = UIColor.init(red: 222/255.0, green: 179/255.0, blue: 43/255.0, alpha: 1).cgColor
        self.timeSlotBtn.setTitleColor(UIColor.init(red: 222/255.0, green: 179/255.0, blue: 43/255.0, alpha: 1), for: .normal)
        self.timeSlotBtn.backgroundColor = UIColor.init(red: 222/255.0, green: 179/255.0, blue: 43/255.0, alpha: 0.1)*/
        
        
        
        
        
        
        

        
    }
    
}
