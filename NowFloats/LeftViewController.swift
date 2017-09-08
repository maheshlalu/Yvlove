
//
//  LeftViewController.swift
//  NowFloats
//
//  Created by Mahesh Y on 8/17/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit
import MessageUI
import FacebookCore
import Firebase

class sidePanleData {

    var name: String!
    var displayName : String!
    
    
}

class LeftViewController:ViewController,UITableViewDataSource,UITableViewDelegate {
    
    
    lazy var leftMenuRef: FIRDatabaseReference = FIRDatabase.database().reference().child("Apps").child(CXAppConfig.sharedInstance.getAppMallID()).child("LeftMenu")

    @IBOutlet weak var viewMapBtn: UIButton!
    @IBOutlet weak var messageBtn: UIButton!
    @IBOutlet weak var callUsBtn: UIButton!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var contentsTableView: UITableView!
    
    var sidePanelDataArr : NSArray!
    
    var sidepanelList : NSMutableArray = NSMutableArray()
    
    var profileDPImageView:UIImageView!
    var titleLable: UILabel!
    var mailLable: UILabel!
    var websiteLbl:UILabel!
    var sidePanelDataDict: NSDictionary! = nil
    var sidePanelSingleMallDataDict: NSDictionary!
    
    let categoryNameArray = NSMutableArray()
    
