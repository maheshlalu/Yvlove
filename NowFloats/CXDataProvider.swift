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
import CoreSpotlight
import MobileCoreServices

private var _sharedInstance:CXDataProvider! = CXDataProvider()

class CXDataProvider: NSObject {
    class var sharedInstance : CXDataProvider {
        return _sharedInstance
    }
    
    fileprivate override init() {
        
    }
    
    func destory () {
        _sharedInstance = nil
    }
    
    //MARK:Save The StoreCategory
    
    func saveTheStoreCategory(_ jsonDic:NSDictionary){
        
        let jobs : NSArray =  jsonDic.value(forKey: "jobs")! as! NSArray
        
        MagicalRecord.save({ (localContext) in
            
            for storeCategory in jobs{
                
                
            }
            
            
            
        }) { (success, error) in
            
            if success == true {
                
            }else {
                print("Error\(error)")
            }
        }
        
    }
 
    func saveTheProducts(_ jsonDic:NSDictionary ,completion:@escaping (_ isDataSaved:Bool) -> Void){
        
        let jobs : NSArray =  jsonDic.value(forKey: "jobs")! as! NSArray
        
        
        MagicalRecord.save({ (localContext) in
            for prodDic in jobs {
                let prod = prodDic as? NSDictionary
                let enProduct =  NSEntityDescription.insertNewObject(forEntityName: "CX_Products", into: localContext!) as? CX_Products
                let createByID : String = CXConstant.resultString(prod!.value(forKey: "createdById")! as AnyObject)
                enProduct!.createdById = createByID
                enProduct!.itemCode = prod?.value(forKey: "ItemCode") as? String
                let jsonString = CXConstant.sharedInstance.convertDictionayToString(prod!)
                enProduct!.json = jsonString as String
                enProduct!.name = (prod as AnyObject).value(forKey: "Name") as? String
                enProduct!.pid = CXConstant.resultString(prod!.value(forKey: "id")! as AnyObject)
                enProduct?.pPrice = 1
                
                let updateDate = prod?.value(forKey: "UpdatedOn") as? String
                
                #if MyLabs
                    
                #else
                    let component = updateDate?.components(separatedBy: NSCharacterSet.decimalDigits.inverted)
                    let list = component?.filter({ $0 != "" })
                    let number = Int((list?[0])!)
                    enProduct?.pUpdateDate =  number as NSNumber?
                #endif
                
                
                
                
                enProduct?.pPrice = Int((prod?.value(forKey: "MRP") as? String)!) as NSNumber?//MRP
                
                //enProduct!.storeId = CXConstant.resultString((prod.valueForKey("storeId"))!)
                let str = (prod as AnyObject).value(forKey: "jobTypeName") as? String
                let finalStr = str?.replacingOccurrences(of: " ", with: "")
                enProduct?.type = finalStr //(prod as AnyObject).value(forKey: "jobTypeName") as? String //Remove The Spaces in JobType key
                enProduct?.imageUrl =  (prod as AnyObject).value(forKey: "Image_URL") as? String
                // self.saveContext()
                
//                let productDic = CXConstant.sharedInstance.convertStringToDictionary(enProduct!.json!)
              //  self.addItemToSpotlightSearch((enProduct?.name)!, productImage:imageData!, productDesc:CXAppConfig.sharedInstance.getTheDataInDictionaryFromKey(sourceDic: prodDic as! NSDictionary, sourceKey: "Description") ,identifier: (enProduct?.pid)!)

                self.addTheProductsToSpotlightSearch(productName: CXAppConfig.sharedInstance.getTheDataInDictionaryFromKey(sourceDic: prodDic as! NSDictionary, sourceKey: "Name"),
                                                     thumNailUrl: CXAppConfig.sharedInstance.getTheDataInDictionaryFromKey(sourceDic: prodDic as! NSDictionary, sourceKey: "Image_URL"),
                                                     productDic: CXAppConfig.sharedInstance.getTheDataInDictionaryFromKey(sourceDic: prodDic as! NSDictionary, sourceKey: "Description"),
                                                     identfier: enProduct!.pid!)
                
            }
            
        }) { (success, error) in
            if success == true {
                completion(success)
                //                if let delegate = self.delegate {
                //                    delegate.didFinishProducts(productCatName)
                //                }
            } else {
                print("Error\(error)")
            }
        }
    }
    
