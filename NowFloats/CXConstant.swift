//
//  CXconstant.swift
//  SampleSwiftTable
//
//  Created by Rama kuppa on 27/03/16.
//  Copyright © 2016 Sarath. All rights reserved.
//

import UIKit



var IPHONE_4S = "iPhone_4s"
var IPHONE_5S = "iPhone_5s"
var IPHONE_6 = "iPhone_6"
var IPHONE_6PLUS = "iPhone_6Plus"
var NOT_IPHONE = "Not_iPhone"

private var _SingletonSharedInstance:CXConstant! = CXConstant()




class CXConstant: NSObject {
    
    class var sharedInstance : CXConstant {
        return _SingletonSharedInstance
    }
    
    fileprivate override init() {
        
    }
    
    func destory () {
        _SingletonSharedInstance = nil
    }
    
    
    static let homeScreenTableViewHeight : CGFloat = 225
    static let tableViewHeigh : CGFloat = 275
    
    static let someString : String = "Some Text" // struct
    static let collectiViewCellSize :  CGSize = CGSize(width: UIScreen.main.bounds.size.width-20,height: tableViewHeigh)
    
    static let collectionViewFrame : CGRect = CGRect(x: 8, y: 30, width: UIScreen.main.bounds.size.width-20, height: tableViewHeigh-50)
    
    static let HOME_COLLECTION_FRAME : CGRect = CGRect(x: 10, y: 20, width: UIScreen.main.bounds.size.width-20, height: tableViewHeigh-50)
    