    var navController : CXNavDrawer = CXNavDrawer()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.getSidelPanelFromFirebase()
        self.getSingleMall()
        btnBorderAlignments()
        let nib = UINib(nibName: "LeftViewTableViewCell", bundle: nil)
        self.contentsTableView.register(nib, forCellReuseIdentifier: "LeftViewTableViewCell")
        self.view.backgroundColor = UIColor.white
    }
    
    func getSidelPanelFromFirebase(){
        
        
        for item in CXAppConfig.sharedInstance.getSidePanelList() {
            let data : sidePanleData = sidePanleData()
            data.name = item as? String
            data.displayName = data.name
            self.sidepanelList.add(data)
        }
        
        leftMenuRef.observe(.value, with: { (snapshot) -> Void in
            let leftController = NSMutableArray()
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
                        //let name = channelData["name"] as! String
                        //let contller = self.sidepanelList.object(at: index)
                        
                        let data : sidePanleData = sidePanleData()
                        data.name = channelData["name"] as! String
                        data.displayName = channelData["title"] as! String
                        
                        if let visibility = channelData["visibility"] as? Bool , visibility == true{
                            leftController.add(data)
                        }
                        
                        /* if let contoller = self.viewContollerDic.value(forKey: name)  {
                         tabsWithOrder.append(contoller as! UIViewController)
                         }
                         if name == "Photos" {
                         tabsWithOrder.append(self.viewContollerDic.value(forKey: "Gallery") as! UIViewController)
                         }*/
                        break
                    }
                }
            }
            if leftController.count != 0 {
               // self.sidepanelList.removeAllObjects()
                self.sidepanelList = leftController
                self.contentsTableView.reloadData()
            }else{
                
            }
     
            //  print( self.channels)
        })

    }
    
    func getSingleMall(){
        if CX_SingleMall.mr_findAll().count != 0{
            let appdata:CX_SingleMall = CX_SingleMall.mr_findFirst() as! CX_SingleMall
            self.sidePanelSingleMallDataDict = CXConstant.sharedInstance.convertStringToDictionary(appdata.json!)
            self.getStores()
        }else{
            CXAppDataManager.sharedInstance.getSingleMall({ (isDataSaved) in
                let appdata:CX_SingleMall = CX_SingleMall.mr_findFirst() as! CX_SingleMall
                self.sidePanelSingleMallDataDict = CXConstant.sharedInstance.convertStringToDictionary(appdata.json!)
                self.getStores()
            })
        }
    }
    
    func getStores(){
        if CX_Stores.mr_findAll().count != 0{
            let productEn = NSEntityDescription.entity(forEntityName: "CX_Stores", in: NSManagedObjectContext.mr_contextForCurrentThread())
            let predicate:NSPredicate =  NSPredicate(format: "itemCode contains[c] %@",CXAppConfig.sharedInstance.getAppMallID())
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CX_Stores.mr_requestAllSorted(by: "itemCode", ascending: true)
            fetchRequest.predicate = predicate
            fetchRequest.entity = productEn
            self.sidePanelDataArr = CX_Stores.mr_executeFetchRequest(fetchRequest) as NSArray
            let storesEntity : CX_Stores = self.sidePanelDataArr.lastObject as! CX_Stores
            self.sidePanelDataDict = CXConstant.sharedInstance.convertStringToDictionary(storesEntity.json!)
            self.sidepanelView()
        }else{
            CXAppDataManager.sharedInstance.getTheStores({(isDataSaved) in
                let productEn = NSEntityDescription.entity(forEntityName: "CX_Stores", in: NSManagedObjectContext.mr_contextForCurrentThread())
                let predicate:NSPredicate =  NSPredicate(format: "itemCode contains[c] %@",CXAppConfig.sharedInstance.getAppMallID())
                let fetchRequest : NSFetchRequest<NSFetchRequestResult> = CX_Stores.mr_requestAllSorted(by: "itemCode", ascending: true)
                fetchRequest.predicate = predicate
                fetchRequest.entity = productEn
                self.sidePanelDataArr = CX_Stores.mr_executeFetchRequest(fetchRequest) as NSArray
                let storesEntity : CX_Stores = self.sidePanelDataArr.lastObject as! CX_Stores
                self.sidePanelDataDict = CXConstant.sharedInstance.convertStringToDictionary(storesEntity.json!)
                self.sidepanelView()
            })
        }
    }
    
    func btnBorderAlignments(){
        viewMapBtn.layer.cornerRadius = 2
        viewMapBtn.layer.borderColor = UIColor.gray.cgColor
        viewMapBtn.layer.borderWidth = 1
        
        messageBtn.layer.cornerRadius = 2
        messageBtn.layer.borderColor = UIColor.gray.cgColor
        messageBtn.layer.borderWidth = 1
        
        callUsBtn.layer.cornerRadius = 2
        callUsBtn.layer.borderColor = UIColor.gray.cgColor
        callUsBtn.layer.borderWidth = 1
    }
    
    func sidepanelView(){
        self.profileDPImageView = UIImageView.init(frame: CGRect(x: self.detailsView.frame.origin.x+10,y: self.detailsView.frame.origin.y-20,width: 60,height: 60))
        let imgUrl = self.isContansKey(self.sidePanelSingleMallDataDict as NSDictionary, key: "logo") ? (self.sidePanelSingleMallDataDict .value(forKey: "logo") as? String)! : ""
        UserDefaults.standard.set(imgUrl, forKey: "LOGO")
        UserDefaults.standard.set(self.sidePanelSingleMallDataDict.value(forKey: "Cover_Image"), forKey: "CoverImage")
        
        profileDPImageView.sd_setImage(with: URL(string: imgUrl))
        self.profileDPImageView .clipsToBounds = true
        self.detailsView.addSubview(self.profileDPImageView )
        
        self.titleLable = UILabel.init(frame: CGRect(x: self.profileDPImageView.frame.size.width + self.detailsView.frame.origin.x+20 ,y: self.detailsView.frame.origin.y-32,width: self.detailsView.frame.size.width - (self.profileDPImageView.frame.size.width)-30 ,height: 90 ))
        self.titleLable.textColor = CXAppConfig.sharedInstance.getAppTheamColor()
        titleLable.lineBreakMode = .byWordWrapping
        titleLable.numberOfLines = 0
        titleLable.font = UIFont(name: "Roboto-Bold", size: 15)
        let productName = self.isContansKey(self.sidePanelDataDict as NSDictionary, key: "Name") ? (self.sidePanelDataDict.value(forKey: "Name") as? String)! : ""
        let city =  self.sidePanelDataDict.value(forKeyPath: "City") as! String
        titleLable.text = "\(productName) \(city)"
        self.detailsView.addSubview(titleLable)
        
    }
    
    func createButton(_ frame:CGRect,title: String,tag:Int, bgColor:UIColor) -> UIButton {
        let button: UIButton = UIButton()
        button.frame = frame
        button.setTitle(title, for: UIControlState())
        button.titleLabel?.font = UIFont.init(name:"Roboto-Regular", size: 18)
        button.titleLabel?.textAlignment = NSTextAlignment.left
        button.setTitleColor(UIColor.gray, for: UIControlState())
        button.layer.cornerRadius = 5.0
        button.layer.masksToBounds = true
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        button.backgroundColor = bgColor
        return button
    }
    
    func createImageButton(_ frame:CGRect,tag:Int,bImage:UIImage) -> UIButton {
        let button: UIButton = UIButton()
        button.frame = frame
        button.backgroundColor = UIColor.yellow
        button.setImage(bImage, for: UIControlState())
        button.backgroundColor = UIColor.clear
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        return button
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sidepanelList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeftViewTableViewCell", for: indexPath) as! LeftViewTableViewCell
        
        let data : sidePanleData = self.sidepanelList[indexPath.row] as! sidePanleData
        cell.contentsLbl.text = data.displayName
        cell.iconImage.image = UIImage(named: (data.name)!)
        cell.contentsLbl.textColor = UIColor.gray
        cell.contentsLbl.font = cell.contentsLbl.font.withSize(15)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.navController.drawerToggle()
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        let data : sidePanleData = self.sidepanelList[indexPath.row] as! sidePanleData
        //let itemName : String =  (CXAppConfig.sharedInstance.getSidePanelList()[indexPath.row] as? String)!
        let itemName : String =  data.name

        if itemName == "Home"{
            self.navController.popToRootViewController(animated: true)
            
        }else if itemName == "About Us"{
            CXMixpanel.sharedInstance.mixelAboutTrack()
            let aboutUs = storyBoard.instantiateViewController(withIdentifier: "ABOUT_US") as! AboutUsViewController
            self.navController.pushViewController(aboutUs, animated: true)
            
            return
            
            if UserDefaults.standard.value(forKey: "USER_EMAIL") == nil{
                let name = CXSignInSignUpViewController()
                self.navigationController?.pushViewController(name, animated: true)
            }else{
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let chatList = storyBoard.instantiateViewController(withIdentifier: "LFChatListViewController") as! LFChatListViewController
                
                let macUserId = UserDefaults.standard.value(forKey: "MACID_JOBID")
                let userEmail = UserDefaults.standard.value(forKey: "USER_EMAIL") as! String
                let userName = UserDefaults.standard.value(forKey: "FIRST_NAME") as! String
                let userPic = UserDefaults.standard.value(forKey: "IMAGE_PATH") as! String
                
                chatList.userID = String(macUserId as! Int)
                
                let chatData:NSMutableDictionary = NSMutableDictionary()
                chatData.setValue(userEmail, forKey: "FromUserEmail")
                chatData.setValue(userName, forKey: "FromUserName")
                chatData.setValue(userPic, forKey: "FromUserPic")
                chatData.setValue(macUserId, forKey: "FromUserId")
                
                chatList.userDetailsDic = chatData
                self.navController.pushViewController(chatList, animated: true)
            }
            
        }else if itemName == "Orders"{
            CXMixpanel.sharedInstance.mixelOrdersTrack()
            if UserDefaults.standard.value(forKey: "USER_ID") != nil{
                let orders = storyBoard.instantiateViewController(withIdentifier: "ORDERS") as! OrdersViewController
                self.navController.pushViewController(orders, animated: true)
            }else{
                let signInViewCnt : CXSignInSignUpViewController = CXSignInSignUpViewController()
                self.navController.pushViewController(signInViewCnt, animated: true)
            }
            
        }else if itemName == "Wish List" {
            CXMixpanel.sharedInstance.mixelWishListTrack()
            let wishlist = storyBoard.instantiateViewController(withIdentifier: "WISHLIST") as! NowfloatWishlistViewController
            self.navController.pushViewController(wishlist, animated: true)
        }else if itemName == "Store Locator"{
            let store = storyBoard.instantiateViewController(withIdentifier: "StorelocatorViewController") as! StorelocatorViewController
            self.navController.pushViewController(store, animated: true)
        }else if itemName == "Chat" {
            
        }else if itemName == "Blog" {
            
        }else if itemName == "Services" {
            
        }else if itemName == "BookAppointment" {
            
        }
    }
    
    //Mark: Storecategory api call
    
