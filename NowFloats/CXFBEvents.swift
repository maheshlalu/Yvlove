//
//  CXFBEvents.swift
//  NowFloats
//
//  Created by Manishi on 1/23/17.
//  Copyright © 2017 CX. All rights reserved.
//

import Foundation
import FBSDKCoreKit

class CXFBEvents{
    
    static let sharedInstance = CXFBEvents()
    
    // Event - Achieved Level
    /**
     * For more details, please take a look at:
     * developers.facebook.com/docs/reference/ios/current/class/FBSDKAppEvents
     */
    
    func logAchievedLevelEvent(_ level: String) {
        let params: [AnyHashable: Any] = [
            FBSDKAppEventParameterNameLevel : level
        ]
        
        FBSDKAppEvents.logEvent(FBSDKAppEventNameAchievedLevel, parameters: params)
    }
    //*****************************************************************************************************************
    
    // Event - Initiated Checkout
    /**
     * For more details, please take a look at:
     * developers.facebook.com/docs/reference/ios/current/class/FBSDKAppEvents
     */
    
    func logInitiatedCheckoutEvent(_ contentId: String, contentType: String, numItems: Int, paymentInfoAvailable: Bool, currency: String, valToSum totalPrice: Double) {
        let params: [AnyHashable: Any] = [
            FBSDKAppEventParameterNameContentID : contentId,
            FBSDKAppEventParameterNameContentType : contentType,
            FBSDKAppEventParameterNameNumItems : Int(numItems),
            FBSDKAppEventParameterNamePaymentInfoAvailable : Int(paymentInfoAvailable ? 1 : 0),
            FBSDKAppEventParameterNameCurrency : currency
        ]
        
        FBSDKAppEvents.logEvent(FBSDKAppEventNameInitiatedCheckout, valueToSum: totalPrice, parameters: params)
    }
    //*****************************************************************************************************************
    
    // Event - Added Payment Info
    /**
     * For more details, please take a look at:
     * developers.facebook.com/docs/reference/ios/current/class/FBSDKAppEvents
     */
    
    func logAddedPaymentInfoEvent(_ success: Bool) {
        let params: [AnyHashable: Any] = [
            FBSDKAppEventParameterNameSuccess : Int(success ? 1 : 0)
        ]
        
        FBSDKAppEvents.logEvent(FBSDKAppEventNameAddedPaymentInfo, parameters: params)
    }
    //*****************************************************************************************************************
    // Event - AddToCart
    /**
     * For more details, please take a look at:
     * developers.facebook.com/docs/reference/ios/current/class/FBSDKAppEvents
     */
    
    func logAdded(toCartEvent contentId: String, contentType: String, currency: String, valToSum price: Double) {
        let params: [AnyHashable: Any] = [
            FBSDKAppEventParameterNameContentID : contentId,
            FBSDKAppEventParameterNameContentType : contentType,
            FBSDKAppEventParameterNameCurrency : currency
        ]
        
        FBSDKAppEvents.logEvent(FBSDKAppEventNameAddedToCart, valueToSum: price, parameters: params)
    }
    //*****************************************************************************************************************
    
    // Event - AddToWishlist
    /**
     * For more details, please take a look at:
     * developers.facebook.com/docs/reference/ios/current/class/FBSDKAppEvents
     */
    
    func logAdded(toWishlistEvent contentId: String, contentType: String, currency: String, valToSum price: Double) {
        let params: [AnyHashable: Any] = [
            FBSDKAppEventParameterNameContentID : contentId,
            FBSDKAppEventParameterNameContentType : contentType,
            FBSDKAppEventParameterNameCurrency : currency
        ]
        
        FBSDKAppEvents.logEvent(FBSDKAppEventNameAddedToWishlist, valueToSum: price, parameters: params)
    }
    //*****************************************************************************************************************
    
    // Event - Completed Registration
    /**
     * For more details, please take a look at:
     * developers.facebook.com/docs/reference/ios/current/class/FBSDKAppEvents
     */
    
    func logCompletedRegistrationEvent(_ registrationMethod: String) {
        let params: [AnyHashable: Any] = [
            FBSDKAppEventParameterNameRegistrationMethod : registrationMethod
        ]
        
        FBSDKAppEvents.logEvent(FBSDKAppEventNameCompletedRegistration, parameters: params)
    }
    
