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
               // print(prod)
                let enProduct =  NSEntityDescription.insertNewObjectForEntityForName("CX_Products", inManagedObjectContext: localContext) as? CX_Products
                let createByID : String = CXConstant.resultString(prod.valueForKey("createdById")!)
                enProduct!.createdById = createByID
                enProduct!.itemCode = prod.valueForKey("ItemCode") as? String
                let jsonString = CXConstant.sharedInstance.convertDictionayToString(prod as! NSDictionary)
                enProduct!.json = jsonString as String
                enProduct!.name = prod.valueForKey("Name") as? String
                enProduct!.pid = CXConstant.resultString(prod.valueForKey("id")!)
                enProduct?.pPrice = 1
                let updateDate =  prod.valueForKey("UpdatedOn") as? String
                
                let component = updateDate!.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
                let list = component.filter({ $0 != "" })
                let number = Int(list[0])
                enProduct?.pUpdateDate =  number
                enProduct?.pPrice = Int((prod.valueForKey("MRP") as? String)!)//MRP
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
        if  jobs.count == 0 {
            completion(isDataSaved: false)
        }
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
                completion(isDataSaved: success)
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
            self.SaveTheGallaryItems((prod.valueForKey("Attachments") as? NSArray)!)
                }
        }) { (success, error) in
            if success == true {
                completion(isDataSaved: success)
            } else {
                print("Error\(error)")
            }
            
        }
    
    }
    
    
    func SaveTheGallaryItems(galeryItems:NSArray){
        MagicalRecord.saveWithBlock({ (localContext) in
            for gallaeryData in galeryItems {
                let enStore = NSEntityDescription.insertNewObjectForEntityForName("CX_Gallery", inManagedObjectContext: localContext) as? CX_Gallery
                enStore?.gID = CXConstant.resultString(gallaeryData.valueForKey("Id")!)
                enStore?.gImageUrl = gallaeryData.valueForKey("URL") as? String
                enStore?.isCoverImage = gallaeryData.valueForKey("isCoverImage") as? String
                enStore?.isBannerImage = gallaeryData.valueForKey("isBannerImage") as? String
            }
        }) { (success, error) in
            if success == true {
              
            } else {
                print("Error\(error)")
            }
            
        }
        
/*
         Id: "122890",
         Image_Name: "1622269_937699392950680_7819671031120876039_n.jpg",
         URL: "https://scontent.xx.fbcdn.net/v/t1.0-9/s720x720/1622269_937699392950680_7819671031120876039_n.jpg?oh=0083906ddd1af57bab5f5ef8e3985f0a&oe=57ED8C25",
         albumName: "Mobile Uploads",
         isCoverImage: "true",
         mmType: "1",
         isBannerImage: "false"*/
        
    }
    
    
    func saveSingleMallInDB(resDict:NSDictionary ,completion:(isDataSaved:Bool) -> Void) {
        
    
        CXConstant.sharedInstance.saveTheFid(CXConstant.resultString(resDict.valueForKeyPath("orgs.fpId")!))
        completion(isDataSaved: true)

     /*   //orgs.appInfo.fpId
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
        }*/
        
        }
    

}


extension CXDataProvider {
    
    func getJobID(input:String,inputDic:String) -> String {
        let json :NSDictionary = (CXConstant.sharedInstance.convertStringToDictionary(inputDic))
        let info : String = CXConstant.resultString(json.valueForKey(input)!)
        return info
        
    }
    
    
    
