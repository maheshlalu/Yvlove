//
//  ViewController.swift
//  NowfloatsMyorders
//
//  Created by apple on 14/09/16.
//  Copyright © 2016 apple. All rights reserved.
//

import UIKit

struct orderDetails {
    let orderItemId:String
    let orderName:String
    let orderQuantity:String
    let orderSubTotal:String
    let orderProductPicture:String
}

class MyOrderViewController: CXViewController,UITableViewDataSource,UITableViewDelegate {

    var orderDetailDict:NSDictionary = NSDictionary()
    var orderDetailsArr = [orderDetails]()
    var orderData:NSDictionary! = nil
    let cellReuseIdentifier = "cell"
    let cellSpacingHeight: CGFloat = 3
    var orderProductImages:NSMutableArray = NSMutableArray()
    var stringRepresentation:String = String()
    @IBOutlet weak var MyorderstableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.MyorderstableView?.register(UINib(nibName: "MyordersTableViewCell", bundle: nil), forCellReuseIdentifier: "MyordersTableViewCell")
        self.MyorderstableView?.register(UINib(nibName: "MyorderTableViewCell1", bundle: nil), forCellReuseIdentifier: "MyorderTableViewCell1")
        self.MyorderstableView.rowHeight = UITableViewAutomaticDimension
        self.MyorderstableView.estimatedRowHeight = 196
        DispatchQueue.main.async {
             self.getOrderDetails()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.orderDetailsArr.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let myordercell:MyordersTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "MyordersTableViewCell") as? MyordersTableViewCell
            let orderIdStr = orderDetailDict.value(forKey: "id")
            let date :String =  (orderDetailDict.value(forKey: "createdOn") as? String)!
            let status = orderDetailDict.value(forKey: "Current_Job_Status") as! String
            let priceStr = orderDetailDict.value(forKey: "Total") as! String
            myordercell.orderdidLabel?.text = "Order id : \(orderIdStr!)"
            let rupee = "\u{20B9}"
            myordercell.orderPriceLabel.textColor = CXAppConfig.sharedInstance.getAppTheamColor()
            myordercell.orderPriceLabel.text = "\(rupee) \(priceStr)"
            myordercell.orederPlacedonLabel.text = "Placed On \(date.getTheCurrentDateTime(dateString: date))"
            myordercell.statusLbl.text = status
            myordercell.selectionStyle = .none
            return myordercell
        }else {
            let myordercell1:MyorderTableViewCell1! = tableView.dequeueReusableCell(withIdentifier: "MyorderTableViewCell1") as? MyorderTableViewCell1
            let orderDetails: orderDetails =  (orderDetailsArr[indexPath.section-1] as? orderDetails)!
            myordercell1.myorderDescriptionLabel.text = orderDetails.orderName
            myordercell1.myordertotalpriceLabel.text = "₹ \(orderDetails.orderSubTotal)"
            myordercell1.myordertotalpriceLabel.textColor = CXAppConfig.sharedInstance.getAppTheamColor()
            myordercell1.myorderimageView.sd_setImage(with:URL(string: orderDetails.orderProductPicture))
            myordercell1.selectionStyle = .none
            return myordercell1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if indexPath.section != 0{
            return 143
        }else{
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat{
        return 20.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return cellSpacingHeight
    }
    
    func getOrderDetails(){
        let subDataJobs = orderDetailDict.value(forKey: "CreatedSubJobs") as! NSArray
        
        let OrderItemName = subDataJobs.value(forKey: "OrderItemName")
        let OrderItemMRP = subDataJobs.value(forKey: "OrderItemMRP")
        let OrderItemSubTotal = subDataJobs.value(forKey: "OrderItemSubTotal")
        
        LoadingView.show(true)
        var orderName:NSMutableArray = NSMutableArray()
        var orderPrice:NSMutableArray = NSMutableArray()
        var orderItemId:NSMutableArray = NSMutableArray()
        var orderSubTotal:NSMutableArray = NSMutableArray()
        var orderProductImages:NSMutableArray = NSMutableArray()
        //orderItemName
        if orderDetailDict.value(forKey: "OrderItemName") is String{
            let strOrder = orderDetailDict.value(forKey: "OrderItemName")
            orderName[0] = strOrder!
        }else{
            let order = orderDetailDict.value(forKey: "OrderItemName") as! NSArray
            orderName = order.mutableCopy() as! NSMutableArray
        }
        
        //orderItemQuantity
        if orderDetailDict.value(forKey: "OrderItemQuantity") is String{
            let strOrder = orderDetailDict.value(forKey: "OrderItemQuantity")
            orderPrice[0] = strOrder!
        }else{
            let order = orderDetailDict.value(forKey: "OrderItemQuantity") as! NSArray
            orderPrice = order.mutableCopy() as! NSMutableArray
        }
        
        //orderItemId
        if orderDetailDict.value(forKey: "OrderItemId") is String{
            let strOrder = orderDetailDict.value(forKey: "OrderItemId")
            orderItemId[0] = strOrder!
            stringRepresentation = orderItemId.componentsJoined(by: "_")
        }else{
            let order = orderDetailDict.value(forKey: "OrderItemId") as! NSArray
            orderItemId = order.mutableCopy() as! NSMutableArray
            stringRepresentation = orderItemId.componentsJoined(by: "_")
        }
        
        //orderItemPrice
        if orderDetailDict.value(forKey: "OrderItemSubTotal") is String{
            let strOrder = orderDetailDict.value(forKey: "OrderItemSubTotal")
            orderSubTotal[0] = strOrder!
        }else{
            let order = orderDetailDict.value(forKey: "OrderItemSubTotal") as! NSArray
            orderSubTotal = order.mutableCopy() as! NSMutableArray
        }
        
        CXDataService.sharedInstance.getTheAppDataFromServer(["PrefferedJobs":stringRepresentation as AnyObject,"mallId":CXAppConfig.sharedInstance.getAppMallID() as AnyObject]) { (responseDict) in
            let jobs : NSArray =  responseDict.value(forKeyPath: "jobs.Image_URL") as! NSArray
            if jobs.count == 1{
                let strOrder = jobs[0] as! String
                self.orderProductImages.add(strOrder)
            }else{
                self.orderProductImages = jobs.mutableCopy() as! NSMutableArray
            }
            orderProductImages = self.orderProductImages
            
            for i in 0..<orderName.count {
                if i < orderPrice.count {
                    if i < orderItemId.count{
                        if i < orderSubTotal.count{
                            if i < orderProductImages.count{
                                let name = orderName[i]
                                let finalStr = (name as! String).removingPercentEncoding
                                let quantity = orderPrice[i]
                                let itemId = orderItemId[i]
                                let price = orderSubTotal[i]
                                let picture = orderProductImages[i]
                                let orderStruct : orderDetails = orderDetails(orderItemId: itemId as! String, orderName: finalStr!, orderQuantity: quantity as! String, orderSubTotal: price as! String, orderProductPicture: picture as! String)
                                self.orderDetailsArr.append(orderStruct)
                                LoadingView.hide()
                                self.MyorderstableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
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

