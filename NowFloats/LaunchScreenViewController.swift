//
//  LaunchScreenViewController.swift
//  NowFloats
//
//  Created by Manishi on 10/4/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit

class LaunchScreenViewController: UIViewController {

    @IBOutlet weak var launchImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()

        //launchImage.image =
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
}
