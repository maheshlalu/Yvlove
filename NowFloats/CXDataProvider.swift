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
    
    func saveTheProducts(jsonDic:NSDictionary){
        
        let jobs : NSArray =  jsonDic.valueForKey("jobs")! as! NSArray

        
        MagicalRecord.saveWithBlock({ (localContext) in
            for prod in jobs {
                let enProduct =  NSEntityDescription.insertNewObjectForEntityForName("CX_Products", inManagedObjectContext: localContext) as? CX_Products
                let createByID : String = CXConstant.resultString(prod.valueForKey("createdById")!)
                enProduct!.createdById = createByID
                enProduct!.itemCode = prod.valueForKey("ItemCode") as? String
                let jsonString = CXConstant.sharedInstance.convertDictionayToString(prod as! NSDictionary)
                enProduct!.json = jsonString as String
                enProduct!.name = prod.valueForKey("Name") as? String
                enProduct!.pid = CXConstant.resultString(prod.valueForKey("id")!)
                enProduct!.storeId = CXConstant.resultString(prod.valueForKey("storeId")!)
                enProduct!.type = prod.valueForKey("jobTypeName") as? String
                // self.saveContext()
            }
            
        }) { (success, error) in
            if success == true {
//                if let delegate = self.delegate {
//                    delegate.didFinishProducts(productCatName)
//                }
            } else {
                print("Error\(error)")
            }
        }
        
        
    }
}

/*
 
 
 {
 "Additional_Details" =     {
 };
 ApplicationId = A91B82DE3E93446A8141A52F288F69EFA1B09B1D13BB4E55BE743AB547B3489E;
 Attachments =     (
 );
 BuyOnlineLink = "";
 CategoryType = "";
 "Category_Mall" = Default;
 CreatedOn = "/Date(1414048927807)/";
 CreatedSubJobs =     (
 );
 "Current_Job_Status" = Active;
 "Current_Job_StatusId" = 173;
 CustomWidgets = "";
 Description = "Hotel Category : 4 Star Standard\nHotel Name :Pride Sun Village  Goa, Baga, Arpora\ncheck in :1 pm Check out : 11 am\n\nInclusions:\n* Hotel accommodation for 3 nights in One Standard room\n* Buffet Breakfast, Lunch & Dinner for 3 days\n* Pick up and drop from Bus stand or Airport\n* One Half day  sightseeing of North Goa ( Hotel Coach )\n* One Half day  sightseeing of South Goa ( Hotel Coach )\n* One hour boat cruise in River Mondovi\n \nDay-wise itinerary:\nDay 01: Pick up from bus stand/Airport , Check in to Resorts as per Checking timing and proceed for North Goa sightseeing and overnight stay at resort\nDay 02: After breakfast, day leisure for relaxation or shopping\nDay 03: After breakfast, proceed for South Goa Sightseeing followed by boat cruise and overnight stay at the resort.\nDay 04: After breakfast, drop at the bus stand for departure \n";
 DiscountAmount = 2000;
 ExternalSourceId = "";
 GPId = null;
 "Image_Name" = "14658802412512850614787902465222.jpg";
 "Image_URL" = "https://s3-ap-southeast-1.amazonaws.com/store-ongo/vusar/jobs/web/attachments/11_1465880301988109.jpg";
 Insights =     ;
 IsArchived = "";
 IsAvailable = true;
 ItemCode = "186d98e7-e9e2-4d01-b7d5-20e71a1b8765";
 Keywords = "[\"separate AC vehicle\",\"South Goa Sightseeing\",\"Goa 3N4Days Standard\",\"North Goa sightseeing\",\"bus stand\",\"Half Day sightseeing\",\"bus stand  Check\",\"Couple   Hotel Category\",\"overnight stay\",\"Buffet Breakfast\",\"boat cruise\",\"breakfast drop\",\"breakfast day leisure\",\"applicable taxes\",\"River Mondovi\",\"Star Standard\",\"Hotel Name  Resort\",\"pm Check\",\"Hotel accommodation\",\"Standard room\",\"departure journey\",\"Daywise itinerary\",\"Checking timing\",\"hrs\",\"Inclusions\",\"Pick\",\"relaxation\",\"nights\",\"Package\"]";
 "Large_Image_Name" = "1465880241319860115382407998923.jpg";
 "Large_Image_URL" = "https://s3-ap-southeast-1.amazonaws.com/store-ongo/vusar/jobs/web/attachments/11_1465880302473110.jpg";
 MRP = 26000;
 MerchantName = "";
 Name = "Enticing Goa 3N/4Days 4 star Hotel  Package For Couple ";
 "Next_Job_Statuses" =     (
 {
 SeqNo = 2;
 "Status_Id" = 174;
 "Status_Name" = Inactive;
 "Sub_Jobtype_Forms" =             (
 );
 }
 );
 "Next_Seq_Nos" = 2;
 P3rdCategory = "";
 PackageName = "";
 Priority = 1000000;
 ShipmentDuration = 7;
 SubCategoryType = "";
 UpdatedOn = "/Date(1442474577489)/";
 createdByFullName = "68M Holidays";
 createdById = 11;
 createdOn = "11:43 Apr 23, 2016";
 fpId = 5448ac9f4ec0a416f834e937;
 hrsOfOperation =     (
 );
 id = 169;
 jobComments =     (
 );
 jobTypeId = 83;
 jobTypeName = Products;
 overallRating = "0.0";
 publicURL = "http://nowfloats.ongostore.com/app/11/Products;Products;169;_;SingleProduct";
 storeId = "68M Holidays(157)";
 totalReviews = 0;
 }
 */
