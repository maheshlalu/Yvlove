//
//  CXMixpanel.swift
//  NowFloats
//
//  Created by apple on 26/01/17.
//  Copyright © 2017 CX. All rights reserved.
//

import UIKit
import Mixpanel

/*
public static   PREF_LOYALITY_CALL = "Call";
public static   PREF_LOYALITY_MESSAGE = "Messaging";
public static   PREF_LOYALITY_MAP = "Map";
public static   PREF_LOYALITY_ABOUTUS = "About us";
public static   PREF_LOYALITY_ORDERS = "Orders";
public static   PREF_LOYALITY_PROFILE = "Profile";
public static   PREF_LOYALITY_CARTVIEW = "Cart View";
public static   PREF_LOYALITY_FAV = "Products Favorite";
public static   PREF_LOYALITY_WISHLIST = "Wishlist";
public static   PREF_LOYALITY_GALLERY = "Gallery";
public static   PREF_LOYALITY_NOTIFICATION = "Notifications"
*/
private var _SingletonSharedInstance:CXMixpanel! = CXMixpanel()

class CXMixpanel: NSObject {

    class var sharedInstance : CXMixpanel {
        return _SingletonSharedInstance
    }
    
    fileprivate override init() {
        
    }
    
    func destory () {
        _SingletonSharedInstance = nil
    }
    
    func registerMixpanelFrameWorkWithApiKey(){
        
        let token = "5994a860f45df9b9ea37d031466a3855"
        
        Mixpanel.sharedInstance(withToken: token)
        
        self.trackTheCallInformation()
        
       // let mixpanel = Mixpanel.sharedInstanceWithToken(token)
    }
    
    //MARK: Call, Message us, View Map
    
    func trackTheCallInformation(){
        
        let mixpanel = Mixpanel.sharedInstance()
        let properties = ["Plan": "Premium"]
        mixpanel.track("Initail Launch", properties: properties)
        
        
        mixpanel.timeEvent("Image Upload")
        mixpanel.track("Image Upload")
    }
    
    func mixelcallTrack(){
        
    }
    
    func mixelMessageTrack(){
        
    }
    func mixelViewMapTrack(){
        
    }
    func mixelHomeTrack(){
        
    }
    func mixelOrdersTrack(){
        
    }
    
    /*
     
     Team, these are the events which needs to be tracked.
     
     1. Call, Message us, View Map
     2. Home, About us, Orders, Wish list
     3. Add to cart
     4. Share update
     5. Session Duration
     6. Notificaions
     7. Your cart
     8. Settings, profile
     */
}
