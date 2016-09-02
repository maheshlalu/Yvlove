//
//  CX_ProductCategory+CoreDataProperties.swift
//  NowFloats
//
//  Created by apple on 02/09/16.
//  Copyright © 2016 CX. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension CX_ProductCategory {

    @NSManaged var createdByFullName: String?
    @NSManaged var createdById: String?
    @NSManaged var current_Job_Status: String?
    @NSManaged var icon_Name: String?
    @NSManaged var icon_URL: String?
    @NSManaged var itemCode: String?
    @NSManaged var name: String?
    @NSManaged var pID: String?
    @NSManaged var productDescription: String?
    @NSManaged var publicURL: String?
    @NSManaged var storeId: String?

}
