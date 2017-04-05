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
    var mixpanel = Mixpanel.sharedInstance()

    class var sharedInstance : CXMixpanel {
        return _SingletonSharedInstance
    }
    
    fileprivate override init() {
        
    }
    
    func destory () {
        _SingletonSharedInstance = nil
    }
    
    func registerMixpanelFrameWorkWithApiKey(){
        
        let token = "82b5997b37b626e21cbe7be6691688ec"
        Mixpanel.sharedInstance(withToken: token)
       mixpanel = Mixpanel.sharedInstance()
       // let mixpanel = Mixpanel.sharedInstanceWithToken(token)
    }
    
    //MARK: Call, Message us, View Map
    
    func trackTheCallInformation(){
        mixpanel.timeEvent("Call")
        mixpanel.track("Call")
    }
    
    func mixelcallTrack(){
        
    }
    
    func mixelMessageTrack(){
        mixpanel.timeEvent("Messaging")
        mixpanel.track("Messaging")
    }
    func mixelViewMapTrack(){
        mixpanel.timeEvent("Map")
        mixpanel.track("Map")
    }
    func mixelAboutTrack(){
        mixpanel.timeEvent("About us")
        mixpanel.track("About us")
    }
    func mixelOrdersTrack(){
        mixpanel.timeEvent("Orders")
        mixpanel.track("Orders")
    }
    
    func mixelProfileTarck(){
        mixpanel.timeEvent("Profile")
        mixpanel.track("Profile")
    }
    
    func mixelCartTrack(){
        mixpanel.timeEvent("Cart View")
        mixpanel.track("Cart View")
        
    }
    
    func mixelFavoriteTrack(){
        mixpanel.timeEvent("Products Favorite")
        mixpanel.track("Products Favorite")
    }
    
    func mixelWishListTrack(){
        mixpanel.timeEvent("Wishlist")
        mixpanel.track("Wishlist")
    }
    
    func mixelGalleryTrack(){
        mixpanel.timeEvent("Gallery")
        mixpanel.track("Gallery")
    }
    
    func mixelNotificationTrack(){
        mixpanel.timeEvent("Notifications")
        mixpanel.track("Notifications")
    }
    /*
     
     Team, these are the events which needs to be tracked.
     public static   PREF_LOYALITY_FAV = "Products Favorite";
     public static   PREF_LOYALITY_WISHLIST = "Wishlist";
     public static   PREF_LOYALITY_GALLERY = "Gallery";
     public static   PREF_LOYALITY_NOTIFICATION = "Notifications"
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
