//
//  CXDataProvider.swift
//  NowFloats
//
//  Created by Mahesh Y on 8/25/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit
import CoreData
import MagicalRecord
private var _sharedInstance:CXDataProvider! = CXDataProvider()


class CXDataProvider: NSObject {
    class var sharedInstance : CXDataProvider {
        return _sharedInstance
    }
    
    private override init() {
        
    }
    
    func destory () {
        _sharedInstance = nil
    }
    
    //MARK:Save The StoreCategory
    
    func saveTheStoreCategory(jsonDic:NSDictionary){
        
        let jobs : NSArray =  jsonDic.valueForKey("jobs")! as! NSArray
        
        MagicalRecord.saveWithBlock({ (localContext) in
            
            for storeCategory in jobs{
                
                
            }
            
            
            
        }) { (success, error) in
            
            if success == true {
                
            }else {
                print("Error\(error)")
            }
        }
        
    }
 
    func saveTheProducts(jsonDic:NSDictionary ,completion:(isDataSaved:Bool) -> Void){
        
        let jobs : NSArray =  jsonDic.valueForKey("jobs")! as! NSArray
        
        
        MagicalRecord.saveWithBlock({ (localContext) in
            for prod in jobs {
                print(prod)
                let enProduct =  NSEntityDescription.insertNewObjectForEntityForName("CX_Products", inManagedObjectContext: localContext) as? CX_Products
                let createByID : String = CXConstant.resultString(prod.valueForKey("createdById")!)
                enProduct!.createdById = createByID
                enProduct!.itemCode = prod.valueForKey("ItemCode") as? String
                let jsonString = CXConstant.sharedInstance.convertDictionayToString(prod as! NSDictionary)
                enProduct!.json = jsonString as String
                enProduct!.name = prod.valueForKey("Name") as? String
                enProduct!.pid = CXConstant.resultString(prod.valueForKey("id")!)
                //enProduct!.storeId = CXConstant.resultString((prod.valueForKey("storeId"))!)
                enProduct!.type = prod.valueForKey("jobTypeName") as? String
                enProduct?.imageUrl =  prod.valueForKey("Image_URL") as? String
                // self.saveContext()
            }
            
        }) { (success, error) in
            if success == true {
                completion(isDataSaved: success)
                //                if let delegate = self.delegate {
                //                    delegate.didFinishProducts(productCatName)
                //                }
            } else {
                print("Error\(error)")
            }
        }
    }
    
    func saveTheFeatureProducts(jsonDic:NSDictionary ,completion:(isDataSaved:Bool) -> Void){
        let jobs : NSArray =  jsonDic.valueForKey("jobs")! as! NSArray
        MagicalRecord.saveWithBlock({ (localContext) in
            for prod in jobs {
                let enProduct =  NSEntityDescription.insertNewObjectForEntityForName("CX_FeaturedProducts", inManagedObjectContext: localContext) as? CX_FeaturedProducts
                let createByID : String = CXConstant.resultString(prod.valueForKey("createdById")!)
                enProduct!.createdByID = createByID
                enProduct!.item_Code = prod.valueForKey("ItemCode") as? String
                let jsonString = CXConstant.sharedInstance.convertDictionayToString(prod as! NSDictionary)
                enProduct!.json = jsonString as String
                enProduct!.name = prod.valueForKey("Name") as? String
                enProduct!.fID = CXConstant.resultString(prod.valueForKey("id")!)
                enProduct?.campaign_Jobs = prod.valueForKey("Campaign_Jobs") as? String
                enProduct?.itHasJobs = false
            }
            
        }) { (success, error) in
            if success == true {
                completion(isDataSaved: success)

                //                if let delegate = self.delegate {
                //                    delegate.didFinishProducts(productCatName)
                //                }
            } else {
                print("Error\(error)")
            }
        }
    }
    
