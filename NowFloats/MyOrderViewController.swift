//
//  ViewController.swift
//  NowfloatsMyorders
//
//  Created by apple on 14/09/16.
//  Copyright © 2016 apple. All rights reserved.
//

import UIKit

class MyOrderViewController: CXViewController,UITableViewDataSource,UITableViewDelegate {
    var orderIdStr:String!
    var placedStr:String!
    var priceStr:String!
    
    let cellReuseIdentifier = "cell"
    let cellSpacingHeight: CGFloat = 3
    @IBOutlet weak var MyorderstableView: UITableView!
    var orderData:NSDictionary! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.MyorderstableView?.register(UINib(nibName: "MyordersTableViewCell", bundle: nil), forCellReuseIdentifier: "MyordersTableViewCell")
        self.MyorderstableView?.register(UINib(nibName: "MyorderTableViewCell1", bundle: nil), forCellReuseIdentifier: "MyorderTableViewCell1")
        
        self.MyorderstableView.rowHeight = UITableViewAutomaticDimension
        self.MyorderstableView.estimatedRowHeight = 10.0
        
        print("\(orderData.value(forKey: "OrderItemName"))")
        //OrderItemId
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        
        return 7
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return 1
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == 0 {
            
            let myordercell:MyordersTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "MyordersTableViewCell") as? MyordersTableViewCell
            myordercell.orderdidLabel?.text = "Order id : \(orderIdStr)"
            let rupee = "\u{20B9}"
            myordercell.orderPriceLabel.textColor = CXAppConfig.sharedInstance.getAppTheamColor()
            myordercell.orderPriceLabel.text = "\(rupee) \(priceStr)"
            myordercell.orederPlacedonLabel.text = "Placed On \(placedStr)"
            myordercell.selectionStyle = .none
            
            
            return myordercell
        }else {
            
            let myordercell1:MyorderTableViewCell1! = tableView.dequeueReusableCell(withIdentifier: "MyorderTableViewCell1") as? MyorderTableViewCell1
            myordercell1.myorderDescriptionLabel.text = "Suresh"
            myordercell1.selectionStyle = .none
            return myordercell1
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        
        return UITableViewAutomaticDimension
        
        
    }
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat
    {
        
        return 20.0
        
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        
        return cellSpacingHeight
        
    }
    
    //MAR:Heder options enable
    override  func shouldShowRightMenu() -> Bool{
        
        return false
    }
    
    override func shouldShowNotificatoinBell() ->Bool{
        
        return false
    }
    
    override  func shouldShowCart() -> Bool{
        
        return false
    }
    
    
    override func headerTitleText() -> String{
        return "My Orders"
    }
    
    override func shouldShowLeftMenu() -> Bool{
        
        return true
    }
    override func showLogoForAboutUs() -> Bool{
        return false
    }
    
    override func shouldShowLeftMenuWithLogo() -> Bool{
        
        return true
    }
    
    override func profileDropdown() -> Bool{
        return false
    }
    
    override func profileDropdownForSignIn() -> Bool{
        return false
    }
    
    
}

