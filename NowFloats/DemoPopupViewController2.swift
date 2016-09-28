//
//  DemoPopupViewController2.swift
//  PopupController
//
//  Created by 佐藤 大輔 on 2/4/16.
//  Copyright © 2016 Daisuke Sato. All rights reserved.
//

import UIKit

class DemoPopupViewController2: UIViewController, PopupContentViewController{
    var closeHandler: (() -> Void)?
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var addressLine2TxtField: UITextField!
    @IBOutlet weak var addressLine1TxtField: UITextField!
    @IBOutlet weak var mobileNoTxtField: UITextField!
    
    @IBOutlet weak var okBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.topView.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.view.layer.cornerRadius = 4
    }
    
    class func instance() -> DemoPopupViewController2 {
        let storyboard = UIStoryboard(name: "DemoPopupViewController2", bundle: nil)
        return storyboard.instantiateInitialViewController() as! DemoPopupViewController2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sizeForPopup(popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        return CGSizeMake(280, 300)
    }
    @IBAction func okButtonAction(sender: AnyObject) {
        closeHandler?()
    }
    

}


