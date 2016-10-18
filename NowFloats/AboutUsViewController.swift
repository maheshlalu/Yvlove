//
//  ViewController.swift
//  NowfloatAboutus
//
//  Created by apple on 13/09/16.
//  Copyright © 2016 apple. All rights reserved.
//

import UIKit
import Foundation

class AboutUsViewController: CXViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var timingsLbl: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var questionBtn: UIButton!
    @IBOutlet weak var aboutusimageview: UIImageView!
    @IBOutlet weak var aboutustableview: UITableView!
    @IBOutlet weak var rateLbl: UILabel!
    @IBOutlet weak var rateView: FloatRatingView!
    
    var str:String = ""
    var aboutUsArray : NSArray!
    var aboutUsDict: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getStores()
        self.timingsLbl.layer.cornerRadius = 10
        self.questionBtn.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
        self.aboutustableview?.registerNib(UINib(nibName: "AboutusTableViewCell", bundle: nil), forCellReuseIdentifier: "AboutusTableViewCell")
        self.aboutustableview?.registerNib(UINib(nibName: "AboutUsExtraTableViewCell", bundle: nil), forCellReuseIdentifier: "AboutUsExtraTableViewCell")
        self.aboutustableview.registerNib(UINib(nibName: "AboutUsDescriptionTableViewCell",bundle: nil), forCellReuseIdentifier: "AboutUsDescriptionTableViewCell")
        
        self.aboutustableview.separatorStyle = .None
        self.aboutustableview.rowHeight = UITableViewAutomaticDimension
        self.aboutustableview.estimatedRowHeight = 10.0
        
        self.view.backgroundColor = CXAppConfig.sharedInstance.getAppBGColor()
        self.aboutustableview.backgroundColor = UIColor.clearColor()
        
        self.aboutustableview.backgroundColor = CXAppConfig.sharedInstance.getAppBGColor()

        self.titleLbl.text = aboutUsDict.valueForKeyPath("Name") as? String
        let imgUrl = aboutUsDict.valueForKey("Image_URL") as?String
        if (imgUrl != nil){
            self.aboutusimageview.sd_setImageWithURL(NSURL(string: imgUrl!))
        }else{
            self.aboutusimageview.backgroundColor = CXAppConfig.sharedInstance.getAppBGColor()
        }
        
        rateView.rating = Float((self.aboutUsDict.valueForKeyPath("overallRating") as? String)!)!
        rateLbl.text = ("\(rateView.rating)/5 Ratings")
        //self.aboutusimageview.addSubview(overlay)
        self.weekDayCalculation()
    }
    
    func weekDayCalculation(){
        
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: date)
        
        let year =  components.year
        let month = components.month
        let day = components.day

        let weekday = getDayOfWeek("\(year)-\(month)-\(day)")//yyyy-mm-dd
        print(weekday)

        let hrsOfOperation = self.aboutUsDict.valueForKey("hrsOfOperation")as! NSArray
        print(hrsOfOperation.description)
        
        switch weekday {
        case 1:
            print("Sunday")
            let dayOperations = hrsOfOperation[0] as! NSDictionary
            print(dayOperations.valueForKey("endTime"))
            self.timingsLbl.text = "OPEN TILL \(dayOperations.valueForKey("endTime") as! String) TODAY"
        case 2:
            print("Monday")
            let dayOperations = hrsOfOperation[6] as! NSDictionary
            print(dayOperations.valueForKey("endTime"))
            self.timingsLbl.text = "OPEN TILL \(dayOperations.valueForKey("endTime") as! String) TODAY"
        case 3:
            print("Tuesday")
            let dayOperations = hrsOfOperation[5] as! NSDictionary
            print(dayOperations.valueForKey("endTime"))
            self.timingsLbl.text = "OPEN TILL \(dayOperations.valueForKey("endTime") as! String) TODAY"
        case 4:
            print("Wednesday")
            let dayOperations = hrsOfOperation[4] as! NSDictionary
            print(dayOperations.valueForKey("endTime"))
            self.timingsLbl.text = "OPEN TILL \(dayOperations.valueForKey("endTime") as! String) TODAY"
        case 5:
            print("Thursday")
            let dayOperations = hrsOfOperation[3] as! NSDictionary
            print(dayOperations.valueForKey("endTime"))
            self.timingsLbl.text = "OPEN TILL \(dayOperations.valueForKey("endTime") as! String) TODAY"
        case 6:
            print("Friday")
            let dayOperations = hrsOfOperation[2] as! NSDictionary
            print(dayOperations.valueForKey("endTime"))
            self.timingsLbl.text = "OPEN TILL \(dayOperations.valueForKey("endTime") as! String) TODAY"
        case 7:
            print("Saturday")
            let dayOperations = hrsOfOperation[1] as! NSDictionary
            print(dayOperations.valueForKey("endTime"))
            self.timingsLbl.text = "OPEN TILL \(dayOperations.valueForKey("endTime") as! String) TODAY"
        default:break
        }
 
    }
    
    
    
    func availability() -> String {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: date)
        
        let year =  components.year
        let month = components.month
        let day = components.day
        
        let weekday = getDayOfWeek("\(year)-\(month)-\(day)")//yyyy-mm-dd
        print(weekday)

        let hrsOfOperation = self.aboutUsDict.valueForKey("hrsOfOperation")as! NSArray
        print(hrsOfOperation.description)
        
        switch weekday {
        case 1:
            print("Sunday")
            let dayOperations = hrsOfOperation[0] as! NSDictionary
            str = "\(dayOperations.valueForKey("startTime") as! String) to \(dayOperations.valueForKey("endTime") as! String)"
        case 2:
            print("Monday")
            let dayOperations = hrsOfOperation[6] as! NSDictionary
            str = "\(dayOperations.valueForKey("startTime") as! String) to \(dayOperations.valueForKey("endTime") as! String)"
        case 3:
            print("Tuesday")
            let dayOperations = hrsOfOperation[5] as! NSDictionary
            str = "\(dayOperations.valueForKey("startTime") as! String) to \(dayOperations.valueForKey("endTime") as! String)"
        case 4:
            print("Wednesday")
            let dayOperations = hrsOfOperation[4] as! NSDictionary
            str = "\(dayOperations.valueForKey("startTime") as! String) to \(dayOperations.valueForKey("endTime") as! String)"
        case 5:
            print("Thursday")
            let dayOperations = hrsOfOperation[3] as! NSDictionary
            str = "\(dayOperations.valueForKey("startTime") as! String) to \(dayOperations.valueForKey("endTime") as! String)"
        case 6:
            print("Friday")
            let dayOperations = hrsOfOperation[2] as! NSDictionary
            str = "\(dayOperations.valueForKey("startTime") as! String) to \(dayOperations.valueForKey("endTime") as! String)"
        case 7:
            print("Saturday")
            let dayOperations = hrsOfOperation[1] as! NSDictionary
            str = "\(dayOperations.valueForKey("startTime") as! String) to \(dayOperations.valueForKey("endTime") as! String)"
        default:break
        }
        return str
    }
    
    func getStores(){
        
        let productEn = NSEntityDescription.entityForName("CX_Stores", inManagedObjectContext: NSManagedObjectContext.MR_contextForCurrentThread())
        //Predicate predicateWithFormat:@"SUBQUERY(models, $m, ANY $m.trims IN %@).@count > 0",arrayOfTrims];
        let predicate:NSPredicate =  NSPredicate(format: "itemCode contains[c] %@",CXAppConfig.sharedInstance.getAppMallID())
        let fetchRequest = CX_Stores.MR_requestAllSortedBy("itemCode", ascending: true)
        fetchRequest.predicate = predicate
        fetchRequest.entity = productEn
        self.aboutUsArray = CX_Stores.MR_executeFetchRequest(fetchRequest)
        
        let storesEntity : CX_Stores = self.aboutUsArray.lastObject as! CX_Stores

        self.aboutUsDict = CXConstant.sharedInstance.convertStringToDictionary(storesEntity.json!)
        print(aboutUsDict)
        
    }
    
    // getting day of the week
    func getDayOfWeek(today:String)->Int {
        
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayDate = formatter.dateFromString(today)!
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let myComponents = myCalendar.components(.Weekday, fromDate: todayDate)
        let weekDay = myComponents.weekday
        return weekDay
    }

    
    // pragma mark - delegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        if (self.aboutUsDict.valueForKeyPath("Description") as?String) == ""{
            return 3
        }else{
            return 4
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        if (self.aboutUsDict.valueForKeyPath("Description") as?String) == ""{
            
            if indexPath.section == 0{
                let aboutUs:AboutusTableViewCell! = tableView.dequeueReusableCellWithIdentifier("AboutusTableViewCell") as? AboutusTableViewCell
                aboutUs.selectionStyle = .None
                
                aboutUs.aboutusDescriptionlabel.text = self.aboutUsDict.valueForKeyPath("Address") as?String
                aboutUs.aboutusDescriptionlabel.font = CXAppConfig.sharedInstance.appMediumFont()
                aboutUs.aboutusrootLabel.text = "We are Located in"
                aboutUs.aboutuskmLabel.font = CXAppConfig.sharedInstance.appMediumFont()
                aboutUs.aboutusrootLabel.font = CXAppConfig.sharedInstance.appLargeFont()
                aboutUs.aboutusgoogleLabel.addTarget(self, action: #selector(AboutUsViewController.viewMapAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                aboutUs.aboutuskmLabel.hidden = false
                aboutUs.aboutusgoogleLabel.hidden = false
                
                return aboutUs
                
            }else{
                
                let aboutUsExtra:AboutUsExtraTableViewCell! = tableView.dequeueReusableCellWithIdentifier("AboutUsExtraTableViewCell") as? AboutUsExtraTableViewCell
                aboutUsExtra.selectionStyle = .None
                
                if indexPath.section == 1{
                    aboutUsExtra.extraTitleLbl.text = "We're happily available from"
                    aboutUsExtra.extraTitleLbl.font = CXAppConfig.sharedInstance.appLargeFont()
                    aboutUsExtra.extraDescLbl.text = self.availability()
                    aboutUsExtra.extraDescLbl.font = CXAppConfig.sharedInstance.appMediumFont()
                }else if indexPath.section == 2{
                    aboutUsExtra.extraTitleLbl.text = "You can reach us at"
                    aboutUsExtra.extraTitleLbl.font = CXAppConfig.sharedInstance.appLargeFont()
                    aboutUsExtra.extraDescLbl.text = self.aboutUsDict.valueForKeyPath("Contact Number") as?String //"9640339556"//mobile
                    aboutUsExtra.extraDescLbl.font = CXAppConfig.sharedInstance.appMediumFont()
                    aboutUsExtra.callBtn.hidden = false
                    aboutUsExtra.callBtn.addTarget(self, action: #selector(AboutUsViewController.callAction(_:)), forControlEvents: .TouchUpInside)
                }
                return aboutUsExtra
            }
            
        } else{
            
            if indexPath.section == 0{
                
                let aboutUsDescription:AboutUsDescriptionTableViewCell! = tableView.dequeueReusableCellWithIdentifier("AboutUsDescriptionTableViewCell") as? AboutUsDescriptionTableViewCell
                aboutUsDescription.selectionStyle = .None
                
                aboutUsDescription.aboutUSLbl.font = CXAppConfig.sharedInstance.appLargeFont()
                aboutUsDescription.aboutUsDesc.font = CXAppConfig.sharedInstance.appMediumFont()
                aboutUsDescription.aboutUsDesc.text = self.aboutUsDict.valueForKey("Description") as? String
                
                return aboutUsDescription
                
            }else if indexPath.section == 1{
                
                let aboutUs:AboutusTableViewCell! = tableView.dequeueReusableCellWithIdentifier("AboutusTableViewCell") as? AboutusTableViewCell
                aboutUs.selectionStyle = .None
                
                aboutUs.aboutusDescriptionlabel.text = self.aboutUsDict.valueForKeyPath("Address") as?String
                aboutUs.aboutusDescriptionlabel.font = CXAppConfig.sharedInstance.appMediumFont()
                aboutUs.aboutusrootLabel.text = "We are Located in"
                aboutUs.aboutuskmLabel.font = CXAppConfig.sharedInstance.appMediumFont()
                aboutUs.aboutusrootLabel.font = CXAppConfig.sharedInstance.appLargeFont()
                aboutUs.aboutusgoogleLabel.addTarget(self, action: #selector(AboutUsViewController.viewMapAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                aboutUs.aboutuskmLabel.hidden = false
                aboutUs.aboutusgoogleLabel.hidden = false
                
                return aboutUs
                
            }else {
                let aboutUsExtra:AboutUsExtraTableViewCell! = tableView.dequeueReusableCellWithIdentifier("AboutUsExtraTableViewCell") as? AboutUsExtraTableViewCell
                aboutUsExtra.selectionStyle = .None
                
                if indexPath.section == 2{
                    aboutUsExtra.extraTitleLbl.text = "We're happily available from"
                    aboutUsExtra.extraTitleLbl.font = CXAppConfig.sharedInstance.appLargeFont()
                    aboutUsExtra.extraDescLbl.text = self.availability()
                    aboutUsExtra.extraDescLbl.font = CXAppConfig.sharedInstance.appMediumFont()
                    aboutUsExtra.callBtn.hidden = true
                }else if indexPath.section == 3{
                    aboutUsExtra.extraTitleLbl.text = "You can reach us at"
                    aboutUsExtra.extraTitleLbl.font = CXAppConfig.sharedInstance.appLargeFont()
                    aboutUsExtra.extraDescLbl.text = self.aboutUsDict.valueForKeyPath("Contact Number") as?String //"9640339556"//mobile
                    aboutUsExtra.extraDescLbl.font = CXAppConfig.sharedInstance.appMediumFont()
                    aboutUsExtra.callBtn.hidden = false
                    aboutUsExtra.callBtn.addTarget(self, action: #selector(AboutUsViewController.callAction(_:)), forControlEvents: .TouchUpInside)
                }
                return aboutUsExtra
                
            }
        }
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 5.0
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if (self.aboutUsDict.valueForKeyPath("Description") as?String) == ""{
            
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
    func viewMapAction(button : UIButton!){
        
       // self.navigationController?.drawerToggle()
        let mapViewCnt : MapViewCntl = MapViewCntl()
        mapViewCnt.lat = Double(self.aboutUsDict.valueForKeyPath("Latitude") as! String!)
        mapViewCnt.lon = Double(self.aboutUsDict.valueForKeyPath("Longitude") as! String!)
        self.navigationController!.pushViewController(mapViewCnt, animated: true)
    }
    
    
    func callAction(button:UIButton!){
        
        let website = self.aboutUsDict.valueForKeyPath("Contact Number") as! String!
        callNumber(website!)
    }
    
    private func callNumber(phoneNumber:String) {
        UIApplication.sharedApplication().openURL(NSURL(string: "tel://\(phoneNumber)")!)
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

/*extension AboutUsViewController:FloatRatingViewDelegate{

    func floatRatingView(ratingView: FloatRatingView, isUpdating rating:Float) {
        //ratingView.rating = 0
        //        let signInView = CXSignInSignUpViewController.init()
        //        self.navigationController?.pushViewController(signInView, animated: true)
    }
    
    func floatRatingView(ratingView: FloatRatingView, didUpdate rating: Float) {
        //ratingView.rating = 0
        self.rateLbl.text = NSString(format: "%.1f", self.rateView.rating) as String
    }

}*/
/*
 
 {
 FacebookPageLink = 68MHolidays;
 address =     {
 city = Hyderabad;
 country =         {
 code = IN;
 id = 36;
 name = India;
 };
 id = 4;
 location = "3-6-365, Office no 8 & 9, Upper Ground Floor, Liberty Plaza, Himayath Nagar, 500029";
 state = "";
 };
 appInfo =     {
 ApplicationName = "68M Holidays";
 ApplicationType = Applications;
 Category = Business;
 "ConfirmEmailAddress:" = "anu.akilla@gmail.com";
 ContainsADS = No;
 ContentGuidelines = Yes;
 ContentRating = "Medium Maturity";
 Countries = India;
 Email = "anu.akilla@gmail.com";
 EmailAddress = "anu.akilla@gmail.com";
 FeatureGraphic = "http://nowfloats.ongostore.com/public/icons/H/res/splash_image.png";
 FullDescription = "";
 "Hi-ResIcon" = "http://nowfloats.ongostore.com/public/icons/H/res/splash_image.png";
 Language = No;
 Miscellaneous = No;
 Price = Free;
 PrivacyPolicy = Yes;
 ScreenShots =         {
 screenshot1 = "http://nowfloats.ongostore.com/public/images/screenshot/Screenshot_20160518-143039.png";
 screenshot2 = "http://nowfloats.ongostore.com/public/images/screenshot/Screenshot_20160518-143055.png";
 screenshot3 = "http://nowfloats.ongostore.com/public/images/screenshot/Screenshot_20160518-143103.png";
 screenshot4 = "http://nowfloats.ongostore.com/public/images/screenshot/Screenshot_20160518-143117.png";
 screenshot5 = "http://nowfloats.ongostore.com/public/images/screenshot/Screenshot_20160518-143125.png";
 };
 Sexuality = No;
 Title = "68M Holidays";
 "US_Export_Laws" = Yes;
 Violent = No;
 Website = "http://storeongo.com";
 appfeatures =         {
 Appfeature1 = "Quick and easy reach.";
 Appfeature2 = "Order instantly.";
 Appfeature3 = "Get rewards and points.";
 Appfeature4 = "Stay updated.";
 };
 };
 businessType =     (
 );
 category = Default;
 currencyType = INR;
 defaultStoreId = 157;
 defaultStoreItemCode = "1461411810987_11";
 description = "";
 email = "deals_sog@68m.in";
 fpApplicationId = A91B82DE3E93446A8141A52F288F69EFA1B09B1D13BB4E55BE743AB547B3489E;
 fpId = 5285de044ec0a40db49f06a3;
 fpTag = 68MHOLIDAYS;
 gallery =     (
 );
 hrsOfOperation =     (
 );
 "ic_launcher_hdpi" = "https://s3-ap-southeast-1.amazonaws.com/store-ongo/res/drawable-hdpi/11/ic_launcher.png";
 "ic_launcher_ldpi" = "https://s3-ap-southeast-1.amazonaws.com/store-ongo/res/drawable-ldpi/11/ic_launcher.png";
 "ic_launcher_mdpi" = "https://s3-ap-southeast-1.amazonaws.com/store-ongo/res/drawable-mdpi/11/ic_launcher.png";
 "ic_launcher_xhdpi" = "https://s3-ap-southeast-1.amazonaws.com/store-ongo/res/drawable-xhdpi/11/ic_launcher.png";
 "ic_launcher_xxhdpi" = "https://s3-ap-southeast-1.amazonaws.com/store-ongo/res/drawable-xxhdpi/11/ic_launcher.png";
 "ic_launcher_xxxhdpi" = "https://s3-ap-southeast-1.amazonaws.com/store-ongo/res/drawable-xxxhdpi/11/ic_launcher.png";
 id = 11;
 imageUrl = "https://s3-ap-southeast-1.amazonaws.com/store-ongo/users/images/2_14614118066821.jpg";
 languageCode = en;
 languageName = English;
 latitude = "17.4065312623762";
 logo = "https://s3-ap-southeast-1.amazonaws.com/store-ongo/users/images/11_1461743016987.png";
 logoUrl = "https://s3-ap-southeast-1.amazonaws.com/store-ongo/users/images/2_14614118079251.jpg";
 longitude = "78.4774737052879";
 mainCategory = "NowFloats Template";
 mobile = 9700077768;
 name = "68M Holidays";
 offersCount = 0;
 primaryColor = "#d72519";
 promotionURL = "http://nowfloats.ongostore.com/m/11/webapp";
 publicURL = "http://nowfloats.ongostore.com/application/m?orgid=11";
 secondaryColor = "#edfcfb";
 splashscreen = "https://s3-ap-southeast-1.amazonaws.com/store-ongo/res/drawable/11/splashscreen.png";
 storesCount = 1;
 tileImageUrl = "https://s3-ap-southeast-1.amazonaws.com/store-ongo/users/images/2_14614118079111.jpg";
 tinyLogoUrl = "https://s3-ap-southeast-1.amazonaws.com/store-ongo/users/images/2_14614118079641.jpg";
 website = "http://68mholidays.com";
 }

 
 */