    //*****************************************************************************************************************
    
    
    // Event - Completed Tutorial
    /**
     * For more details, please take a look at:
     * developers.facebook.com/docs/reference/ios/current/class/FBSDKAppEvents
     */
    
    func logCompletedTutorialEvent(_ contentId: String, success: Bool) {
        let params: [AnyHashable: Any] = [
            FBSDKAppEventParameterNameContentID : contentId,
            FBSDKAppEventParameterNameSuccess : Int(success ? 1 : 0)
        ]
        
        FBSDKAppEvents.logEvent(FBSDKAppEventNameCompletedTutorial, parameters: params)
    }
    
    //*****************************************************************************************************************
    
    // Event - Purchased
    /**
     * purchaseAmount is double.
     * currency is (NSString *) from http://en.wikipedia.org/wiki/ISO_4217.
     * parameters is (NSDictionary *).
     */
    // FBSDKAppEvents.logPurchase(purchaseAmount, currency: currency, parameters: parameters)
    
    //*****************************************************************************************************************
    
    // Event - Rated
    /**
     * For more details, please take a look at:
     * developers.facebook.com/docs/reference/ios/current/class/FBSDKAppEvents
     */
    
    func logRatedEvent(_ contentType: String, contentId: String, maxRatingValue: Int, valToSum ratingGiven: Double) {
        let params: [AnyHashable: Any] = [
            FBSDKAppEventParameterNameContentType : contentType,
            FBSDKAppEventParameterNameContentID : contentId,
            FBSDKAppEventParameterNameMaxRatingValue : Int(maxRatingValue)
        ]
        
        FBSDKAppEvents.logEvent(FBSDKAppEventNameRated, valueToSum: ratingGiven, parameters: params)
    }
    //*****************************************************************************************************************
    
    // Event - Searched
    /**
     * For more details, please take a look at:
     * developers.facebook.com/docs/reference/ios/current/class/FBSDKAppEvents
     */
    
    func logSearchedEvent(_ contentType: String, search searchString: String, success: Bool) {
        let params: [AnyHashable: Any] = [
            FBSDKAppEventParameterNameContentType : contentType,
            FBSDKAppEventParameterNameSearchString : searchString,
            FBSDKAppEventParameterNameSuccess : Int(success ? 1 : 0)
        ]
        
        FBSDKAppEvents.logEvent(FBSDKAppEventNameSearched, parameters: params)
    }
    
    //*****************************************************************************************************************
    
    // Event - Spent Credits
    /**
     * For more details, please take a look at:
     * developers.facebook.com/docs/reference/ios/current/class/FBSDKAppEvents
     */
    
    func logSpentCreditsEvent(_ contentId: String, contentType: String, valToSum totalValue: Double) {
        let params: [AnyHashable: Any] = [
            FBSDKAppEventParameterNameContentID : contentId,
            FBSDKAppEventParameterNameContentType : contentType
        ]
        
        FBSDKAppEvents.logEvent(FBSDKAppEventNameSpentCredits, valueToSum: totalValue, parameters: params)
    }
    //*****************************************************************************************************************
    
    // Event - Unlocked Achivements
    /**
     * For more details, please take a look at:
     * developers.facebook.com/docs/reference/ios/current/class/FBSDKAppEvents
     */
    
    func logUnlockedAchievementEvent(_ description: String) {
        let params: [AnyHashable: Any] = [
            FBSDKAppEventParameterNameDescription : description
            
        ]
        
        FBSDKAppEvents.logEvent(FBSDKAppEventNameUnlockedAchievement, parameters: params)
    }
    //*****************************************************************************************************************
    
    // Event - Viewed Content
    /**
     * For more details, please take a look at:
     * developers.facebook.com/docs/reference/ios/current/class/FBSDKAppEvents
     */
    
    func logViewedContentEvent(_ contentType: String, contentId: String, currency: String, valToSum price: Double) {
        let params: [AnyHashable: Any] = [
            FBSDKAppEventParameterNameContentType : contentType,
            FBSDKAppEventParameterNameContentID : contentId,
            FBSDKAppEventParameterNameCurrency : currency
        ]
        
        FBSDKAppEvents.logEvent(FBSDKAppEventNameViewedContent, valueToSum: price, parameters: params)
    }
    //*****************************************************************************************************************
    
}