    func saveTheFeatureProducts(_ jsonDic:NSDictionary ,completion:@escaping (_ isDataSaved:Bool) -> Void){
        let jobs : NSArray =  jsonDic.value(forKey: "jobs")! as! NSArray
        if  jobs.count == 0 {
            completion(false)
        }
        MagicalRecord.save({ (localContext) in
            for prodDic in jobs {
                let prod = prodDic as? NSDictionary
                let enProduct =  NSEntityDescription.insertNewObject(forEntityName: "CX_FeaturedProducts", into: localContext!) as? CX_FeaturedProducts
                let createByID : String = CXConstant.resultString(prod!.value(forKey: "createdById")! as AnyObject)
                enProduct!.createdByID = createByID
                enProduct!.item_Code = (prod as AnyObject).value(forKey: "ItemCode") as? String
                let jsonString = CXConstant.sharedInstance.convertDictionayToString(prod!)
                enProduct!.json = jsonString as String
                enProduct!.name = (prod as AnyObject).value(forKey: "Name") as? String
                enProduct!.fID = CXConstant.resultString(prod!.value(forKey: "id")! as AnyObject)
                enProduct?.campaign_Jobs = (prod as AnyObject).value(forKey: "Campaign_Jobs") as? String
                enProduct?.itHasJobs = false
                
            }
            
        }) { (success, error) in
            if success == true {
                completion(success)

                //                if let delegate = self.delegate {
                //                    delegate.didFinishProducts(productCatName)
                //                }
            } else {
                completion(success)
            }
        }
    }
    
    func saveTheFeaturedProductJobs(_ jsonDic:NSDictionary,parentID:String ,completion:@escaping (_ isDataSaved:Bool) -> Void) {
        
        let jobs : NSArray =  jsonDic.value(forKey: "jobs")! as! NSArray
        MagicalRecord.save({ (localContext) in
            for prodDic in jobs {
                
                let prod = prodDic as? NSDictionary

                let enProduct =  NSEntityDescription.insertNewObject(forEntityName: "CX_FeaturedProductsJobs", into: localContext!) as? CX_FeaturedProductsJobs
                let createByID : String = CXConstant.resultString(prod!.value(forKey: "createdById")! as AnyObject)
                enProduct!.createdByID = createByID
                enProduct?.image_URL =  (prod as AnyObject).value(forKey: "Image_URL") as? String
                enProduct?.fDescription =  (prod as AnyObject).value(forKey: "Description") as? String
                let jsonString = CXConstant.sharedInstance.convertDictionayToString(prod!)
                enProduct!.json = jsonString as String
                enProduct!.name = (prod as AnyObject).value(forKey: "Name") as? String
                enProduct!.fID = CXConstant.resultString(prod!.value(forKey: "id")! as AnyObject)
                enProduct?.parentID = parentID
                

            }
            
        }) { (success, error) in
            if success == true {
                completion(success)
                
                //                if let delegate = self.delegate {
                //                    delegate.didFinishProducts(productCatName)
                //                }
            } else {
                print("Error\(error)")
            }
        }
    }
    
    
    
