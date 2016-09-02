//
//  CX_Stores+CoreDataProperties.swift
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

extension CX_Stores {

    @NSManaged var createdById: String?
    @NSManaged var favourite: String?
    @NSManaged var itemCode: String?
    @NSManaged var json: String?
    @NSManaged var name: String?
    @NSManaged var storeID: String?
    @NSManaged var type: String?

}
