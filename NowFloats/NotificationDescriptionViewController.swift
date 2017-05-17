//
//  NotificationDescriptionViewController.swift
//  NowFloats
//
//  Created by Rama kuppa on 17/05/17.
//  Copyright © 2017 CX. All rights reserved.
//

import UIKit

class NotificationDescriptionViewController: UIViewController {
    
    var dict = NSDictionary()
    @IBOutlet weak var headingLabel: UILabel!

    @IBOutlet weak var discrLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 228/255.0, green: 49/255.0, blue: 44/255.0, alpha: 1.0)
        self.navigationItem.title = dict.value(forKey: "Name") as? String
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        self.headingLabel.text = dict.value(forKey: "Name") as? String
        self.discrLabel.text = dict.value(forKey: "Description") as? String
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        let menuItem = UIBarButtonItem(image: UIImage(named: "LeftArrow"), style: .plain, target: self, action: #selector(NotificationDescriptionViewController.backBtnClicked))
        self.navigationItem.leftBarButtonItem = menuItem
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    func backBtnClicked(){
        self.dismiss(animated: true, completion: nil)
    }
  
}