    static let titleLabelColor : UIColor = UIColor(red: 240.0/255.0, green: 40.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    
    
    static let collectionCellborderColor : UIColor = UIColor(red: 191.0/255.0, green: 191.0/255.0, blue: 191.0/255.0, alpha: 1.0)
    
    
    static let DetailTableView_Width = UIScreen.main.bounds.width-20
    // static let DetailCollectionCellSize :  CGSize = CGSize(width: 180,height: tableViewHeigh-50)
    static let DetailCollectionCellSize :  CGSize = CGSize(width: 135,height: tableViewHeigh-50)
    
    //135, 200
    
    //CGSize(width: UIScreen.mainScreen().bounds.size.width-20,height: tableViewHeigh-50)
    
    ///
    
    static let DetailCollectionViewFrame : CGRect = CGRect(x: 4, y: 10, width: DetailTableView_Width-8, height: tableViewHeigh-50)
    
    
    
    static let DETAIL_IMAGE_TABLE_WIDTH:CGFloat = UIScreen.main.bounds.width-20
    static let DETAIL_IMAGE_CELL_HEIGHT:CGFloat = DETAIL_IMAGE_TABLE_WIDTH/2
    
    static let RELATED_ARTICLES_CELL_HEIGHT:CGFloat = 280
    
    
    static let PRODUCT_CELL_HEIGHT:CGFloat = PRODUCT_IMAGE_HEIGHT+55
    
    static let PRODUCT_IMAGE_HEIGHT:CGFloat = (UIScreen.main.bounds.width - 8)/2
    
    
    
    
    //CGRectMake(8, 30, UIScreen.mainScreen().bounds.size.width-20, tableViewHeigh-50)
    
    //
    
    static let HOME_BANNAER = "/133516651/AppHome"
    static let TOLLYWOOD_BANNAER = "/133516651/AppTollyBanner"
    static let BOLLYWOOD_BANNAER = "/133516651/AppBollyBanner"
    static let HOLLYWOOD_BANNAER = "/133516651/AppHollyBanner"
    static let KOLLYWOOD_BANNAER = "/133516651/AppKollyBanner"
    static let MOLLYWOOD_BANNAER = "/133516651/AppMollyBanner"
    static let SANDALWOOD_BANNAER = "/133516651/AppSandalBanner"
    
    
    // BrightCove Directives
    
    //   static let kViewControllerPlaybackServicePolicyKey = "BCpkADawqM2oOQVwTaK5uvR6L0gtvjmrZCT88aVOc6a3n2Mw7BBVAImkiPF27Xr4lDTnN1D1qL4motncIJf55cdpQB6oR147RsXjI4PecVoyvWgQ_Or7fNyT5Nglba1hUpt"
    
    static let kViewControllerPlaybackServicePolicyKey = "BCpkADawqM2oOQVwTaK5uvR6L0gtvjmrZCT88aVOc6a3n2Mw7BBVAImkiPF27Xr4lDTnN1D1qL4motncIJf55cdpQB6oR147RsXjI4PecVoyvWgQ_Or7fNyT5Nglba1hUpt-LRW23BinBju-"
    
    // static let kViewControllerAccountID = "4652941494001"
    
    
    static let kViewControllerAccountID = "4652941494001"//4652941494001
    
    //let kViewControllerVideoID = "3987127390001"
    
    //Url for Appstore
    
    static let appStoreUrl = "https://itunes.apple.com/in/app/sillymonks/id1125296777?mt=8"
    
    
    
    // Sevices URLs
    static let MALL_ID = "3"
    static let ALL_MALLS_URL = "http://52.74.102.199:8081/services/getmasters?type=allMalls"
    static let SINGLE_MALL_URL = "http://m.sillymonks.com:8081/Services/getMasters?type=singleMall&mallId=" //3
    static let STORE_URL = "http://52.74.102.199:8081/services/getmasters?type=stores&mallId="
    static let NATIVEADD_UNITI_ID = "4af8f892da924673aa0d9db92b49cc10"
    static let mopub_interstitial_ad_id = "5d84bf5a4e5c415a923b042dee24bafa"
    static let mopub_banner_ad_id = "b51640c1ff19442184e783f55e0428c3"
    static let mopub_medium_ad_id = "6a6b023340914879a2cd52f8169fc98c"


    //b51640c1ff19442184e783f55e0428c3
    static let PRODUCT_CATEGORY_URL = "http://52.74.102.199:8081/services/getmasters?type=ProductCategories&mallId="
    
    
    static func restrictRotation(_ isRestricted: Bool) {
       // let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
      //  appDelegate.restrictRotation = isRestricted
        
    }
    
    
    
    
    
    func productURL(_ productType:String, mallId: String) -> String {
        let escapedString = productType.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let reqString = "http://52.74.102.199:8081/services/getmasters?type="+escapedString!+"&mallId="+mallId
        return reqString
    }
    
    func checkProductCountURL(_ productType:String, mallId: String) -> String {
        let escapedString = productType.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let reqString = "http://sillymonksapp.com:8081/Services/categoryJobsCount?"+"mallId="+mallId+"&type="+escapedString!
        //http://sillymonksapp.com:8081/Services/categoryJobsCount?mallId=3&type=movies
        //type="+escapedString!
        return reqString
    }
    
    
    func saveTheFid(_ storeID:String){
          print(storeID)
        UserDefaults.standard.set(storeID, forKey: "FID")
        
    }
    
    func getTheFid()-> String{
        
      return ""
        return (UserDefaults.standard.object(forKey: "FID") as? String)!
    }
    
    static func resultString(_ input: AnyObject) -> String{
        if let value: AnyObject = input {
            var reqType : String!
            switch value {
            case let i as NSNumber:
                reqType = "\(i)"
            case let s as NSString:
                reqType = "\(s)"
            case let a as NSArray:
                reqType = "\(a.object(at: 0))"
            default:
                reqType = "Invalid Format"
            }
            return reqType
        }
        return ""
    }
    
    func convertDictionayToString(_ dictionary:NSDictionary) -> NSString {
        var dataString: String!
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
            //print("JSON data is \(jsonData)")
            dataString = String(data: jsonData, encoding: String.Encoding.utf8)
            //print("Converted JSON string is \(dataString)")
            // here "jsonData" is the dictionary encoded in JSON data
        } catch let error as NSError {
            dataString = ""
            print(error)
        }
        return dataString as NSString
    }
    