    func getTheTableDataFromDataBase(entityName: String ,predicate:NSPredicate,ispredicate:Bool,orederByKey:String) -> (dataArray:NSArray, totalCount:NSInteger){
        
        let fetchRequest : NSFetchRequest = NSFetchRequest(entityName: entityName)
        if !orederByKey.isEmpty {
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: orederByKey, ascending: false)]
        }
        // let fetchRequest = CX_Products.MR_requestAllSortedBy("storeID", ascending: false) /
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
    
    
    func getTheProducts(predicate:NSPredicate,ispredicate:Bool) -> (dataArray:NSArray, totalCount:NSInteger){
        
       // let fetchRequest = CX_Products.MR_requestAllSortedBy("pid", ascending: false)
        
        let fetchRequest : NSFetchRequest = NSFetchRequest(entityName: "CX_Products")

        fetchRequest.predicate = predicate
        let productCatList :NSArray = CX_Products.MR_executeFetchRequest(fetchRequest)
        
        return(productCatList,productCatList.count)
    }
    
    
    func getTheFeaturedProducts(predicate:NSPredicate,ispredicate:Bool) -> (dataArray:NSArray, totalCount:NSInteger){
        
        let fetchRequest = CX_FeaturedProducts.MR_requestAllSortedBy("fID", ascending: false)
         if ispredicate {
            fetchRequest.predicate = predicate
        }
        
        let productCatList :NSArray = CX_FeaturedProducts.MR_executeFetchRequest(fetchRequest)
        
        return(productCatList,productCatList.count)
    }
    
    
    func getTheFeaturedProductJobs(predicate:NSPredicate,ispredicate:Bool) -> (dataArray:NSArray, totalCount:NSInteger){
        
        let fetchRequest = CX_FeaturedProductsJobs.MR_requestAllSortedBy("fID", ascending: false)
        if ispredicate {
            fetchRequest.predicate = predicate
        }
        let productCatList :NSArray = CX_FeaturedProductsJobs.MR_executeFetchRequest(fetchRequest)
        
        return(productCatList,productCatList.count)
    }
    
    
    
    
    func itemAddToWishListOrCarts(productJson:String,itemID:String,isAddToWishList:Bool,isAddToCartList:Bool,isDeleteFromWishList:Bool,isDeleteFromCartList:Bool,completionHandler: (Bool) -> ()){
        let productJsonDic = CXConstant.sharedInstance.convertStringToDictionary(productJson)
        
        //var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let cartlist : NSArray =  CX_Cart.MR_findAllWithPredicate(NSPredicate(format: "pID = %@", itemID))
        //var  cart : CX_Cart = (CX_Cart.MR_findFirstWithPredicate(NSPredicate(format: "pID = %@", itemID)) as?CX_Cart)!
        if cartlist.count == 0{
           let cart = CX_Cart.MR_createEntity() as!CX_Cart
            if isAddToCartList {
                cart.addToCart = NSNumber(bool: true)
            }
            if isAddToWishList {
                cart.addToWishList = NSNumber(bool: true)
            }
            //enProduct.itemCode = product.itemCode
            cart.name =  productJsonDic.valueForKey("Name") as? String
            cart.pID = CXConstant.resultString(productJsonDic.valueForKey("id")!)
            cart.imageUrl =  productJsonDic.valueForKey("Image_URL") as? String
            cart.json =  productJson
            let price:String = CXDataProvider.sharedInstance.getJobID("MRP", inputDic: productJson)
            let discount:String = CXDataProvider.sharedInstance.getJobID("DiscountAmount", inputDic: productJson)
            let finalPriceNum:Int = Int(price)!-Int(discount)!
            let myNumber = NSNumber(integer:finalPriceNum)
             cart.productPrice = myNumber
            cart.quantity = 1
            //cart.managedObjectContext?.MR_saveToPersistentStoreAndWait()

        }else{
            do {
                let cartItem : CX_Cart = (cartlist.lastObject as? CX_Cart)!
                if isAddToCartList {
                    cartItem.addToCart = NSNumber(bool: true)
                }
                
                if isAddToWishList {
                    cartItem.addToWishList = NSNumber(bool: true)
                }
                if isDeleteFromCartList{
                    cartItem.addToCart = NSNumber(bool: false)
                }
                if isDeleteFromWishList{
                    cartItem.addToWishList = NSNumber(bool: false)
                    
                }
                
            } catch {
                
            }

            
            
        }
       // appDelegate.saveContext()

        
   NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
         completionHandler(true)
        
//        MagicalRecord.saveWithBlock({ (localContext : NSManagedObjectContext!) in
//            
//            let productEn = NSEntityDescription.entityForName("CX_Cart", inManagedObjectContext: localContext)
//            let predicate:NSPredicate = NSPredicate(format: "pID = %@", itemID)
//            let fetchRequest = NSFetchRequest(entityName: "CX_Cart")
//            fetchRequest.predicate = predicate
//            let cartlist : NSArray = CX_Cart.MR_executeFetchRequest(fetchRequest)
//            if cartlist.count == 0 {
//                let enProduct = CX_Cart(entity: productEn!,insertIntoManagedObjectContext: localContext)
//                if isAddToCartList {
//                    enProduct.addToCart = "YES"
//                }
//                if isAddToWishList {
//                    enProduct.addToWishList = "YES"
//                }
//                //enProduct.itemCode = product.itemCode
//                enProduct.name =  productJsonDic.valueForKey("Name") as? String
//                enProduct.pID = CXConstant.resultString(productJsonDic.valueForKey("id")!)
//                enProduct.imageUrl =  productJsonDic.valueForKey("Image_URL") as? String
//            }else{
//                do {
//                    let cartData : CX_Cart = (cartlist.lastObject as? CX_Cart)!
//                    let cartItem =  try localContext.existingObjectWithID(cartData.objectID) as?CX_Cart
//                    if isAddToCartList {
//                        cartItem!.addToCart = "YES"
//                    }
//                    
//                    if isAddToWishList {
//                        cartItem!.addToWishList = "YES"
//                    }
//                    if isDeleteFromCartList{
//                        cartItem!.addToCart = "NO"
//                    }
//                    if isDeleteFromWishList{
//                        cartItem!.addToWishList = "NO"
//                        
//                    }
//                } catch {
//                    
//                }
//                
//              /*  let cartData : CX_Cart = (cartlist.lastObject as? CX_Cart)!
//                if isAddToCartList {
//                    cartData.addToCart = "YES"
//                }
//                if isAddToWishList {
//                    cartData.addToWishList = "YES"
//                }
//                if isDeleteFromCartList{
//                    cartData.addToCart = "NO"
//                }
//                if isDeleteFromWishList{
//                    cartData.addToWishList = "NO"
//                    
//                }*/
//            }
//            
//            }, completion: { (success : Bool, error : NSError!) in
//                print("save the data >>>>>")
//                // NSNotificationCenter.defaultCenter().postNotificationName("updateCartBtnAction", object: nil)
//                 completionHandler(success)
//                //LoadingView.hide()
//                // This block runs in main thread
//        })
        
    }
    
    /*
     do {
     let fetchedEntities = try self.Context!.executeFetchRequest(request) as! [AccountDetail]
     
     for entity in fetchedEntities {
     self.Context!.deleteObject(entity)
     }
     
     try self.Context!.save()
     } catch {
     print(error)
     }
     */
    
    
     func isAddToCart(productID : NSString) -> (isAddedToCart:Bool, isAddedToWishList:Bool) {
        let fetchRequest = NSFetchRequest(entityName: "CX_Cart")
        fetchRequest.predicate = NSPredicate(format: "pID = %@", productID)
        let cartsDataArrya : NSArray = CX_Cart.MR_executeFetchRequest(fetchRequest)
        if cartsDataArrya.count != 0 {
            let  cart = cartsDataArrya.lastObject as?CX_Cart
            var  isAddToCart : Bool =  false
            var isAddToWishList : Bool = false
            if cart?.addToCart == NSNumber(integer: 1) {
                isAddToCart = true
            }
            if cart?.addToWishList == NSNumber(integer: 1) {
                isAddToWishList = true
            }
            return (isAddToCart,isAddToWishList)
        }else{
            return (false,false)
        }
    }
    
    
      func deleteCartItem(productId : NSString){
        let predicate:NSPredicate = NSPredicate(format: "pID = %@",productId)
        let fetchRequest = NSFetchRequest(entityName: "CX_Cart")
        fetchRequest.predicate = predicate
        let cartsDataArrya : NSArray = CX_Cart.MR_executeFetchRequest(fetchRequest)
        NSManagedObjectContext.MR_contextForCurrentThread().deleteObject((cartsDataArrya.lastObject as?CX_Cart)!)
        NSManagedObjectContext.MR_contextForCurrentThread().MR_saveOnlySelfAndWait()
        NSNotificationCenter.defaultCenter().postNotificationName("updateCartBtnAction", object: nil)
    }
    
    
}


extension CXDataService {
    
    

    
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
