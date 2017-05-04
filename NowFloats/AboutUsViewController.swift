//
//  ViewController.swift
//  NowfloatAboutus
//
//  Created by apple on 13/09/16.
//  Copyright © 2016 apple. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

class AboutUsViewController: CXViewController,UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var timingsLbl: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var questionBtn: UIButton!
    @IBOutlet weak var aboutusimageview: UIImageView!
    @IBOutlet weak var aboutustableview: UITableView!
    @IBOutlet weak var rateLbl: UILabel!
    @IBOutlet weak var rateView: FloatRatingView!
    let locationManager = CLLocationManager()
    
    var str:String = ""
    var aboutUsArray : NSArray!
    var aboutUsDict: NSDictionary!
    var mallDistance:String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getStores()
        self.locationManagerAuthentication()
        self.timingsLbl.layer.cornerRadius = 10
        self.questionBtn.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
        self.aboutustableview?.register(UINib(nibName: "AboutusTableViewCell", bundle: nil), forCellReuseIdentifier: "AboutusTableViewCell")
        self.aboutustableview?.register(UINib(nibName: "AboutUsExtraTableViewCell", bundle: nil), forCellReuseIdentifier: "AboutUsExtraTableViewCell")
        self.aboutustableview.register(UINib(nibName: "AboutUsDescriptionTableViewCell",bundle: nil), forCellReuseIdentifier: "AboutUsDescriptionTableViewCell")
        
        self.aboutustableview.separatorStyle = .none
        self.aboutustableview.rowHeight = UITableViewAutomaticDimension
        self.aboutustableview.estimatedRowHeight = 10.0
        
        self.view.backgroundColor = CXAppConfig.sharedInstance.getAppBGColor()
        self.aboutustableview.backgroundColor = UIColor.clear
        
        self.aboutustableview.backgroundColor = CXAppConfig.sharedInstance.getAppBGColor()

        self.titleLbl.text = aboutUsDict.value(forKeyPath: "Name") as? String
        //self.titleLbl.textColor = CXAppConfig.sharedInstance.getAppTheamColor()
        let imgUrl = UserDefaults.standard.value(forKey: "CoverImage")
        if (imgUrl != nil){
            self.aboutusimageview.sd_setImage(with: URL(string: imgUrl! as! String))
        }else{
            self.aboutusimageview.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
        }
        
        rateView.rating = Float((self.aboutUsDict.value(forKeyPath: "overallRating") as? String)!)!
        rateLbl.text = ("\(rateView.rating)/5 Ratings")
        //\self.aboutusimageview.addSubview(overlay)
        self.weekDayCalculation()
    }
    
    func locationManagerAuthentication(){
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func weekDayCalculation(){
        
        let date = Date()
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.day , .month , .year], from: date)
        
        let year =  components.year
        let month = components.month
        let day = components.day

        let weekday = getDayOfWeek(today: "\(year!)-\(month!)-\(day!)")//yyyy-mm-dd
