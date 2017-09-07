//
//  CXAppConfig.swift
//  NowFloats
//
//  Created by Mahesh Y on 8/22/16.
//  Copyright © 2016 CX. All rights reserved.
//

import Foundation

class CXAppConfig {
    /// the singleton
    static let sharedInstance = CXAppConfig()
    
    // This prevents others from using the default '()' initializer for this class.
    fileprivate init() {
        loadConfig()
    }
    
    /// the config dictionary
    var config: NSDictionary?
    
    /**
     Load config from Config.plist
     */
    func loadConfig() {
        if let path = Bundle.main.path(forResource: "CXProjectConfiguration", ofType: "plist") {
            config = NSDictionary(contentsOfFile: path)
            
        }
    }
    
    static func resultString(input: AnyObject) -> String{
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
    
    /**
     Get base url from Config.plist
     
     - Returns: the base url string from Config.plist
     */
    func getBaseUrl() -> String {
        return config!.value(forKey: "NowFloats_BaseUrl") as! String
    }
    
    func getCommentUrl() -> String {
        return config!.value(forKey: "commentUrl") as! String
    }
    func getMasterUrl() -> String {
        return config!.value(forKey: "getMaster") as! String
    }
    
    func getSignInUrl() -> String {
        return config!.value(forKey: "signInMethod") as! String
    }
    
    func getSignUpInUrl() -> String {
        return config!.value(forKey: "signUpMethod") as! String
    }
    func getForgotPassordUrl() -> String {
        return config!.value(forKey: "forgotPassordMethod") as! String
    }
    
    func getPlaceOrderUrl() -> String{
        return config!.value(forKey: "placeOrder") as! String
    }
    
    func getupdateProfileUrl() -> String {
        return config!.value(forKey: "updateProfile") as! String
    }
    
    func getphotoUploadUrl() -> String {
        return config!.value(forKey: "photoUpload") as! String
    }
    
    func getAppMallID() -> String {
        return config!.value(forKey: "NOWFLOATS_MALL_ID") as! String
    }
    
    func productName() -> String{
            return config!.value(forKey: "PRODUCT_NAME") as! String
    }
    
    func getSidePanelList() -> NSArray{
            return config!.value(forKey: "SidePanelList") as! NSArray
    }
    func getLoyalcards() -> String{
        return config!.value(forKey: "loyalCards") as! String
    }
    
    //MARK: payment url
    func getTestPaymentGatewayUrl() -> String{
    
    return config!.value(forKey: "testPaymentUrl") as! String
    }
    
    func getAppTheamColor() -> UIColor {
        let appTheamColorArr : NSArray = config!.value(forKey: "AppTheamColor") as! NSArray
        let red : Double = (appTheamColorArr.object(at: 0) as! NSString).doubleValue
        let green : Double = (appTheamColorArr.object(at: 1) as! NSString).doubleValue
        let blue : Double = (appTheamColorArr.object(at: 2) as! NSString).doubleValue
        
        return UIColor(
            red: CGFloat(red / 255.0),
            green: CGFloat(green / 255.0),
            blue: CGFloat(blue / 255.0),
            alpha: CGFloat(1.0)
        )
    }
    
    func getAppBGColor() -> UIColor {
        let appTheamColorArr : NSArray = config!.value(forKey: "AppBgColr") as! NSArray
        let red : Double = (appTheamColorArr.object(at: 0) as! NSString).doubleValue
        let green : Double = (appTheamColorArr.object(at: 1) as! NSString).doubleValue
        let blue : Double = (appTheamColorArr.object(at: 2) as! NSString).doubleValue
        return UIColor(
            red: CGFloat(red / 255.0),
            green: CGFloat(green / 255.0),
            blue: CGFloat(blue / 255.0),
            alpha: CGFloat(1.0)
        )
    }

    func mainScreenSize() -> CGSize {
        return UIScreen.main.bounds.size
    }
    
    //MARK:FONTS
    func appSmallFont() -> UIFont{
        return UIFont(name: config!.value(forKey: "APPFONT_NAME_REGULAR") as! String, size: CGFloat((config!.value(forKey: "APPFONT_SMALL") as?NSNumber)!))!
    }
    
    func appMediumFont() -> UIFont{
        return UIFont(name: config!.value(forKey: "APPFONT_NAME_REGULAR") as! String, size: CGFloat((config!.value(forKey: "APPFONT_MEDIUM") as?NSNumber)!))!
    }

    func appLargeFont() -> UIFont{
        return UIFont(name: config!.value(forKey: "APPFONT_NAME_REGULAR") as! String, size: CGFloat((config!.value(forKey: "APPFONT_LARGE") as?NSNumber)!))!
    }
    
    //MARK:Pager Enable
    func ispagerEnable() -> Bool {
        return config!.value(forKey: "ISPagerEnable") as! Bool
    }
    

    func getTheDataInDictionaryFromKey(sourceDic:NSDictionary,sourceKey:NSString) ->String{
        let keyExists = sourceDic[sourceKey] != nil
        if keyExists {
            // now val is not nil and the Optional has been unwrapped, so use it
            return sourceDic[sourceKey]! as! String
        }
        return ""
        
    }
    
    func setDeviceToken(deviceToken:String){
        
        UserDefaults.standard.set(deviceToken, forKey: "deviceToken")
        
    }
    
    func getDeviceToken() -> String{
        if(UserDefaults.standard.object(forKey: "deviceToken") == nil){
            return ""
        }else{
            return UserDefaults.standard.value(forKey: "deviceToken") as! String
        }
    }

    
}