    func saveStoreInDB(_ resDict:NSDictionary ,completion:@escaping (_ isDataSaved:Bool) -> Void) {

        let jobs : NSArray =  resDict.value(forKey: "jobs")! as! NSArray

        MagicalRecord.save({ (localContext) in
          for prodDic in jobs {
            let prod = prodDic as? NSDictionary

            let enStore = NSEntityDescription.insertNewObject(forEntityName: "CX_Stores", into: localContext!) as? CX_Stores
            enStore!.storeID = CXConstant.resultString(prod!.value(forKey: "id")! as AnyObject)
            enStore!.name = (prod as AnyObject).value(forKey: "Name") as? String
            enStore!.type = (prod as AnyObject).value(forKey: "Type") as? String
            let jsonString = CXConstant.sharedInstance.convertDictionayToString(prod!)
            enStore!.json = jsonString as String
            enStore!.createdById = CXConstant.resultString(prod!.value(forKey: "createdById")! as AnyObject)
            enStore!.itemCode = (prod as AnyObject).value(forKey: "ItemCode") as? String
            self.SaveTheGallaryItems(((prod as AnyObject).value(forKey: "Attachments") as? NSArray)!)
                }
        }) { (success, error) in
            if success == true {
                completion(success)
            } else {
                print("Error\(error)")
            }
            
        }
    
    }
    
    
    func SaveTheGallaryItems(_ galeryItems:NSArray){
        MagicalRecord.save({ (localContext) in
            for prodDic in galeryItems {
                
                let gallaeryData = prodDic as? NSDictionary

                let enStore = NSEntityDescription.insertNewObject(forEntityName: "CX_Gallery", into: localContext!) as? CX_Gallery
                enStore?.gID = CXConstant.resultString(gallaeryData!.value(forKey: "Id")! as AnyObject)
                enStore?.gImageUrl = (gallaeryData as AnyObject).value(forKey: "URL") as? String
                enStore?.isCoverImage = (gallaeryData as AnyObject).value(forKey: "isCoverImage") as? String
                enStore?.isBannerImage = (gallaeryData as AnyObject).value(forKey: "isBannerImage") as? String
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
    
    
    func saveSingleMallInDB(_ resDict:NSDictionary ,completion:@escaping (_ isDataSaved:Bool) -> Void) {
        
        print("single mall Dic \(resDict)")
        let jobs : NSArray =  resDict.value(forKey: "orgs")! as! NSArray
        CXConstant.sharedInstance.saveTheFid(CXConstant.resultString(resDict.value(forKeyPath: "orgs.fpId")! as AnyObject))
        MagicalRecord.save({ (localContext) in
            for prod in jobs {
                let enSMall = CX_SingleMall.mr_create(in: localContext) as! CX_SingleMall
                let jsonString = CXConstant.sharedInstance.convertDictionayToString(prod as! NSDictionary)
                enSMall.json = jsonString as String
            }
        }) { (success, error) in
            if success == true {
                completion(true)
            } else {
                print("Error\(error)")
            }
        }
        
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
    
    func getJobID(_ input:String,inputDic:String) -> String {
        let json :NSDictionary = (CXConstant.sharedInstance.convertStringToDictionary(inputDic))
        let info : String = CXConstant.resultString(json.value(forKey: input)! as AnyObject)
        return info
        
    }
    // Spotlight search
    func addItemToSpotlightSearch(_ productName:String,productImage:Data,productDesc:String,identifier:String){
    
        let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
        attributeSet.title = productName
        attributeSet.thumbnailData  = productImage
        attributeSet.contentDescription = productDesc
        
        let item = CSSearchableItem(uniqueIdentifier: identifier, domainIdentifier: "com.nowFloats.cx", attributeSet: attributeSet)
        
        CSSearchableIndex.default().indexSearchableItems([item]) { error in
            if let error = error { 
                print("Indexing error: \(error.localizedDescription)")
            } else {
               // print("Search item successfully indexed!")
            }
        }
    }
    
    //Products adding to SpotLight 
    
    func addTheProductsToSpotlightSearch(productName:String,
                                         thumNailUrl:String,
                                         productDic:String,
                                         identfier:String){
        
        let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
        attributeSet.title = productName
        attributeSet.thumbnailURL  = NSURL(string: thumNailUrl) as URL?
        attributeSet.contentDescription = productDic
        
        let item = CSSearchableItem(uniqueIdentifier: identfier, domainIdentifier: "com.nowFloats.cx", attributeSet: attributeSet)
        
        CSSearchableIndex.default().indexSearchableItems([item]) { error in
            if let error = error {
                print("Indexing error: \(error.localizedDescription)")
            } else {
                // print("Search item successfully indexed!")
            }
        }
    }
    
    
    func getTheTableDataFromDataBase(_ entityName: String ,predicate:NSPredicate,ispredicate:Bool,orederByKey:String) -> (dataArray:NSArray, totalCount:NSInteger){
        
        let fetchRequest : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
        if !orederByKey.isEmpty {
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: orederByKey, ascending: false)]
        }
        // let fetchRequest = CX_Products.MR_requestAllSortedBy("storeID", ascending: false) /
        if ispredicate {
            fetchRequest.predicate = predicate
        }
        
        do {
            let result = try  NSManagedObjectContext.mr_contextForCurrentThread().fetch(fetchRequest)
            return(result as NSArray ,result.count)
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        return([],0)
    }
    
    
    func getTheProducts(_ predicate:NSPredicate,ispredicate:Bool) -> (dataArray:NSArray, totalCount:NSInteger){
        
       // let fetchRequest = CX_Products.MR_requestAllSortedBy("pid", ascending: false)
        
        let fetchRequest : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CX_Products")

        fetchRequest.predicate = predicate
        let productCatList :NSArray = CX_Products.mr_executeFetchRequest(fetchRequest) as NSArray
        
        return(productCatList,productCatList.count)
    }
    
    
    func getTheFeaturedProducts(_ predicate:NSPredicate,ispredicate:Bool) -> (dataArray:NSArray, totalCount:NSInteger){
        
        let fetchRequest = CX_FeaturedProducts.mr_requestAllSorted(by: "fID", ascending: false)
         if ispredicate {
            fetchRequest?.predicate = predicate
        }
        
        let productCatList :NSArray = CX_FeaturedProducts.mr_executeFetchRequest(fetchRequest) as NSArray
        
        return(productCatList,productCatList.count)
    }
    
    
    func getTheFeaturedProductJobs(_ predicate:NSPredicate,ispredicate:Bool) -> (dataArray:NSArray, totalCount:NSInteger){
        
        let fetchRequest = CX_FeaturedProductsJobs.mr_requestAllSorted(by: "fID", ascending: false)
        if ispredicate {
            fetchRequest?.predicate = predicate
        }
        let productCatList :NSArray = CX_FeaturedProductsJobs.mr_executeFetchRequest(fetchRequest) as NSArray
        
        return(productCatList,productCatList.count)
    }
    
    
    
    
    func itemAddToWishListOrCarts(_ productJson:String,itemID:String,isAddToWishList:Bool,isAddToCartList:Bool,isDeleteFromWishList:Bool,isDeleteFromCartList:Bool,completionHandler: (Bool) -> ()){
        let productJsonDic = CXConstant.sharedInstance.convertStringToDictionary(productJson)
        
        //var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let cartlist : NSArray =  CX_Cart.mr_findAll(with: NSPredicate(format: "pID = %@", itemID)) as NSArray
        //var  cart : CX_Cart = (CX_Cart.MR_findFirstWithPredicate(NSPredicate(format: "pID = %@", itemID)) as?CX_Cart)!
        if cartlist.count == 0{
           let cart = CX_Cart.mr_createEntity() as!CX_Cart
            if isAddToCartList {
                cart.addToCart = NSNumber(value: true as Bool)
            }
            if isAddToWishList {
                cart.addToWishList = NSNumber(value: true as Bool)
            }
            //enProduct.itemCode = product.itemCode
            cart.name =  productJsonDic.value(forKey: "Name") as? String
            cart.pID = CXConstant.resultString(productJsonDic.value(forKey: "id")! as AnyObject)
            cart.imageUrl =  productJsonDic.value(forKey: "Image_URL") as? String
            cart.json =  productJson
            
            //Trimming Price And Discount
            let floatPrice: Float = Float(CXDataProvider.sharedInstance.getJobID("MRP", inputDic: productJson))!
            let finalPrice = String(format: floatPrice == floor(floatPrice) ? "%.0f" : "%.1f", floatPrice)
            
            let floatDiscount:Float = Float(CXDataProvider.sharedInstance.getJobID("DiscountAmount", inputDic: productJson))!
            let finalDiscount = String(format: floatDiscount == floor(floatDiscount) ? "%.0f" : "%.1f", floatDiscount)
            
            //FinalPrice after subtracting the discount
            let finalPriceNum:Int! = Int(finalPrice)!-Int(finalDiscount)!
            let FinalPrice = finalPriceNum
            
            
            cart.productPrice = FinalPrice as NSNumber?
            cart.quantity = 1
            //cart.managedObjectContext?.MR_saveToPersistentStoreAndWait()

        }else{
            do {
                let cartItem : CX_Cart = (cartlist.lastObject as? CX_Cart)!
                cartItem.quantity = 1
                if isAddToCartList {
                    cartItem.addToCart = NSNumber(value: true as Bool)
                }
                
                if isAddToWishList {
                    cartItem.addToWishList = NSNumber(value: true as Bool)
                }
                if isDeleteFromCartList{
                    cartItem.addToCart = NSNumber(value: false as Bool)
                }
                if isDeleteFromWishList{
                    cartItem.addToWishList = NSNumber(value: false as Bool)
                    
                }
                
            } catch {
                
            }

            
            
        }
       // appDelegate.saveContext()

        
   NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
         completionHandler(true)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "CartCountUpdate"), object: nil)

        
        
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
    
    
     func isAddToCart(_ productID : NSString) -> (isAddedToCart:Bool, isAddedToWishList:Bool) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CX_Cart")
        fetchRequest.predicate = NSPredicate(format: "pID = %@", productID)
        let cartsDataArrya : NSArray = CX_Cart.mr_executeFetchRequest(fetchRequest) as NSArray
        if cartsDataArrya.count != 0 {
            let  cart = cartsDataArrya.lastObject as?CX_Cart
            var  isAddToCart : Bool =  false
            var isAddToWishList : Bool = false
            if cart?.addToCart == NSNumber(value: 1 as Int) {
                isAddToCart = true
            }
            if cart?.addToWishList == NSNumber(value: 1 as Int) {
                isAddToWishList = true
            }
            return (isAddToCart,isAddToWishList)
        }else{
            return (false,false)
        }
    }
    
    
      func deleteCartItem(_ productId : NSString){
        let predicate:NSPredicate = NSPredicate(format: "pID = %@",productId)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CX_Cart")
        fetchRequest.predicate = predicate
        let cartsDataArrya : NSArray = CX_Cart.mr_executeFetchRequest(fetchRequest) as NSArray
        NSManagedObjectContext.mr_contextForCurrentThread().delete((cartsDataArrya.lastObject as?CX_Cart)!)
        NSManagedObjectContext.mr_contextForCurrentThread().mr_saveOnlySelfAndWait()
        NotificationCenter.default.post(name: Notification.Name(rawValue: "updateCartBtnAction"), object: nil)
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
