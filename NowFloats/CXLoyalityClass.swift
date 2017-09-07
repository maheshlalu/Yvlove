//
//  CXLoyalityClass.swift
//  NowFloats
//
//  Created by apple on 06/09/17.
//  Copyright © 2017 CX. All rights reserved.
//

import UIKit

class CXLoyalityClass: NSObject {
    
    func login(){
        
    }
    
    func register(){
        
    }
    func productBuy(productID:String){
        
    }
    
    func productCart(productID:String){
        
    }
    


/*
ItemCode	Name	points	Description	isDynamicRule
 ACNP_1        Login	0.0
 ACNP_10        Offers Favorite	0.0
 ACNP_8     Products Buy	0.0
 ACNP_6     Products Cart	0.0
 ACNP_4     Products Favorite	0.0
 ACNP_2     Register	0.0
 ACNP_9     Offers View	0.0
 ACNP_7     Products Comment	0.0 
 ACNP_5     Products Share	0.0
 ACNP_3     Products View	0.0
 ACNP_12	Offers Comment	0.0
 ACNP_21	WhatsApp	0.0
 ACNP_19	Campaigns Share	0.0
 ACNP_15	Services Share	0.0
 ACNP_17	Campaigns View	0.0
 ACNP_13	Services View	0.0
 ACNP_11	Offers Share	0.0
 ACNP_20	Campaigns Comment	0.0
 ACNP_18	Campaigns Favorite	0.0
 ACNP_16	Services Comment	0.0
 ACNP_14	Services Favorite	0.0
 ACNP_31	Pinterest	0.0
 ACNP_29	Twitter	0.0
 ACNP_27	Linkedin	0.0
 ACNP_25	Google+	0.0
 ACNP_23	Gmail	0.0
 ACNP_30	Hangouts	0.0
 ACNP_28	Instagram	0.0
 ACNP_26	Messaging	0.0
 ACNP_24	Facebook	0.0
 ACNP_22	Skype	0.0
 */

    /*
     
     public static String postLoyality(Context mContext) {
     return getHostUrl(mContext) + "/Services/createORGetJobInstance?";
     /*
     * email=vinodhapudari@gmail.com&orgId=3(mallId)
     * &activityName=Register(SKYPE,WHATSAPP)&loyalty=true&ItemCodes=
     * 1403328294834_3;white13&trackOnlyOnce=false
     */
     }
     */
    
    
    func sendLoyalityPoints(loayalityDict:[String:String]){
        
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile("Services/createORGetJobInstance?", parameters: loayalityDict as [String : AnyObject]) { (responceDic) in
            
        }
        
        /*CXDataService.sharedInstance.getTheAppDataFromServer(["type":"Stores" as AnyObject,"mallId":CXAppConfig.sharedInstance.getAppMallID() as AnyObject]) { (responseDict) in
         CXDataProvider.sharedInstance.saveStoreInDB(responseDict, completion: { (isDataSaved) in
         LoadingView.show("Loading", animated: true)
         //self.getProducts()
         })
         
         }*/
        
    }
    
}