//    func storeCategories() {
//        let categoryNameArray = NSMutableArray()
//        CXDataService.sharedInstance.getTheAppDataFromServer(["type":"Stores" as AnyObject,"mallId":CXAppConfig.sharedInstance.getAppMallID() as AnyObject]) { (responseDict) in
//            let categoryJobArray = responseDict.value(forKey: "jobs")as! NSArray
//            for obj in categoryJobArray{
//                let dict = obj as! NSDictionary
//                categoryNameArray.add(dict.value(forKey: "City")as! String)
//            }
//            completion(categoryNameArray)
//        }
//
//        
//        
//    }
    
   /* func getStoreCategories(completion:@escaping (_ responseArr:NSMutableArray) -> Void){
        
        let categoryNameArray = NSMutableArray()
        
        CXDataService.sharedInstance.getTheAppDataFromServer(["type":"Stores" as AnyObject,"mallId":CXAppConfig.sharedInstance.getAppMallID() as AnyObject]) { (responseDict) in
            let categoryJobArray = responseDict.value(forKey: "jobs")as! NSArray
            for obj in categoryJobArray{
                let dict = obj as! NSDictionary
                categoryNameArray.add(dict.value(forKey: "City")as! String)
            }
            completion(categoryNameArray)
        }
        
    }*/

    func isContansKey(_ responceDic : NSDictionary , key : String) -> Bool{
        let allKeys : NSArray = responceDic.allKeys as NSArray
        return  allKeys.contains(key)
    }
    
    @IBAction func callUsAction(_ sender: UIButton) {
        CXMixpanel.sharedInstance.trackTheCallInformation()
        if UserDefaults.standard.value(forKey: "USER_ID") == nil{
            AppEventsLogger.log("Call Attempted")
        }else{
            CXFBEvents.sharedInstance.logAppLaunchedEvent(_eventName: "Call Attempted", UserDefaults.standard.value(forKey: "USER_EMAIL")! as! String)
        }
        let primaryNumber = CXAppConfig.sharedInstance.getTheDataInDictionaryFromKey(sourceDic: self.sidePanelDataDict, sourceKey: "Contact Number")
        callNumber(primaryNumber)
    }
    
    @IBAction func messageAction(_ sender: UIButton) {
        CXMixpanel.sharedInstance.mixelMessageTrack()
        self.navController.drawerToggle()
        let signInViewCnt : ServiceFormViewController = ServiceFormViewController()
        self.navController.pushViewController(signInViewCnt, animated: true)
    }
    
    @IBAction func viewMapAction(_ sender: UIButton) {
        CXMixpanel.sharedInstance.mixelViewMapTrack()
        self.navController.drawerToggle()
        let mapViewCnt : MapViewCntl = MapViewCntl()
        mapViewCnt.lat = Double(self.sidePanelDataDict.value(forKeyPath: "Latitude") as! String!)
        mapViewCnt.lon = Double(self.sidePanelDataDict.value(forKeyPath: "Longitude") as! String!)
        self.navController.pushViewController(mapViewCnt, animated: true)
        
        if UserDefaults.standard.value(forKey: "USER_ID") == nil{
            AppEventsLogger.log("Map Attempted")
        }else{
            CXFBEvents.sharedInstance.logAppLaunchedEvent(_eventName: "Map Attempted", UserDefaults.standard.value(forKey: "USER_EMAIL")! as! String)
        }
    }
    
    fileprivate func callNumber(_ phoneNumber:String) {
        if !phoneNumber.isEmpty {
            UIApplication.shared.open(URL(string: "tel://\(phoneNumber)")!, options: [:], completionHandler: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