    func convertStringToDictionary(_ string:String) -> NSDictionary {
        var jsonDict : NSDictionary = NSDictionary()
        let data = string.data(using: String.Encoding.utf8)
        do {
            jsonDict = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.mutableContainers ) as! NSDictionary            // CXDBSettings.sharedInstance.saveAllMallsInDB((jsonData.valueForKey("orgs") as? NSArray)!)
        } catch {
            //print("Error in parsing")
        }
        return jsonDict
    }
    
    static func getImageFromUrlString(_ imgUrlString:String) ->UIImage {
        
        if let imgUrl = URL(string:imgUrlString) {
            if let cImageData = try? Data(contentsOf: imgUrl) {
                let cImage = UIImage(data: cImageData)
                if cImage != nil {
                    return cImage!
                }
            }
        }
        return UIImage(named:"smlogo.png")!
        
        //        let imgUrl = NSURL(string: imgUrlString)
        //        let cImageData = NSData(contentsOfURL: imgUrl!)
        //        let cImage = UIImage(data: cImageData!)
        //        if cImage != nil {
        //            return cImage!
        //        }
        //        return UIImage(named:"smnocover.png")!
    }
    
    
//    static func getSideMenuItems() -> NSMutableArray {
//        let menuItemsArray = NSMutableArray()
//        for menuItem in (CXDBSettings.sharedInstance.getAllMallsInDB().valueForKeyPath("name") as? NSArray)!{
//            let category = menuItem.stringByReplacingOccurrencesOfString("Silly Monks", withString: "")
//            menuItemsArray.addObject((category.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())))
//        }
//        return menuItemsArray
//    }
    
    static func currentDeviceScreen() -> String {
        let bounds = UIScreen.main.bounds
        let height = bounds.size.height
        
        switch height {
        case 480.0:
            print("iPhone 3,4")
            return IPHONE_4S
        case 568.0:
            print("iPhone 5")
            return IPHONE_5S
        case 667.0:
            print("iPhone 6")
            return IPHONE_6
        case 736.0:
            print("iPhone 6+")
            return IPHONE_6PLUS
            
        default:
            print("not an iPhone")
            return NOT_IPHONE
        }
    }
    
//    
//    static func saveDataInUserDefaults(userDetails: SMUserDetails) {
//        NSUserDefaults.standardUserDefaults().setObject(userDetails.userFirstName, forKey: "FIRST_NAME")
//        NSUserDefaults.standardUserDefaults().setObject(userDetails.userLastName, forKey: "LAST_NAME")
//        NSUserDefaults.standardUserDefaults().setObject(userDetails.emailAddress, forKey: "EMAIL")
//        NSUserDefaults.standardUserDefaults().setObject(userDetails.userID, forKey: "USER_ID")
//        NSUserDefaults.standardUserDefaults().synchronize()
//    }
    
    
}


extension String {
    
    func urlEncoding() -> String {
        let escapedString = self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        //print("escapedString: \(escapedString)")
        return escapedString!
    }

    func getTheCurrentDateTime(dateString:String) -> String{
        
        // create dateFormatter with UTC time format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm MMM d',' yyyy"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        let date = dateFormatter.date(from: dateString)
        
        // change to a readable time format and change to local time zone
        dateFormatter.dateFormat = "h:mm a MMM d',' yyyy"
        dateFormatter.timeZone = NSTimeZone.local
        let timeStamp = dateFormatter.string(from: date!)
        
        return timeStamp
    }
  
}

extension Constants {
    
    func setTheDefaultStoreID(_ storeID:String){
        UserDefaults.standard.set(storeID, forKey: "STORE_ID")
    }
    
    func getTheDefaultStoreID() -> String{
        return (UserDefaults.standard.object(forKey: "STORE_ID") as? String)!
    }
    

}
