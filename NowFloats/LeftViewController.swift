
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

class LeftViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,MFMessageComposeViewControllerDelegate {
    
    @IBOutlet weak var viewMapBtn: UIButton!
    @IBOutlet weak var messageBtn: UIButton!
    @IBOutlet weak var callUsBtn: UIButton!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var contentsTableView: UITableView!
    
    var sidePanelDataArr : NSArray!
    
    
    var profileDPImageView:UIImageView!
    var titleLable: UILabel!
    var mailLable: UILabel!
    var websiteLbl:UILabel!
    var sidePanelDataDict: NSDictionary! = nil
    var sidePanelSingleMallDataDict: NSDictionary!
    
    var navController : CXNavDrawer = CXNavDrawer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getSingleMall()
        btnBorderAlignments()
        let nib = UINib(nibName: "LeftViewTableViewCell", bundle: nil)
        self.contentsTableView.register(nib, forCellReuseIdentifier: "LeftViewTableViewCell")
        self.view.backgroundColor = UIColor.white
        
        
        
    }
    
    func getSingleMall(){
        
        if CX_SingleMall.mr_findAll().count != 0  {
            let appdata:CX_SingleMall = CX_SingleMall.mr_findFirst() as! CX_SingleMall
            self.sidePanelSingleMallDataDict = CXConstant.sharedInstance.convertStringToDictionary(appdata.json!)
            print("\(self.sidePanelSingleMallDataDict)")
            self.getStores()
        }else{
            CXAppDataManager.sharedInstance.getSingleMall({ (isDataSaved) in
                let appdata:CX_SingleMall = CX_SingleMall.mr_findFirst() as! CX_SingleMall
                self.sidePanelSingleMallDataDict = CXConstant.sharedInstance.convertStringToDictionary(appdata.json!)
                print("\(self.sidePanelSingleMallDataDict)")
                self.getStores()
            })
        }
    }
    
    func getStores(){
        
        if CX_Stores.mr_findAll().count != 0{
            let productEn = NSEntityDescription.entity(forEntityName: "CX_Stores", in: NSManagedObjectContext.mr_contextForCurrentThread())
            let predicate:NSPredicate =  NSPredicate(format: "itemCode contains[c] %@",CXAppConfig.sharedInstance.getAppMallID())
            let fetchRequest: NSFetchRequest<NSFetchRequestResult>= CX_Stores.mr_requestAllSorted(by: "itemCode", ascending: true)
            fetchRequest.predicate = predicate
            fetchRequest.entity = productEn
            self.sidePanelDataArr = CX_Stores.mr_executeFetchRequest(fetchRequest) as NSArray
            let storesEntity : CX_Stores = self.sidePanelDataArr.lastObject as! CX_Stores
            self.sidePanelDataDict = CXConstant.sharedInstance.convertStringToDictionary(storesEntity.json!)
            print(self.sidePanelDataDict)
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
                print(self.sidePanelDataDict)
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
        return CXAppConfig.sharedInstance.getSidePanelList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeftViewTableViewCell", for: indexPath) as! LeftViewTableViewCell
        cell.contentsLbl.text = CXAppConfig.sharedInstance.getSidePanelList()[indexPath.row] as? String
        cell.iconImage.image = UIImage(named: (CXAppConfig.sharedInstance.getSidePanelList()[indexPath.row] as? String)!)
        cell.contentsLbl.textColor = UIColor.gray
        cell.contentsLbl.font = cell.contentsLbl.font.withSize(15)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.navController.drawerToggle()
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let itemName : String =  (CXAppConfig.sharedInstance.getSidePanelList()[indexPath.row] as? String)!
        
        if itemName == "Home"{
            self.navController.popToRootViewController(animated: true)
            
        }else if itemName == "About us"{
            CXMixpanel.sharedInstance.mixelAboutTrack()
            let aboutUs = storyBoard.instantiateViewController(withIdentifier: "ABOUT_US") as! AboutUsViewController
            self.navController.pushViewController(aboutUs, animated: true)
            
        }else if itemName == "Orders"{
            CXMixpanel.sharedInstance.mixelOrdersTrack()
            if UserDefaults.standard.value(forKey: "USER_ID") != nil{
                let orders = storyBoard.instantiateViewController(withIdentifier: "ORDERS") as! OrdersViewController
                self.navController.pushViewController(orders, animated: true)
            }else{
                let signInViewCnt : CXSignInSignUpViewController = CXSignInSignUpViewController()
                self.navController.pushViewController(signInViewCnt, animated: true)
            }
            
        }else if itemName == "Wishlist" {
            CXMixpanel.sharedInstance.mixelWishListTrack()
            let wishlist = storyBoard.instantiateViewController(withIdentifier: "WISHLIST") as! NowfloatWishlistViewController
            self.navController.pushViewController(wishlist, animated: true)
        }
    }
    
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
        let primaryNumber = CXAppConfig.sharedInstance.getTheDataInDictionaryFromKey(sourceDic: self.sidePanelDataDict, sourceKey: "Primary Number")
        callNumber(primaryNumber)
    }
    
    @IBAction func messageAction(_ sender: UIButton) {
        CXMixpanel.sharedInstance.mixelMessageTrack()
        let messageVC = MFMessageComposeViewController()
        messageVC.body = "Hi Do you have any query?";
        //  messageVC.recipients = [self.sidePanelDataDict.value(forKeyPath: "PrimaryNumber") as! String!]'
        if !CXAppConfig.sharedInstance.getTheDataInDictionaryFromKey(sourceDic: self.sidePanelDataDict, sourceKey: "PrimaryNumber").isEmpty {
            messageVC.recipients = [CXAppConfig.sharedInstance.getTheDataInDictionaryFromKey(sourceDic: self.sidePanelDataDict, sourceKey: "PrimaryNumber")]
            //[self.sidePanelDataDict.value(forKeyPath: "PrimaryNumber") as! String!]
            messageVC.messageComposeDelegate = self;
            self.present(messageVC, animated: true, completion: nil)
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch result.rawValue {
        case MessageComposeResult.cancelled.rawValue :
            print("message canceled")
            
        case MessageComposeResult.failed.rawValue :
            print("message failed")
            
        case MessageComposeResult.sent.rawValue :
            print("message sent")
            
        default:
            break
        }
        controller.dismiss(animated: true, completion: nil)
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