    func saveTheFeaturedProductJobs(jsonDic:NSDictionary,parentID:String ,completion:(isDataSaved:Bool) -> Void) {
        
        let jobs : NSArray =  jsonDic.valueForKey("jobs")! as! NSArray
        MagicalRecord.saveWithBlock({ (localContext) in
            for prod in jobs {
                let enProduct =  NSEntityDescription.insertNewObjectForEntityForName("CX_FeaturedProductsJobs", inManagedObjectContext: localContext) as? CX_FeaturedProductsJobs
                let createByID : String = CXConstant.resultString(prod.valueForKey("createdById")!)
                enProduct!.createdByID = createByID
                enProduct?.image_URL =  prod.valueForKey("Image_URL") as? String
                enProduct?.fDescription =  prod.valueForKey("Description") as? String
                let jsonString = CXConstant.sharedInstance.convertDictionayToString(prod as! NSDictionary)
                enProduct!.json = jsonString as String
                enProduct!.name = prod.valueForKey("Name") as? String
                enProduct!.fID = CXConstant.resultString(prod.valueForKey("id")!)
                enProduct?.parentID = parentID
            }
            
        }) { (success, error) in
            if success == true {
                completion(isDataSaved: success)
                
                //                if let delegate = self.delegate {
                //                    delegate.didFinishProducts(productCatName)
                //                }
            } else {
                print("Error\(error)")
            }
        }
    }
    
    
    
    func saveStoreInDB(resDict:NSDictionary ,completion:(isDataSaved:Bool) -> Void) {

        let jobs : NSArray =  resDict.valueForKey("jobs")! as! NSArray

        MagicalRecord.saveWithBlock({ (localContext) in
          for prod in jobs {
            let enStore = NSEntityDescription.insertNewObjectForEntityForName("CX_Stores", inManagedObjectContext: localContext) as? CX_Stores
            enStore!.storeID = CXConstant.resultString(prod.valueForKey("id")!)
            enStore!.name = prod.valueForKey("Name") as? String
            enStore!.type = prod.valueForKey("Type") as? String
            let jsonString = CXConstant.sharedInstance.convertDictionayToString(prod as! NSDictionary)
            enStore!.json = jsonString as String
            enStore!.createdById = CXConstant.resultString(prod.valueForKey("createdById")!)
            enStore!.itemCode = prod.valueForKey("ItemCode") as? String
                }
        }) { (success, error) in
            if success == true {
                completion(isDataSaved: success)
            } else {
                print("Error\(error)")
            }
            
        }
        

        
    }
    
    
    func saveSingleMallInDB(resDict:NSDictionary) {
        // print ("Single Mall Response \(resDict)")
        
        MagicalRecord.saveWithBlock({ (localContext) in
            let enSMall = CX_SingleMall.MR_createInContext(localContext) as! CX_SingleMall
            enSMall.mallID = CXConstant.resultString(resDict.valueForKey("id")!)
            enSMall.coverImage = resDict.valueForKey("Cover_Image") as? String
            enSMall.mallDesc = resDict.valueForKey("description") as? String
            enSMall.name = resDict.valueForKey("name") as? String
            enSMall.email = resDict.valueForKey("email") as? String
            enSMall.mobile = resDict.valueForKey("mobile") as? String
        }) { (success, error) in
            if success == true {
//                if let delegate = self.delegate {
//                    delegate.didFinishSingleMallSaving(CXConstant.resultString(resDict.valueForKey("id")!))
//                }
            } else {
                print("Error\(error)")
            }
        }
        
        }
    

}


extension CXDataProvider {
    
    
    func getTheTableDataFromDataBase(entityName: String ,predicate:NSPredicate,ispredicate:Bool) -> (dataArray:NSArray, totalCount:NSInteger){
        
        let fetchRequest : NSFetchRequest = NSFetchRequest(entityName: entityName)
        if ispredicate {
            fetchRequest.predicate = predicate
        }
        
        do {
            let result = try  NSManagedObjectContext.MR_contextForCurrentThread().executeFetchRequest(fetchRequest)
            return(result ,result.count)
            
        } catch {1
            let fetchError = error as NSError
            print(fetchError)
        }
        
        return([],0)
    }
    
    
    
    
}
/*
 
 
 @NSManaged var campaign_Jobs: String?
 @NSManaged var createdByID: String?
 @NSManaged var fDescription: String?
 @NSManaged var fID: String?
 @NSManaged var item_Code: String?
 @NSManaged var jobId: String?
 @NSManaged var json: String?
 @NSManaged var name: String?

 */
