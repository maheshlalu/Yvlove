//
//  HistoryViewController.swift
//  MessageEnquiry
//
//  Created by apple on 14/09/16.
//  Copyright © 2016 apple. All rights reserved.
//

import UIKit

class HistoryViewController: CXViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var historytableview: UITableView!
    var nameArray = ["india","america","newzealand","srilanka","india","america","newzealand","srilanka","india","america","newzealand","srilanka"]
    //let cellReuseIdentifier = "cell"
    //let cellSpacingHeight: CGFloat = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "HistoryTableViewCell", bundle: nil)
        self.historytableview.rowHeight = UITableViewAutomaticDimension
        self.historytableview.estimatedRowHeight = 5.0
        
        self.historytableview.register(nib, forCellReuseIdentifier: "HistoryTableViewCell")
        // Do any additional setup after loading the view.
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        
        return nameArray.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return 1
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = historytableview.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath)as!  HistoryTableViewCell
        cell.historynameLabel?.text = nameArray[indexPath.section]
        cell.selectionStyle = .none
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        tableView.rowHeight = 130
        return 130
        
        //return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        
        return 5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let productDetails = storyBoard.instantiateViewController(withIdentifier: "ENQUIRY") as! EnquiryViewController
        self.navigationController?.pushViewController(productDetails, animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldShowRightMenu() -> Bool{
        return true
    }
    
    override func shouldShowNotificatoinBell() ->Bool{
        
        return true
    }
    
    override func shouldShowCart() -> Bool{
        
        return false
    }
    
    
    override func shouldShowLeftMenu() -> Bool{
        
        return false
    }
    
    override func shouldShowLeftMenuWithLogo() -> Bool{
        
        return false
    }
    
    override func showLogoForAboutUs() -> Bool{
        return false
    }
    
    override func headerTitleText() -> String{
        return "Enquiry"
    }
    
    override func profileDropdown() -> Bool{
        return false
    }
    
    override func profileDropdownForSignIn() -> Bool{
        return false
    }
    
}
