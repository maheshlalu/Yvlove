//
//  ViewController.swift
//  NowfloatAboutus
//
//  Created by apple on 13/09/16.
//  Copyright © 2016 apple. All rights reserved.
//

import UIKit

class AboutUsViewController: CXViewController,UITableViewDataSource,UITableViewDelegate {
    
    var nameArray = ["indiadhasgdhjgashjgdjhagsdhjgasdsadsadsadasgfhdgsafhdsjhfghjdsgfjhgdsjhfgjhgdfhgsgfjshdgfhgsdjgfsdgfgsdjgfdsgfgsdjfgsdgfjsdgfjgsdjfgsdgfjshdgfhsgd","america","newzealand"]
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var timingsLbl: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var questionBtn: UIButton!
    @IBOutlet weak var aboutusimageview: UIImageView!
    @IBOutlet weak var aboutustableview: UITableView!
    var aboutUsDic : NSDictionary!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.timingsLbl.layer.cornerRadius = 8.0
        self.questionBtn.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
        self.aboutustableview?.registerNib(UINib(nibName: "AboutusTableViewCell", bundle: nil), forCellReuseIdentifier: "AboutusTableViewCell")
        self.aboutustableview?.registerNib(UINib(nibName: "AboutUsExtraTableViewCell", bundle: nil), forCellReuseIdentifier: "AboutUsExtraTableViewCell")
        
        self.aboutustableview.separatorStyle = .None
        self.aboutustableview.rowHeight = UITableViewAutomaticDimension
        self.aboutustableview.estimatedRowHeight = 10.0
        
        self.view.backgroundColor = CXAppConfig.sharedInstance.getAppBGColor()
        self.aboutustableview.backgroundColor = UIColor.clearColor()
        //self.aboutustableview.backgroundColor = CXAppConfig.sharedInstance.getAppBGColor()
        let appdata:CX_SingleMall = CX_SingleMall.MR_findFirst() as! CX_SingleMall
        print(CXConstant.sharedInstance.convertStringToDictionary(appdata.json!))
       self.aboutUsDic = CXConstant.sharedInstance.convertStringToDictionary(appdata.json!)
       // sidepanelView()

        //logo = "https://s3-ap-southeast-1.amazonaws.com/store-ongo/users/images/11_1461743016987.png";
        
        
        self.titleLbl.text = aboutUsDic.valueForKeyPath("appInfo.ApplicationName") as? String
        self.aboutusimageview.sd_setImageWithURL(NSURL(string: (aboutUsDic.valueForKey("imageUrl") as?String)!))
        //self.aboutusimageview.addSubview(overlay)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return nameArray.count
 
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if indexPath.section == 0 {
            
            let aboutUs:AboutusTableViewCell! = tableView.dequeueReusableCellWithIdentifier("AboutusTableViewCell") as? AboutusTableViewCell
            aboutUs.selectionStyle = .None
            aboutUs.aboutusDescriptionlabel.text = self.aboutUsDic.valueForKeyPath("address.location") as?String
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
            
            if indexPath.section == 1{
                aboutUsExtra.extraTitleLbl.text = "We're happily available from"
                aboutUsExtra.extraTitleLbl.font = CXAppConfig.sharedInstance.appLargeFont()
                aboutUsExtra.extraDescLbl.text = "12:00Am to 11:30PM"
                aboutUsExtra.extraDescLbl.font = CXAppConfig.sharedInstance.appMediumFont()
            }else if indexPath.section == 2{
                aboutUsExtra.extraTitleLbl.text = "You can reacdh us at"
                aboutUsExtra.extraTitleLbl.font = CXAppConfig.sharedInstance.appLargeFont()
                aboutUsExtra.extraDescLbl.text = self.aboutUsDic.valueForKeyPath("mobile") as?String //"9640339556"//mobile
                aboutUsExtra.extraDescLbl.font = CXAppConfig.sharedInstance.appMediumFont()
                aboutUsExtra.callBtn.hidden = false
                aboutUsExtra.callBtn.addTarget(self, action: #selector(AboutUsViewController.callAction(_:)), forControlEvents: .TouchUpInside)
            }
            return aboutUsExtra
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 5.0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if indexPath.section == 0{
            return UITableViewAutomaticDimension
        }else{
            return 70
        }
    }
    
    /*func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }*/
    func viewMapAction(button : UIButton!){
        
       // self.navigationController?.drawerToggle()
        let mapViewCnt : MapViewCntl = MapViewCntl()
        mapViewCnt.lat = Double(self.aboutUsDic.valueForKeyPath("latitude") as! String!)
        mapViewCnt.lon = Double(self.aboutUsDic.valueForKeyPath("longitude") as! String!)
        self.navigationController!.pushViewController(mapViewCnt, animated: true)
    }
    
    
    func callAction(button:UIButton!){
        
        let website = self.aboutUsDic.valueForKeyPath("mobile") as! String!
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
