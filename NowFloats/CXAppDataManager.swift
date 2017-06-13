//
//  CXAppDataManager.swift
//  NowFloats
//
//  Created by Mahesh Y on 8/24/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit
import FacebookCore

private var _sharedInstance:CXAppDataManager! = CXAppDataManager()

protocol AppDataDelegate {
    func completedTheFetchingTheData(_ sender: CXAppDataManager)
    
}
open class CXAppDataManager: NSObject {
    
    var dataDelegate:AppDataDelegate?
    
    class var sharedInstance : CXAppDataManager {
        return _sharedInstance
    }
    
    fileprivate override init() {
        
    }
    
    func destory () {
        _sharedInstance = nil
    }
    
    //Get The StoreCategory
    func getTheStoreCategory(){
        self.getProducts()
       // self.getTheFeaturedProduct()

        CXDataService.sharedInstance.getTheAppDataFromServer(["type":"StoreCategories" as AnyObject,"mallId":CXAppConfig.sharedInstance.getAppMallID() as AnyObject]) { (responseDict) in
            print("print store category\(responseDict)")
          self.getTheStores({(isDataSaved) in
          })
        }
    }
    
    func getSingleMall(_ completion:@escaping (_ isDataSaved:Bool) -> Void){
        CXDataService.sharedInstance.getTheAppDataFromServer(["type":"singleMall" as AnyObject,"mallId":CXAppConfig.sharedInstance.getAppMallID() as AnyObject]) { (responseDict) in
            CXDataProvider.sharedInstance.saveSingleMallInDB(responseDict, completion: { (isDataSaved) in
                completion(isDataSaved)
            })
        }

      //  self.getTheSigleMall()

    }
    
    func getTheStores(_ completion:@escaping (_ isDataSaved:Bool) -> Void){
        
        if  CXDataProvider.sharedInstance.getTheTableDataFromDataBase("CX_Stores", predicate: NSPredicate(), ispredicate: false,orederByKey: "").totalCount == 0{
            CXDataService.sharedInstance.getTheAppDataFromServer(["type":"Stores" as AnyObject,"mallId":CXAppConfig.sharedInstance.getAppMallID() as AnyObject]) { (responseDict) in
                    CXDataProvider.sharedInstance.saveStoreInDB(responseDict, completion: { (isDataSaved) in
                        LoadingView.show("Loading", animated: true)
                        completion(isDataSaved)
                        //self.getProducts()
                    })
                
            }
            
        }else{
            // self.getProducts()
        }
        
        
     /*   CXDataService.sharedInstance.getTheAppDataFromServer(["type":"Stores" as AnyObject,"mallId":CXAppConfig.sharedInstance.getAppMallID() as AnyObject]) { (responseDict) in
            if  CXDataProvider.sharedInstance.getTheTableDataFromDataBase("CX_Stores", predicate: NSPredicate(), ispredicate: false,orederByKey: "").totalCount == 0{
                CXDataProvider.sharedInstance.saveStoreInDB(responseDict, completion: { (isDataSaved) in
                    LoadingView.show("Loading", animated: true)
                    completion(isDataSaved)
                    //self.getProducts()
                })
            }else{
               // self.getProducts()
            }
        }*/
    }
    
    
    func getRegularTests(_ completion:@escaping (_ responce:Bool) -> Void){
       // if  CXDataProvider.sharedInstance.getTheTableDataFromDataBase("CX_Products", predicate: NSPredicate(format: "type == RegularTests", argumentArray: nil), ispredicate: false,orederByKey: "").totalCount == 0{
        LoadingView.show("Loading...", animated: true)
            CXDataService.sharedInstance.getTheAppDataFromServer(["type":"Regular Tests" as AnyObject,"mallId":CXAppConfig.sharedInstance.getAppMallID() as AnyObject]) { (responseDict) in
                print("print products\(responseDict)")
                CXDataProvider.sharedInstance.saveTheProducts(responseDict, completion: { (isDataSaved) in
                    completion(true)
                    LoadingView.hide()
                })
            }
        //}
    }
    