/*
        let hrsOfOperation = self.aboutUsDict.value(forKey: "hrsOfOperation")as! NSArray
        switch weekday {
        case 1:
            let dayOperations = hrsOfOperation[0] as! NSDictionary
            self.timingsLbl.text = "OPEN TILL \(dayOperations.value(forKey: "endTime") as! String) TODAY"
        case 2:
            let dayOperations = hrsOfOperation[6] as! NSDictionary
            self.timingsLbl.text = "OPEN TILL \(dayOperations.value(forKey: "endTime") as! String) TODAY"
        case 3:
            let dayOperations = hrsOfOperation[5] as! NSDictionary
            self.timingsLbl.text = "OPEN TILL \(dayOperations.value(forKey: "endTime") as! String) TODAY"
        case 4:
            let dayOperations = hrsOfOperation[4] as! NSDictionary
            self.timingsLbl.text = "OPEN TILL \(dayOperations.value(forKey: "endTime") as! String) TODAY"
        case 5:
            let dayOperations = hrsOfOperation[3] as! NSDictionary
            self.timingsLbl.text = "OPEN TILL \(dayOperations.value(forKey: "endTime") as! String) TODAY"
        case 6:
            let dayOperations = hrsOfOperation[2] as! NSDictionary
            self.timingsLbl.text = "OPEN TILL \(dayOperations.value(forKey: "endTime") as! String) TODAY"
        case 7:
            let dayOperations = hrsOfOperation[1] as! NSDictionary
            self.timingsLbl.text = "OPEN TILL \(dayOperations.value(forKey: "endTime") as! String) TODAY"
        default:break
        }
 */
 
    }
    
    func availability() -> String {
        let date = Date()
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.day , .month , .year], from: date)
        
        let year =  components.year
        let month = components.month
        let day = components.day
        
        let weekday = getDayOfWeek(today: "\(year!)-\(month!)-\(day!)")//yyyy-mm-dd

        let hrsOfOperation = self.aboutUsDict.value(forKey: "hrsOfOperation")as! NSArray
        
        switch weekday {
        case 1:
            let dayOperations = hrsOfOperation[0] as! NSDictionary
            str = "Closed Today"
        case 2:
            let dayOperations = hrsOfOperation[6] as! NSDictionary
            str = "\(dayOperations.value(forKey: "startTime") as! String) to \(dayOperations.value(forKey: "endTime") as! String)"
        case 3:
            let dayOperations = hrsOfOperation[5] as! NSDictionary
            str = "\(dayOperations.value(forKey: "startTime") as! String) to \(dayOperations.value(forKey: "endTime") as! String)"
        case 4:
            let dayOperations = hrsOfOperation[4] as! NSDictionary
            str = "\(dayOperations.value(forKey: "startTime") as! String) to \(dayOperations.value(forKey: "endTime") as! String)"
        case 5:
            let dayOperations = hrsOfOperation[3] as! NSDictionary
            str = "\(dayOperations.value(forKey: "startTime") as! String) to \(dayOperations.value(forKey: "endTime") as! String)"
        case 6:
            let dayOperations = hrsOfOperation[2] as! NSDictionary
            str = "\(dayOperations.value(forKey: "startTime") as! String) to \(dayOperations.value(forKey: "endTime") as! String)"
        case 7:
            let dayOperations = hrsOfOperation[1] as! NSDictionary
            str = "\(dayOperations.value(forKey: "startTime") as! String) to \(dayOperations.value(forKey: "endTime") as! String)"
        default:break
        }
        return str
    }
    
    func getStores(){
        
        let productEn = NSEntityDescription.entity(forEntityName: "CX_Stores", in: NSManagedObjectContext.mr_contextForCurrentThread())
        //Predicate predicateWithFormat:@"SUBQUERY(models, $m, ANY $m.trims IN %@).@count > 0",arrayOfTrims];
        let predicate:NSPredicate =  NSPredicate(format: "itemCode contains[c] %@",CXAppConfig.sharedInstance.getAppMallID())
        let fetchRequest = CX_Stores.mr_requestAllSorted(by: "itemCode", ascending: true)
        fetchRequest?.predicate = predicate
        fetchRequest?.entity = productEn
        self.aboutUsArray = CX_Stores.mr_executeFetchRequest(fetchRequest) as NSArray
        let storesEntity : CX_Stores = self.aboutUsArray.lastObject as! CX_Stores
        self.aboutUsDict = CXConstant.sharedInstance.convertStringToDictionary(storesEntity.json!)
        
    }
    
    // getting day of the week
    func getDayOfWeek(today:String)->Int {
        
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayDate = formatter.date(from: today)!
        let myCalendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let myComponents = (myCalendar as NSCalendar).components(.weekday, from: todayDate)
        let weekDay = myComponents.weekday
        return weekDay!
    }

    
    // pragma mark - delegate
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if (self.aboutUsDict.value(forKeyPath: "Description") as?String) == ""{
            return 3
        }else{
            return 5
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
            
            if indexPath.section == 0{
                
                let aboutUsDescription:AboutUsDescriptionTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "AboutUsDescriptionTableViewCell") as? AboutUsDescriptionTableViewCell
                aboutUsDescription.selectionStyle = .none
                
                aboutUsDescription.aboutUSLbl.font = CXAppConfig.sharedInstance.appLargeFont()
                aboutUsDescription.aboutUsDesc.font = CXAppConfig.sharedInstance.appMediumFont()
                aboutUsDescription.aboutUsDesc.text = self.aboutUsDict.value(forKey: "Description") as? String
                
                return aboutUsDescription
                
            }else if indexPath.section == 1{
                
                let aboutUs:AboutusTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "AboutusTableViewCell") as? AboutusTableViewCell
                aboutUs.selectionStyle = .none
                
                aboutUs.aboutusDescriptionlabel.text = self.aboutUsDict.value(forKeyPath: "Address") as?String
                aboutUs.aboutusDescriptionlabel.font = CXAppConfig.sharedInstance.appMediumFont()
                aboutUs.aboutusrootLabel.text = "We are Located in"
                aboutUs.aboutuskmLabel.text = "\(mallDistance) KM Away"
                aboutUs.aboutuskmLabel.font = CXAppConfig.sharedInstance.appMediumFont()
                aboutUs.aboutusrootLabel.font = CXAppConfig.sharedInstance.appLargeFont()
                aboutUs.aboutusgoogleLabel.addTarget(self, action: #selector(AboutUsViewController.viewMapAction(_:)), for: UIControlEvents.touchUpInside)
                aboutUs.aboutuskmLabel.isHidden = false
                aboutUs.aboutusgoogleLabel.isHidden = false
                
                return aboutUs
                
            }else {
                let aboutUsExtra:AboutUsExtraTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "AboutUsExtraTableViewCell") as? AboutUsExtraTableViewCell
                aboutUsExtra.selectionStyle = .none
                
                if indexPath.section == 2{
                    aboutUsExtra.extraTitleLbl.text = "We're happily available from"
                    aboutUsExtra.extraTitleLbl.font = CXAppConfig.sharedInstance.appLargeFont()
                    //aboutUsExtra.extraDescLbl.text = self.availability()
                    aboutUsExtra.extraDescLbl.font = CXAppConfig.sharedInstance.appMediumFont()
                    aboutUsExtra.callBtn.isHidden = true
                }else if indexPath.section == 3{
                    aboutUsExtra.extraTitleLbl.text = "You can reach us at"
                    aboutUsExtra.extraTitleLbl.font = CXAppConfig.sharedInstance.appLargeFont()
                    aboutUsExtra.extraDescLbl.text = self.aboutUsDict.value(forKeyPath: "Contact Number") as?String //"9640339556"//mobile
                    aboutUsExtra.extraDescLbl.font = CXAppConfig.sharedInstance.appMediumFont()
                    aboutUsExtra.callBtn.isHidden = false
                    aboutUsExtra.callBtn.addTarget(self, action: #selector(AboutUsViewController.callAction(_:)), for: .touchUpInside)
                }else if indexPath.section == 4{
                    aboutUsExtra.extraTitleLbl.text = ""
                    aboutUsExtra.extraTitleLbl.font = CXAppConfig.sharedInstance.appLargeFont()
                    aboutUsExtra.extraDescLbl.text = self.aboutUsDict.value(forKeyPath: "Primary Number") as?String //"9640339556"//mobile
                    aboutUsExtra.extraDescLbl.font = CXAppConfig.sharedInstance.appMediumFont()
                    aboutUsExtra.callBtn.isHidden = false
                    aboutUsExtra.callBtn.addTarget(self, action: #selector(AboutUsViewController.callAction(_:)), for: .touchUpInside)
                
                }
                return aboutUsExtra
            }
        }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 5.0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if (self.aboutUsDict.value(forKeyPath: "Description") as?String) == ""{
            
            if indexPath.section == 0{
                return UITableViewAutomaticDimension
            }else {
                return 70
            }
            
        }else {
            
            if indexPath.section == 0{
                return UITableViewAutomaticDimension
            }else if indexPath.section == 1 {
                return UITableViewAutomaticDimension
            }else if indexPath.section == 4 {
                return 50
            }else {
                return 70
            }
        }
    }
    
    @IBAction func askUsAction(_ sender: Any) {
        let act = ServiceFormViewController()
        self.navigationController?.pushViewController(act, animated: true)
    }

    
    func viewMapAction(_ button : UIButton!){
        
       // self.navigationController?.drawerToggle()
        let mapViewCnt : MapViewCntl = MapViewCntl()
        mapViewCnt.lat = Double(self.aboutUsDict.value(forKeyPath: "Latitude") as! String!)
        mapViewCnt.lon = Double(self.aboutUsDict.value(forKeyPath: "Longitude") as! String!)
        self.navigationController!.pushViewController(mapViewCnt, animated: true)
    }
    
    func distanceBetweenTwoLocations(_ source:CLLocation,destination:CLLocation) -> Double{
        
        let distanceMeters = source.distance(from: destination)
        let distanceKM = distanceMeters / 1000
        let roundedTwoDigit = distanceKM.roundedTwoDigit
        return roundedTwoDigit
        
    }
    
    func callAction(_ button:UIButton!){
        let website = self.aboutUsDict.value(forKeyPath: "Contact Number") as! String!
        callNumber(website!)
    }
    
    fileprivate func callNumber(_ phoneNumber:String) {
        UIApplication.shared.openURL(URL(string: "tel://\(phoneNumber)")!)
    }
    
    //MAR:Heder options enable
    override  func shouldShowRightMenu() -> Bool{
        return true
    }
    
    override func shouldShowNotificatoinBell() ->Bool{
        return false
    }
    
    override func shouldShowCart() -> Bool{
        return false
    }
    
    override func headerTitleText() -> String{
        return "About Us"
    }
    
    override func shouldShowLeftMenu() -> Bool{
        return true
    }
    override func showLogoForAboutUs() -> Bool{
        return true
    }
    
    override func profileDropdown() -> Bool{
        return false
    }
    
    override func profileDropdownForSignIn() -> Bool{
        return false
    }
    
    override func shouldShowLeftMenuWithLogo() -> Bool{
        return false
    }
}

extension AboutUsViewController{

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        self.mallDistance = String(mallDistance(locValue.latitude, currentLon: locValue.longitude))
    }
    
    func mallDistance(_ currentLat:Double,currentLon:Double) -> Double{
        
        let currentLat:Double = currentLat
        let currentLon:Double = currentLon
        let myLocation:CLLocation = CLLocation(latitude:currentLat, longitude: currentLon)
        let lat = self.aboutUsDict.value(forKeyPath: "Latitude") as! String!
        let long = self.aboutUsDict.value(forKeyPath: "Longitude") as! String!
        
        if lat == "" || long == ""{
        //self.showAlertViewWithTitle(title: "Warning", message: "No latitude and longitude ")
        }else{
        let mallLocation = CLLocation(latitude: Double(self.aboutUsDict.value(forKeyPath: "Latitude") as! String!)!, longitude: Double(self.aboutUsDict.value(forKeyPath: "Longitude") as! String!)!)
        let distance =  distanceBetweenTwoLocations(myLocation, destination: mallLocation)
        
        return distance
        }
        return 0
        
    }
    
    //MARK: Alert showing
    func showAlertViewWithTitle(title : String,message:String) -> Void {
        let alertController : UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            NSLog("OK Pressed")
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
