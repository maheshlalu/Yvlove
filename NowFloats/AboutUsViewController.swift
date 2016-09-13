//
//  ViewController.swift
//  NowfloatAboutus
//
//  Created by apple on 13/09/16.
//  Copyright © 2016 apple. All rights reserved.
//

import UIKit

class AboutUsViewController: CXViewController,UITableViewDataSource,UITableViewDelegate {
var nameArray = ["indiadhasgdhjgashjgdjhagsdhjgasdsadsadsadasgfhdgsafhdsjhfghjdsgfjhgdsjhfgjhgdfhgsgfjshdgfhgsdjgfsdgfgsdjgfdsgfgsdjfgsdgfjsdgfjgsdjfgsdgfjshdgfhsgd","america","newzealand"]
    
    
    @IBOutlet weak var aboutuslabel: UILabel!
    @IBOutlet weak var aboutusimageview: UIImageView!
    @IBOutlet weak var aboutustableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "AboutusTableViewCell", bundle: nil)
        self.aboutustableview.registerNib(nib, forCellReuseIdentifier: "AboutusTableViewCell")
        
        self.aboutustableview.rowHeight = UITableViewAutomaticDimension
        self.aboutustableview.estimatedRowHeight = 10.0
        
      self.aboutustableview.backgroundColor = UIColor.lightGrayColor()
        // Do any additional setup after loading the view, typically from a nib.
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        
        return nameArray.count
        
        
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return 1
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = aboutustableview.dequeueReusableCellWithIdentifier("AboutusTableViewCell", forIndexPath: indexPath)as! AboutusTableViewCell
        cell.aboutusDescriptionlabel.text = nameArray[indexPath.section]
        
        cell.aboutusgoogleLabel.backgroundColor = UIColor.clearColor()
        cell.aboutusgoogleLabel.layer.cornerRadius = 12
        cell.aboutusgoogleLabel.layer.borderWidth = 1
        cell.aboutusgoogleLabel.layer.borderColor = UIColor.redColor().CGColor
        
        cell.selectionStyle = .None
        
        
        return cell
        
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
    
    aboutustableview.rowHeight = 5.0
        return 5.0
    
    
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
return UITableViewAutomaticDimension
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