    func getRadiologyTests(_ completion:@escaping (_ responce:Bool) -> Void){
       // if  CXDataProvider.sharedInstance.getTheTableDataFromDataBase("CX_Products", predicate: NSPredicate(format: "type == Radiology", argumentArray: nil), ispredicate: false,orederByKey: "").totalCount == 0{
        LoadingView.show("Loading...", animated: true)

            CXDataService.sharedInstance.getTheAppDataFromServer(["type":"Radiology" as AnyObject,"mallId":CXAppConfig.sharedInstance.getAppMallID() as AnyObject]) { (responseDict) in
                //print("print products\(responseDict)")
                CXDataProvider.sharedInstance.saveTheProducts(responseDict, completion: { (isDataSaved) in
                    completion(true)
                    LoadingView.hide()

                })
            //}}else{
        }
    }

 
    func getProducts(){
        
        #if MyLabs
   
  
        #else
        
        if  CXDataProvider.sharedInstance.getTheTableDataFromDataBase("CX_Products", predicate: NSPredicate(), ispredicate: false,orederByKey: "").totalCount == 0{
            CXDataService.sharedInstance.getTheAppDataFromServer(["type":"Products" as AnyObject,"mallId":CXAppConfig.sharedInstance.getAppMallID() as AnyObject]) { (responseDict) in
                print("print products\(responseDict)")
                CXDataProvider.sharedInstance.saveTheProducts(responseDict, completion: { (isDataSaved) in
                    self.getTheFeaturedProduct()
                })
            }
        }else{
            self.getTheFeaturedProduct()
            
        }
         #endif
    }
    
    //http://nowfloats.ongostore.com:8081/Services/getMasters?type=Products&mallId=11
    //http://nowfloats.ongostore.com:8081/Services/getMasters?type=Products&mallId=11&pageNumber=2&pageSize=5
    
    
    func getTheSigleMall(){
        //type=singleMall
        if CX_SingleMall.mr_findAll().count == 0 {
            CXDataService.sharedInstance.getTheAppDataFromServer(["type":"singleMall" as AnyObject,"mallId":CXAppConfig.sharedInstance.getAppMallID() as AnyObject]) { (responseDict) in
                CXDataProvider.sharedInstance.saveSingleMallInDB(responseDict, completion: { (isDataSaved) in
                })
            }
        }else{
            
        }
    }
    
    
    func getTheProductCategory(){
        
        
    }
    
    func getTheServieCategory(){
        
        
    }
    
    
    func getTheFeaturedProduct(){
        print("getTheFeaturedProduct")
        
        if  CXDataProvider.sharedInstance.getTheTableDataFromDataBase("CX_FeaturedProducts", predicate: NSPredicate(), ispredicate: false,orederByKey: "").totalCount == 0{
            CXDataService.sharedInstance.getTheAppDataFromServer(["type":"Featured Products" as AnyObject,"mallId":CXAppConfig.sharedInstance.getAppMallID() as AnyObject]) { (responseDict) in
                CXDataProvider.sharedInstance.saveTheFeatureProducts(responseDict, completion: { (isDataSaved) in
                    if isDataSaved{
                        self.getTheFeaturedProductJobs()
                    }else{
                        self.dataDelegate?.completedTheFetchingTheData(self)
                    }
                    
                })
            }
        }else{
            self.getTheFeaturedProductJobs()
        }
    }
    
    
    func getTheFeaturedProductJobs(){
        print("getTheFeaturedProductJobs")
        
        let jobsArray : NSArray =  CXDataProvider.sharedInstance.getTheTableDataFromDataBase("CX_FeaturedProducts", predicate: NSPredicate(format:"itHasJobs == 0" ), ispredicate: true,orederByKey: "").dataArray
        if jobsArray.count != 0 {
            let featuredProducts:CX_FeaturedProducts
                =    (jobsArray.lastObject as? CX_FeaturedProducts)!
            //  NSManagedObjectContext.MR_contextForCurrentThread().save()
            
            CXDataService.sharedInstance.getTheAppDataFromServer(["PrefferedJobs":featuredProducts.campaign_Jobs! as AnyObject,"mallId":CXAppConfig.sharedInstance.getAppMallID() as AnyObject]) { (responseDict) in
                print(responseDict)
                
                let jobs : NSArray =  responseDict.value(forKey: "jobs")! as! NSArray
                
                if jobs.count == 0{
                    self.dataDelegate?.completedTheFetchingTheData(self)
                    return
                }

                CXDataProvider.sharedInstance.saveTheFeaturedProductJobs(responseDict, parentID: featuredProducts.fID!, completion: { (isDataSaved) in
                    featuredProducts.itHasJobs = true
                    NSManagedObjectContext.mr_contextForCurrentThread().mr_saveOnlySelfAndWait()
                    self.getTheFeaturedProductJobs()
                })
            }
        }else{
            self.dataDelegate?.completedTheFetchingTheData(self)
        }
    }
    
