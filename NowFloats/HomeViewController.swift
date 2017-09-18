//
//  HomeViewController.swift
//  NowFloats
//
//  Created by Mahesh Y on 8/17/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit
import Alamofire
import Firebase


class HomeViewController: UITabBarController {
    
    var tabBarCntl : UITabBarController!
    let additionalCatArr: NSMutableArray = NSMutableArray()
    var viewContollerDic : NSMutableDictionary = NSMutableDictionary()
    let totalTabNames = ["Offers","Updates","Products","Gallery","Calendar","IsOnlyLoyalty","Reviews"]
    var tabsController = [UIViewController]()
    lazy var userRef: FIRDatabaseReference = FIRDatabase.database().reference().child("Apps").child(CXAppConfig.sharedInstance.getAppMallID()).child("screens")

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarCntl = self
        CXDataProvider.sharedInstance.tabBar = self
        self.addTheTabBarControllers()
       // self.getAllNotificationList()
        //getAddtinalCategryList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.tabsController.count != 0 {
            //CXDataProvider.sharedInstance.tabBar.tabBarController?.setViewControllers(self.tabsController, animated: true)
        }
    }
    func addTheTabBarControllers
        (){
        
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        self.tabsController.removeAll()
        //CXWidgets
     let widetList =    CXDataProvider.sharedInstance.getTheTableDataFromDataBase("CXWidgets", predicate: NSPredicate(), ispredicate: false, orederByKey: "")
        
        for widgetItem in widetList.dataArray {
            let widGetData = widgetItem as? CXWidgets
            if widGetData?.visibility == "Yes" && widGetData?.name == "Offers" {
               let firstTab = storyBoard.instantiateViewController(withIdentifier: "OFFERS") as! OffersViewController
                firstTab.title = widGetData?.displayName
                firstTab.tabBarItem.image = UIImage(named: "offers")
                self.tabsController.append(firstTab)
                if let key = widGetData?.name {
                   viewContollerDic[key] = firstTab
                }
            }else if widGetData?.visibility == "Yes" && widGetData?.name == "Updates" {
               let firstTab = storyBoard.instantiateViewController(withIdentifier: "UPDATE") as! UpdatesViewController
                firstTab.title = widGetData?.displayName
                firstTab.tabBarItem.image = UIImage(named: "updateTabImg")
                self.tabsController.append(firstTab)
                if let key = widGetData?.name {
                    viewContollerDic[key] = firstTab
                }

            }else if widGetData?.visibility == "Yes" && widGetData?.name == "Products" {
                let product = storyBoard.instantiateViewController(withIdentifier: "PRODUCT") as! ProductsViewController
                product.title = widGetData?.displayName
                product.tabBarItem.image = UIImage(named: "productsImage")
                self.tabsController.append(product)
                if let key = widGetData?.name {
                   viewContollerDic[key] = product
                }

            }else if widGetData?.visibility == "Yes" && widGetData?.name == "Gallery" {
                let photos = storyBoard.instantiateViewController(withIdentifier: "PHOTO") as! PhotosViewController //GalleryTabBarViewController()
                photos.title = widGetData?.displayName
                photos.tabBarItem.image = UIImage(named: "picsImage")//picsImage
                self.tabsController.append(photos)
                if let key = widGetData?.name {
                    viewContollerDic[key] = photos
                }
            }else if widGetData?.visibility == "Yes" && widGetData?.name == "Reviews" {
                let review = CXCommentViewController.init()
                review.title = widGetData?.displayName
                review.tabBarItem.image = UIImage(named: "review")
                self.tabsController.append(review)
                if let key = widGetData?.name {
                    viewContollerDic[key] = review
                }

                //review.tabBarItem.image = UIImage(named: "productsImage")
            }else if widGetData?.visibility == "Yes" && widGetData?.name == "Calendar" {
                let calender = storyBoard.instantiateViewController(withIdentifier: "CXCalenderViewController") as! CXCalenderViewController
                calender.title = widGetData?.displayName
                calender.tabBarItem.image = UIImage(named: "offers")
                self.tabsController.append(calender)
                if let key = widGetData?.name {
                    viewContollerDic[key] = calender
                }
            }else if widGetData?.visibility == "Yes" && widGetData?.name == "Loyalty" {
                //viewContollerDic["\(String(describing: widGetD ata?.name))"] = firstTab
                let loyaltyCard = storyBoard.instantiateViewController(withIdentifier: "LOYALCARD") as! CXLoyalCrdViewController
                loyaltyCard.title = widGetData?.displayName
                loyaltyCard.tabBarItem.image = UIImage(named: "")
                self.tabsController.append(loyaltyCard)
                if let key = widGetData?.name {
                    viewContollerDic[key] = loyaltyCard
                }
            }else if widGetData?.visibility == "Yes" && widGetData?.name == "BookAppointment"{
                let bookAppointment = storyBoard.instantiateViewController(withIdentifier: "MyAppointmentViewController") as! MyAppointmentViewController
                bookAppointment.title = widGetData?.displayName
                bookAppointment.tabBarItem.image = UIImage(named: "bookApoint")
                //bookApoint
                self.tabsController.append(bookAppointment)
                if let key = widGetData?.name {
                    viewContollerDic[key] = bookAppointment
                }
            }
        }
    
        if !NetworkReachabilityManager()!.isReachable {
                       // do some tasks..
             self.tabBarController?.setViewControllers(self.tabsController, animated: true)

        }
        
       // self.tabBarController?.setViewControllers(self.tabsController, animated: true)

        print(self.viewContollerDic)
        self.arrangeTheTabsOrder()

       /* if CXDataProvider.sharedInstance.getTheTableDataFromDataBase("CX_FeaturedProducts", predicate: NSPredicate(), ispredicate: false,orederByKey: "").totalCount == 0{
            firstTab = storyBoard.instantiateViewController(withIdentifier: "UPDATE") as! UpdatesViewController
            firstTab.title = "UPDATES"
            firstTab.tabBarItem.image = UIImage(named: "updateTabImg")
            
            viewContollerDic["UPDATES"] = firstTab
            
            
        }else{
            firstTab = storyBoard.instantiateViewController(withIdentifier: "OFFERS") as! OffersViewController
            firstTab.title = "OFFERS"
            firstTab.tabBarItem.image = UIImage(named: "offers")
            viewContollerDic["OFFERS"] = firstTab

        }*/
        /*4
         
         */
    }
    
    
    func arrangeTheTabsOrder(){
        //let channelRef = userRef
        userRef.observe(.value, with: { (snapshot) -> Void in
            var tabsWithOrder = [UIViewController]()
            // self.channels.removeAllObjects()
            var positions = [Int]()
            for channelSnap in snapshot.children {
                let channelData = (channelSnap as! FIRDataSnapshot).value as! Dictionary<String, AnyObject>
                positions.append(channelData["position"] as! Int)
                print(channelData)
                // if status == -1 (Rejected by user)
                // if channelData["status"] as! String != "-1"
                //{
                //  self.channels.add(channelData)
                //}
            }
            positions.sort {
                return $0 < $1
            }
            for position in positions{
                for channelSnap in snapshot.children {
                    let channelData = (channelSnap as! FIRDataSnapshot).value as! Dictionary<String, AnyObject>
                    let value = channelData["position"] as! Int
                    if value == position {
                        let name = channelData["name"] as! String
                        if let contoller = self.viewContollerDic.value(forKey: name)  {
                            
                            if let visibility = channelData["visibility"] as? Bool , visibility == true{
                                tabsWithOrder.append(contoller as! UIViewController)
                            }
                        }
                        if name == "Photos" {
                            if let visibility = channelData["visibility"] as? Bool , visibility == true{
                                tabsWithOrder.append(self.viewContollerDic.value(forKey: "Gallery") as! UIViewController)
                            }
                        }
                        break
                    }
                }
            }
            if tabsWithOrder.count != 0 {
                self.tabsController.removeAll()
                self.tabsController = tabsWithOrder
            }else{
                
            }
            //CXLog.print(self.tabsController)
           // CXDataProvider.sharedInstance.tabBar.tabBarController?.setViewControllers(self.tabsController, animated: true)
            //CXLog.print("print the tabbar \(tab)")
          if let tab = self.tabBarController {
              tab.setViewControllers(self.tabsController, animated: true)
          }else{
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            appDelegate?.setUpSidePanelview()
            CXLog.print("called firebase data")
            //self.viewControllers = self.tabsController
            //self.tabBarCntl.setViewControllers(self.tabsController, animated: true)
            //self.viewWillAppear(true)
            //CXDataProvider.sharedInstance.tabBar.setViewControllers(self.tabsController, animated: true)
            // self.setViewControllers(self.tabsController, animated: Bool)
            }
            //  print( self.channels)
        })
    }
    
    
    
    /*
     ["position": 1, "name": Offers, "title": Offers, "visibility": 1]
     ["position": 3, "name": Updates, "title": Updates, "visibility": 1]
     ["position": 4, "name": Products, "title": Products, "visibility": 1]
     ["position": 2, "name": Photos, "title": Photos, "visibility": 1]
     */
    
    func getAllNotificationList(){
        
        //let channelRef = userRef
        userRef.observe(.value, with: { (snapshot) -> Void in
           // self.channels.removeAllObjects()
            for channelSnap in snapshot.children {
                let channelData = (channelSnap as! FIRDataSnapshot).value as! Dictionary<String, AnyObject>
                
                print(channelData)
                // if status == -1 (Rejected by user)
               // if channelData["status"] as! String != "-1"
                //{
                  //  self.channels.add(channelData)
                //}
            }
          //  print( self.channels)
        })
    }
    
    func cartButtonAction(){
    }
    func notificationBellAction(){
    }
    func profileToggleAction(){
    }
    func getAddtinalCategryList(){
        if(UserDefaults.standard.object(forKey: "CategeryAdditinal") == nil)
        {
        }else{
            
            let dataKyes = ["type":"ProductCategories","mallId":CXAppConfig.sharedInstance.getAppMallID()]
            CXDataService.sharedInstance.getTheAppDataFromServer(dataKyes as [String : AnyObject]?) { (responceDic) in
                let jobsData:NSArray = responceDic.value(forKey: "jobs")! as! NSArray
                for dictData in jobsData {
                    
                    let dictindividual : NSDictionary =  (dictData as? NSDictionary)!
                    let name:String = (dictindividual.value(forKey: "Name") as? String)!
                    self.additionalCatArr.add(name)
                }
                UserDefaults.standard.set(self.additionalCatArr, forKey: "CategeryAdditinal")
            }
        }
    }
    
}



