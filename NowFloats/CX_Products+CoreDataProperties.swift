//
//  CX_Products+CoreDataProperties.swift
//  NowFloats
//
//  Created by apple on 01/09/16.
//  Copyright © 2016 CX. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension CX_Products {

    @NSManaged var pid: String?
    @NSManaged var name: String?
    @NSManaged var json: String?
    @NSManaged var type: String?
    @NSManaged var storeId: String?
    @NSManaged var favourite: String?
    @NSManaged var itemCode: String?
    @NSManaged var createdById: String?
    @NSManaged var addToCart: String?
    @NSManaged var quantity: String?
    @NSManaged var subCateNameId: String?

}
