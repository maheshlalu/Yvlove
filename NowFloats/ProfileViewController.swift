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
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), style:.plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        
        let headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/3+20))
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
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
        self.dpImageView.frame = CGRect(x: startX, y: 20, width: iconSize, height: iconSize)
        let radius:Float = 0.5
        self.dpImageView.layer.cornerRadius = self.dpImageView.frame.width * radius.f
        self.dpImageView.clipsToBounds = true
        self.dpImageView.layer.masksToBounds = true
        self.dpImageView.layer.borderWidth = 3.f
        self.dpImageView.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8).cgColor
        
        let dpImageView = MTCoordinateContainer.init(view: self.dpImageView, endForm: CGRect(x: centerX, y: 120, width: 0, height: 0), corner: radius, completion: {
            
            })
        return dpImageView
    }
    
    func createNameLblView() -> MTCoordinateContainer{
        let lblView = UILabel.init()
        lblView.frame = CGRect(x: 0, y: self.dpImageView.frame.size.height+10, width: self.view.frame.size.width, height: 70)
        lblView.text = "Suresh Kumar"
        lblView.font = lblView.font.withSize(20)
        lblView.textColor = UIColor.white
        lblView.textAlignment = .center
        
        
        let firstChildView = MTCoordinateContainer.init(view: lblView, endForm: CGRect(x: 0, y: 120, width: 0,height: 0), corner:0, completion: {

            })
        return firstChildView
    
    }
    
    func createSecondView() -> MTCoordinateContainer {
        let btnView = UIImageView.init(image: UIImage(named: "sample-button"))
        btnView.frame = CGRect(x: self.view.frame.size.width - 70, y: self.view.frame.size.height + 70, width: 0, height: 0)
        
        let secondChildView = MTCoordinateContainer.init(view: btnView, endForm: CGRect(x: self.view.frame.size.width - 70, y: self.view.frame.size.height, width: 50, height: 50), mode: .fixity, completion: { [weak self] in
            self?.tapEvent("Button Tap Event")
            })
        return secondChildView
    }
    
    
    // MARK: - tap event
    
    func tapEvent(_ msg: String) {
        let alertController = UIAlertController.init(title: msg, message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
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
    override func showLogoForAboutUs() -> Bool{
        return false
    }
    
    override func headerTitleText() -> String{
        return ""
    }
    override func shouldShowLeftMenuWithLogo() -> Bool{
      
        return false
    }

    
    
}

// MARK: - <#UITableViewDelegate#>
extension ProfileViewController: UITableViewDelegate {
}

// MARK: - <#UITableViewDataSource#>
extension ProfileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.frame = CGRect(x: 5, y: 5, width: self.tableView.bounds.size.width, height: 100)
        cell.selectionStyle = .none
        cell.textLabel?.text = "Manage Notifications"
        return cell
    }
    
   // func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 //   }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
}


