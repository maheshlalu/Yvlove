//
//  CX_Cart+CoreDataProperties.swift
//  NowFloats
//
//  Created by apple on 15/09/16.
//  Copyright © 2016 CX. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension CX_Cart {

    @NSManaged var addToCart: NSNumber?
    @NSManaged var addToWishList: NSNumber?
    @NSManaged var createdByID: String?
    @NSManaged var favourite: String?
    @NSManaged var imageUrl: String?
    @NSManaged var itemCode: String?
    @NSManaged var json: String?
    @NSManaged var mallID: String?
    @NSManaged var name: String?
    @NSManaged var p3rdCategory: String?
    @NSManaged var pID: String?
    @NSManaged var quantity: NSNumber?
    @NSManaged var storeID: String?
    @NSManaged var subCatNameID: String?
    @NSManaged var type: String?
    @NSManaged var productPrice: NSNumber?

}
