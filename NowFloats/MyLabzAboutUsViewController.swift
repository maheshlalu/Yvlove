//
//  MyLabzAboutUsViewController.swift
//  NowFloats
//
//  Created by Manishi on 12/19/16.
//  Copyright © 2016 CX. All rights reserved.
//


import UIKit
import Foundation
import CoreLocation

class MyLabzAboutUsViewController: CXViewController,UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate {
    
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
    var mallDistance:String = ""
    
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
        let imgUrl = aboutUsDict.value(forKey: "Image_URL") as?String
        if (imgUrl != nil){
            self.aboutusimageview.sd_setImage(with: URL(string: imgUrl!))
        }else{
            self.aboutusimageview.backgroundColor = CXAppConfig.sharedInstance.getAppBGColor()
        }
        
        rateView.rating = Float((self.aboutUsDict.value(forKeyPath: "overallRating") as? String)!)!
        rateLbl.text = ("\(rateView.rating)/5 Ratings")
        
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
        print(aboutUsDict)
        
    }
    
    
    // pragma mark - delegate
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 3
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
            aboutUs.aboutuskmLabel.text! = "\(mallDistance as String) KM Away"
            aboutUs.aboutuskmLabel.font = CXAppConfig.sharedInstance.appMediumFont()
            aboutUs.aboutusrootLabel.font = CXAppConfig.sharedInstance.appLargeFont()
            aboutUs.aboutusgoogleLabel.addTarget(self, action: #selector(AboutUsViewController.viewMapAction(_:)), for: UIControlEvents.touchUpInside)
            aboutUs.aboutuskmLabel.isHidden = false
            aboutUs.aboutusgoogleLabel.isHidden = false
            
            return aboutUs
            
        }else if indexPath.section == 2 {
            let aboutUsExtra:AboutUsExtraTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "AboutUsExtraTableViewCell") as? AboutUsExtraTableViewCell
            aboutUsExtra.selectionStyle = .none
            
            aboutUsExtra.extraTitleLbl.text = "You can reach us at"
            aboutUsExtra.extraTitleLbl.font = CXAppConfig.sharedInstance.appLargeFont()
            let website = self.aboutUsDict.value(forKeyPath: "Contact Number") as! String!
            let trimmedString = website?.trimmingCharacters(in: .whitespaces)
            aboutUsExtra.extraDescLbl.text = trimmedString!
            aboutUsExtra.extraDescLbl.font = CXAppConfig.sharedInstance.appMediumFont()
            aboutUsExtra.callBtn.isHidden = false
            aboutUsExtra.callBtn.addTarget(self, action: #selector(AboutUsViewController.callAction(_:)), for: .touchUpInside)
            
            return aboutUsExtra
        }
        return UITableViewCell()
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
            }else {
                return 70
            }
        }
    }
    
    /*func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
     return UITableViewAutomaticDimension
     }*/
    
    func viewMapAction(_ button : UIButton!){
        
        // self.navigationController?.drawerToggle()
        let mapViewCnt : MapViewCntl = MapViewCntl()
        mapViewCnt.lat = Double(self.aboutUsDict.value(forKeyPath: "Latitude") as! String!)
        mapViewCnt.lon = Double(self.aboutUsDict.value(forKeyPath: "Longitude") as! String!)
        self.navigationController!.pushViewController(mapViewCnt, animated: true)
    }
    
    @IBAction func questionBtnAction(_ sender: Any) {
        
        let signInViewCnt : ServiceFormViewController = ServiceFormViewController()
        self.navigationController?.pushViewController(signInViewCnt, animated: true)
        
    }
    
    func distanceBetweenTwoLocations(_ source:CLLocation,destination:CLLocation) -> Double{
        
        let distanceMeters = source.distance(from: destination)
        let distanceKM = distanceMeters / 1000
        let roundedTwoDigit = distanceKM.roundedTwoDigit
        return roundedTwoDigit
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        var string:String!
        string = mallDistance(locValue.latitude, currentLon: locValue.longitude)
        self.mallDistance = string
        //self.aboutustableview.reloadData()
    }
    
    func mallDistance(_ currentLat:Double,currentLon:Double) -> String{
        
        let currentLat:Double = currentLat
        let currentLon:Double = currentLon
        let myLocation:CLLocation = CLLocation(latitude:currentLat, longitude: currentLon)
        
        
        let mallLocation = CLLocation(latitude: Double(self.aboutUsDict.value(forKeyPath: "Latitude") as! String!)!, longitude: Double(self.aboutUsDict.value(forKeyPath: "Longitude") as! String!)!)
        let distance =  distanceBetweenTwoLocations(myLocation, destination: mallLocation)
        
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        
        let dist:NSNumber! = distance as NSNumber
        let distanceInKM = formatter.string(from: dist)
        
        return distanceInKM!
    }
    
    
    func callAction(_ button:UIButton!){
        
        let website = self.aboutUsDict.value(forKeyPath: "Contact Number") as! String!
        let trimmedString = website?.trimmingCharacters(in: .whitespaces)
        callNumber(trimmedString!)
    }
    
    
    func callNumber(_ phoneNumber:String) {
        UIApplication.shared.openURL(URL(string: "tel://\(phoneNumber)")!)
    }
    
    
    //MAR:Heder options enable
    override  func shouldShowRightMenu() -> Bool{
        
        return true
    }
    
    override func shouldShowNotificatoinBell() ->Bool{
        
        return false
    }
    
    override  func shouldShowCart() -> Bool{
        
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

/*{
 "Additional_Details" =     {
 };
 Address = "Sagar Trade Centre   State Highway 30  Kailash Nagar";
 Attachments =     (
 {
 Id = 104;
 "Image_Name" = "";
 URL = "";
 albumName = "Banner Images";
 isBannerImage = false;
 isCoverImage = false;
 mmType = 2;
 },
 {
 Id = 105;
 "Image_Name" = "1948A_1140X400.jpg";
 URL = "https://s3-ap-southeast-1.amazonaws.com/customerongocontent/92/JOB_ATTACHMENT/uploaded/files/12447_1480683638591.jpg";
 albumName = "Banner Images";
 isBannerImage = false;
 isCoverImage = true;
 mmType = 1;
 },
 {
 Id = 106;
 "Image_Name" = "pharm-shutterstock-89254516-486x250_2.jpg";
 URL = "https://s3-ap-southeast-1.amazonaws.com/customerongocontent/92/JOB_ATTACHMENT/uploaded/files/12447_1480683639218.jpg";
 albumName = "Banner Images";
 isBannerImage = false;
 isCoverImage = false;
 mmType = 1;
 }
 );
 Borough = "";
 "Category_Mall" = "Diagnostic Centres";
 City = Aurangabad;
 "Contact Number" = "70 28 365 365";
 Country = India;
 CreatedSubJobs =     (
 );
 "Current_Job_Status" = Active;
 "Current_Job_StatusId" = 2332;
 Description = "We, the MYLAB family have developed this solution as a first step to make healthcare at Fingertip and make comfort of home based lab related services. We know that Quality is the basis of all diagnostics services including blood tests and radio diagnosis. We assure only 100% quality services with a competitive rates at your fingertips. Our mission is to make the Quality services available on demand by any person at any time. We are the team of Medical professionals, IT professionals and paramedics through which we arrange the home based collection of blood and urine samples and deliver the reports to the persons at stipulated committed time without extra cost. Radiological tests availability and appointment are carried out by us on your request.";
 District = Aurangabad;
 FaceBook = "";
 Image = "";
 Insights =     (
 {
 Pinterest = 0;
 points = "0.0";
 },
 {
 Twitter = 0;
 points = "0.0";
 },
 {
 Hangouts = 0;
 points = "0.0";
 },
 {
 Linkedin = 0;
 points = "0.0";
 },
 {
 Instagram = 0;
 points = "0.0";
 },
 {
 Messaging = 0;
 points = "0.0";
 },
 {
 Gmail = 0;
 points = "0.0";
 },
 {
 "Google+" = 0;
 points = "0.0";
 },
 {
 Facebook = 0;
 points = "0.0";
 },
 {
 WhatsApp = 0;
 points = "0.0";
 },
 {
 Skype = 0;
 points = "0.0";
 },
 {
 "Campaigns Share" = 0;
 points = "0.0";
 },
 {
 "Campaigns Comment" = 0;
 points = "0.0";
 },
 {
 "Campaigns Favorite" = 0;
 points = "0.0";
 },
 {
 "Services Comment" = 0;
 points = "0.0";
 },
 {
 "Campaigns View" = 0;
 points = "0.0";
 },
 {
 "Services Share" = 0;
 points = "0.0";
 },
 {
 "Services Favorite" = 0;
 points = "0.0";
 },
 {
 "Services View" = 0;
 points = "0.0";
 },
 {
 "Offers Comment" = 0;
 points = "0.0";
 },
 {
 "Offers Favorite" = 0;
 points = "0.0";
 },
 {
 "Offers Share" = 0;
 points = "0.0";
 },
 {
 "Offers View" = 0;
 points = "0.0";
 },
 {
 "Products Buy" = 0;
 points = "0.0";
 },
 {
 "Products Comment" = 0;
 points = "0.0";
 },
 {
 "Products Share" = 0;
 points = "0.0";
 },
 {
 "Products Cart" = 0;
 points = "0.0";
 },
 {
 "Products View" = 0;
 points = "0.0";
 },
 {
 "Products Favorite" = 0;
 points = "0.0";
 },
 {
 Register = 0;
 points = "0.0";
 },
 {
 Login = 0;
 points = "0.0";
 }
 );
 ItemCode = "1480680220333_92";
 Latitude = "19.8766739";
 Longitude = "75.34289710000007";
 Name = "MY LAB Medisolutions Pvt. Ltd.";
 "Next_Job_Statuses" =     (
 {
 SeqNo = 2;
 "Status_Id" = 2333;
 "Status_Name" = Inactive;
 "Sub_Jobtype_Forms" =             (
 );
 }
 );
 "Next_Seq_Nos" = 2;
 PackageName = "";
 PostalCode = 431001;
 State = Maharashtra;
 Street = Mondha;
 Twitter = "";
 Type = ChIJbWgFwZ2i2zsRBxRwuAQolNk;
 Zoom = "";
 businessType =     (
 );
 createdByFullName = "My Labz";
 createdById = 92;
 createdOn = "12:03 Dec 2, 2016";
 guestUserEmail = "guest@storeongo.com";
 guestUserId = 14;
 hrsOfOperation =     (
 );
 id = 12447;
 jobComments =     (
 );
 jobTypeId = 1029;
 jobTypeName = Stores;
 lastModifiedDate = "05-12-2016 07:33:12:00";
 offersCount = "-1";
 overallRating = "0.0";
 productsCount = "-1";
 publicURL = "http://storeongo.com/app/92/Stores;Stores;12447;_;SingleProduct";
 totalReviews = 0;
 }
 nav controlller <MyLabs.MyLabzAboutUsViewController: 0x797cf3a0>
 2016-12-19 14:02:44.714150 MyLabs[4168:62469] [LayoutConstraints] Unable to simultaneously satisfy constraints.
	Probably at least one of the constraints in the following list is one you don't want.
	Try this:
 (1) look at each constraint and try to figure out which you don't expect;
 (2) find the code that added the unwanted constraint or constraints and fix it.
 (
 "<NSLayoutConstraint:0x797fb6e0 UILabel:0x7971fb70'Sagar Trade Centre   Stat...'.width == 362   (active)>",
 "<NSLayoutConstraint:0x7971bc40 H:|-(8)-[UILabel:0x7971fb70'Sagar Trade Centre   Stat...']   (active, names: '|':UITableViewCellContentView:0x7971ddc0 )>",
 "<NSLayoutConstraint:0x7971bcb0 H:[UILabel:0x7971fb70'Sagar Trade Centre   Stat...']-(8)-|   (active, names: '|':UITableViewCellContentView:0x7971ddc0 )>",
 "<NSLayoutConstraint:0x7b655130 'fittingSizeHTarget' UITableViewCellContentView:0x7971ddc0.width == 310   (active)>"
 )
 
 Will attempt to recover by breaking constraint
 <NSLayoutConstraint:0x797fb6e0 UILabel:0x7971fb70'Sagar Trade Centre   Stat...'.width == 362   (active)>
 
 Make a symbolic breakpoint at UIViewAlertForUnsatisfiableConstraints to catch this in the debugger.
 The methods in the UIConstraintBasedLayoutDebugging category on UIView listed in <UIKit/UIView.h> may also be helpful.
 nav controlller <MyLabs.MapViewCntl: 0x7aa1d600>
 Errors: The operation couldn’t be completed. (kCLErrorDomain error 0.)
 nav controlller <MyLabs.MyLabzAboutUsViewController: 0x797cf3a0>
*/


