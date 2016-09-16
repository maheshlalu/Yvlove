//
//  ProfileViewController.swift
//  NowFloats
//
//  Created by Manishi on 9/14/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit

class ProfileViewController: CXViewController {

    var coordinateManager: MTCoordinateManager?
    var tableView: UITableView!
    let sampleDataArray = NSMutableArray()
    
    var dpImageView:UIImageView! = nil
    let nameLbl:UILabel! = nil
    let emailLbl:UILabel! = nil
    let mobileNoLbl:UILabel! = nil
    let editProfileBtn:UIButton! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupView() {
        tableView = UITableView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height), style:.Plain)
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .None
        tableView.delegate = self
        tableView.dataSource = self
        
        let headerView = UIView.init(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height/3+20))
        headerView.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
        
        // set header view
        coordinateManager = MTCoordinateManager.init(vc: self, scrollView: tableView, header: headerView)
        
        // create view
        let dpView = self.createDPImageView()
        let nameLbl = self.createNameLblView()
        
        // set views
        coordinateManager?.setContainer(tableView, views: dpView, nameLbl)
        
        self.view.addSubview(tableView)
    }
    
    
    // MARK: - scroll event
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        guard let manager = coordinateManager else {
            return
        }
        manager.scrolledDetection(scrollView)
    }
    
    
    // MARK: - crate child view
    
    func createDPImageView() -> MTCoordinateContainer {
        self.dpImageView = UIImageView.init()
        self.dpImageView.image = UIImage(named: "sample-icon")
        let centerX = self.view.frame.width / 2
        let iconSize = 110.f
        let startX = centerX - (iconSize / 2)
        self.dpImageView.frame = CGRectMake(startX, 20, iconSize, iconSize)
        let radius:Float = 0.5
        self.dpImageView.layer.cornerRadius = self.dpImageView.frame.width * radius.f
        self.dpImageView.clipsToBounds = true
        self.dpImageView.layer.masksToBounds = true
        self.dpImageView.layer.borderWidth = 3.f
        self.dpImageView.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8).CGColor
        
        let dpImageView = MTCoordinateContainer.init(view: self.dpImageView, endForm: CGRectMake(centerX, 120, 0, 0), corner: radius, completion: {
            
            })
        return dpImageView
    }
    
    func createNameLblView() -> MTCoordinateContainer{
        let lblView = UILabel.init()
        lblView.frame = CGRectMake(0, self.dpImageView.frame.size.height+10, self.view.frame.size.width, 70)
        lblView.text = "Suresh Kumar"
        lblView.font = lblView.font.fontWithSize(20)
        lblView.textColor = UIColor.whiteColor()
        lblView.textAlignment = .Center
        
        
        let firstChildView = MTCoordinateContainer.init(view: lblView, endForm: CGRectMake(0, 120, 0,0), corner:0, completion: {

            })
        return firstChildView
    
    }
    
    func createSecondView() -> MTCoordinateContainer {
        let btnView = UIImageView.init(image: UIImage(named: "sample-button"))
        btnView.frame = CGRectMake(self.view.frame.size.width - 70, self.view.frame.size.height + 70, 0, 0)
        
        let secondChildView = MTCoordinateContainer.init(view: btnView, endForm: CGRectMake(self.view.frame.size.width - 70, self.view.frame.size.height, 50, 50), mode: .FIXITY, completion: { [weak self] in
            self?.tapEvent("Button Tap Event")
            })
        return secondChildView
    }
    
    
    // MARK: - tap event
    
    func tapEvent(msg: String) {
        let alertController = UIAlertController.init(title: msg, message: nil, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction.init(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    //MAR:Heder options enable
    override  func shouldShowRightMenu() -> Bool{
        
        return false
    }
    
    override func shouldShowNotificatoinBell() ->Bool{
        
        return false
    }
    
    override  func shouldShowCart() -> Bool{
        
        return true
    }
    
    override func shouldShowLeftMenu() -> Bool{
        
        return true
    }
    
    override func headerTitleText() -> String{
        return ""
    }

    
    
}

// MARK: - <#UITableViewDelegate#>
extension ProfileViewController: UITableViewDelegate {
}

// MARK: - <#UITableViewDataSource#>
extension ProfileViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
        cell.frame = CGRectMake(5, 5, self.tableView.bounds.size.width, 100)
        cell.selectionStyle = .None
        cell.textLabel?.text = "Manage Notifications"
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
}