    //Get Service Form
    
 
    
    //Mark Place order
    
    func placeOder(_ name:String ,email:String,address1:String,address2:String,number:String,subTotal:String,completion:@escaping (_ isDataSaved:Bool) -> Void){
        //NSString* const POSTORDER_URL = @"http://storeongo.com:8081/MobileAPIs/postedJobs?type=PlaceOrder&";

        LoadingView.show("Processing Your Order", animated: true)
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getPlaceOrderUrl(), parameters: ["type":"PlaceOrder" as AnyObject,"json":self.checkOutCartItems(name, email: email, address1: address1, address2: address2,number:number,subTotal:subTotal) as AnyObject,"dt":"CAMPAIGNS" as AnyObject,"category":"Services" as AnyObject,"userId":CXAppConfig.sharedInstance.getAppMallID() as AnyObject,"consumerEmail":email as AnyObject]) { (responseDict) in
            completion(true)
            let string = responseDict.value(forKeyPath: "myHashMap.status") as! String
            
            if (string.contains("1")){
                // print("All Malls \(jsonData)")
                let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CX_Cart")
                let cartsDataArrya : NSArray = CX_Cart.mr_executeFetchRequest(fetchRequest) as NSArray
                for (index, element) in cartsDataArrya.enumerated() {
                    print(index)
                    let cart : CX_Cart = element as! CX_Cart
                    NSManagedObjectContext.mr_contextForCurrentThread().delete(cart)
                    NSManagedObjectContext.mr_contextForCurrentThread().mr_saveToPersistentStoreAndWait()
                }
                DispatchQueue.main.async(execute: {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "PlaceOrderSuccessFully"), object: nil)
                    LoadingView.hide()
                    //CartCountUpdate
                })
                
            }
        }
    }
    
    
    func checkOutCartItems(_ name:String ,email:String,address1:String,address2:String,number:String,subTotal:String)-> String{

        let productEn = NSEntityDescription.entity(forEntityName: "CX_Cart", in: NSManagedObjectContext.mr_contextForCurrentThread())
        let fetchRequest : NSFetchRequest<NSFetchRequestResult> = CX_Cart.mr_requestAllSorted(by: "name", ascending: true)
        // fetchRequest.predicate = predicate
        fetchRequest.entity = productEn
        
        let order: NSMutableDictionary = NSMutableDictionary()
        let orderItemName: NSMutableString = NSMutableString()
        let orderItemQuantity: NSMutableString = NSMutableString()
        let orderSubTotal: NSMutableString = NSMutableString()
        let orderItemId: NSMutableString = NSMutableString()
        let orderItemMRP: NSMutableString = NSMutableString()
        
        //let total: Double = 0
        order.setValue(name, forKey: "Name")
        //order["Name"] = ("\("kushal")")
        //should be replaced
        // order["Address"] = ("\("madhapur hyd")")
        order.setValue(address1, forKey: "Address")
        
        //should be replaced
        //order["Contact_Number"] = ("\("7893335553")")
        order.setValue(number, forKey: "Contact_Number")
        
        //should be replaced
        
        
        for (index, element) in CX_Cart.mr_executeFetchRequest(fetchRequest).enumerated() {
            let cart : CX_Cart = element as! CX_Cart
            if index != 0 {
                orderItemName.append(("\("|")"))
                orderItemQuantity .append(("\("|")"))
                orderSubTotal .append(("\("|")"))
                orderItemId .append(("\("|")"))
                orderItemMRP .append(("\("|")"))
            }
            //            let responseString = String(data: data!, encoding: NSUTF8StringEncoding)
            let finalSubtotal = (cart.quantity?.int32Value)! * (cart.productPrice?.int32Value)!
            orderItemName.append("\((cart.name?.escapeStr())! + "`" + cart.pID!)")
            orderItemQuantity.append("\(String(describing: cart.quantity!).addingPercentEscapes(using: String.Encoding.utf8)! + "`" + cart.pID!)")
            orderSubTotal.append(String(finalSubtotal) + "`" + cart.pID!)
            orderItemId.append("\(cart.pID! + "`" + cart.pID!)")
            orderItemMRP.append(String(describing: cart.productPrice!) + "`" + cart.pID!)
            //print("Item \(index): \(cart)")
        }
        
        //  order["OrderItemId"] = orderItemId
        order.setValue(orderItemId, forKey: "OrderItemId")
        
        //[order setObject:itemCode forKey:@"ItemCode"];
        //order["OrderItemQuantity"] = orderItemQuantity
        order.setValue(orderItemQuantity, forKey: "OrderItemQuantity")
        
        // order["OrderItemName"] = orderItemName
        order.setValue(orderItemName, forKey: "OrderItemName")
        
        //order["OrderItemSubTotal"] = ("\(orderSubTotal)")
        order.setValue(orderSubTotal, forKey: "OrderItemSubTotal")
        
        // order["OrderItemMRP"] = ("\(orderItemMRP)")
        order.setValue(orderItemMRP, forKey: "OrderItemMRP")
        
        order.setValue(subTotal, forKey: "Total")
        
        
        //print("order dic \(order)")
        
        let listArray : NSMutableArray = NSMutableArray()
        
        listArray.add(order)
        
        let cartJsonDict :NSMutableDictionary = NSMutableDictionary()
        cartJsonDict.setObject(listArray, forKey: "list" as NSCopying)
        
        //let jsonString = cartJsonDict.JSONString()
        var jsonData : Data = Data()
        do {
            jsonData = try JSONSerialization.data(withJSONObject: cartJsonDict, options: JSONSerialization.WritingOptions.prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
        } catch let error as NSError {
            print(error)
        }
        let jsonStringFormat = String(data: jsonData, encoding: String.Encoding.utf8)
        //print("order dic \(jsonStringFormat)")
        
        return jsonStringFormat!
        
    
    }
    

    //MARK : SIGN 
    //http://storeongo.com:8081/MobileAPIs/loginConsumerForOrg?
    func singWithUserDetails(_ email:String, password:String ,completion:@escaping (_ responseDict:NSDictionary) -> Void){
        
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getSignInUrl(), parameters: ["orgId":CXAppConfig.sharedInstance.getAppMallID() as AnyObject,"email":email as AnyObject,"dt":"DEVICES" as AnyObject,"password":password as AnyObject]) { (responseDict) in
            completion(responseDict)
        }
        
    }
    
    //MARK: SIGN UP
    func signUpWithUserDetails (_ fistName:String, lastName:String, mobileNumber:String, email:String, password:String, completion:@escaping (_ responseDict:NSDictionary) -> Void){
    // let signUpUrl = "http://sillymonksapp.com:8081/MobileAPIs/regAndloyaltyAPI?orgId="+orgID+"&userEmailId="+self.emailAddressField.text!+"&dt=DEVICES&firstName="+self.firstNameField.text!.urlEncoding()+"&lastName="+self.lastNameField.text!.urlEncoding()+"&password="+self.passwordField.text!.urlEncoding()
        
        
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getSignUpInUrl(), parameters: ["orgId":CXAppConfig.sharedInstance.getAppMallID() as AnyObject,"userEmailId":email as AnyObject,"dt":"DEVICES" as AnyObject,"password":password as AnyObject,"firstName":fistName as AnyObject,"lastName":lastName as AnyObject,"mobile":mobileNumber as AnyObject]) { (responseDict) in
            completion(responseDict)

        }
    }
    
    //MARK : FORGOOT PASSWORD
    
    func  forgotPassword(_ email:String,completion:@escaping (_ responseDict:NSDictionary) -> Void){
        
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getForgotPassordUrl(), parameters: ["orgId":CXAppConfig.sharedInstance.getAppMallID() as AnyObject,"email":email as AnyObject,"dt":"DEVICES" as AnyObject]) { (responseDict) in
            completion(responseDict)

        }
    }
    
    //MARK : GET ALL ORDERS
    
    func getOrders(_ completion:@escaping (_ responseDict:NSDictionary) -> Void){
       // NSString* urlString = [NSString stringWithFormat:@"%@consumerId=%@&type=PlaceOrder&mallId=%@",GetAllORDERS_URL,userId,mallId];
        //NSString* const GetAllORDERS_URL = @"http://storeongo.com:8081/Services/getMasters?";
        
        CXDataService.sharedInstance.getTheAppDataFromServer(["consumerId":"717" as AnyObject,"type":"PlaceOrder" as AnyObject,"mallId":CXAppConfig.sharedInstance.getAppMallID() as AnyObject]) { (responseDict) in
            completion(responseDict)
        }


        
    }
    
    //MARK : UPDATE PROFILE
    
    func profileUpdate(_ email:String,address:String,firstName:String,lastName:String,mobileNumber:String,city:String,state:String,country:String,image:String,completion:@escaping (_ responseDict:NSDictionary)-> Void){
        
       // CXDataService.sharedInstance.imageUpload(UIImageJPEGRepresentation(image, 0.5)!) { (imageFileUrl) in
            
            
            CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getupdateProfileUrl(), parameters: ["orgId":CXAppConfig.sharedInstance.getAppMallID() as AnyObject,"email":email as AnyObject,"dt":"DEVICES" as AnyObject,"address":address as AnyObject,"firstName":firstName as AnyObject,"lastName":lastName as AnyObject,"mobileNo":mobileNumber as AnyObject,"city":city as AnyObject,"state":state as AnyObject,"country":country as AnyObject,"userImagePath":image as AnyObject,"userBannerPath":"" as AnyObject]) { (responseDict) in
                completion(responseDict)
            }
            
        //}
        //   NSString* urlString = [NSString stringWithFormat:@"%@orgId=%@&email=%@&dt=DEVICES&firstName=%@&lastName=%@&address=%@&mobileNo=%@&city=%@&state=%@&country=%@&userImagePath=%@&userBannerPath=%@",UpdateProfile_URL,mallId,dict[@"emailId"], dict[@"firstName"],dict[@"lastName"],dict[@"address"],dict[@"mobile"],dict[@"city"],dict[@"state"],dict[@"country"], dict[@"userImagePath"], dict[@"userBannerPath"]];

        
    }
    
    
  
    
}

extension String {
    
    func escapeStr() -> (String) {
        let raw: NSString = self as NSString
        let str = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,raw,"[]." as CFString!,":/?&=;+!@#$()',*" as CFString!,CFStringConvertNSStringEncodingToEncoding(String.Encoding.utf8.rawValue))

        return str as! (String)
    }
}
