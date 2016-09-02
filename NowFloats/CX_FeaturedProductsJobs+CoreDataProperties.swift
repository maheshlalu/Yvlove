//
//  CX_FeaturedProductsJobs+CoreDataProperties.swift
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

extension CX_FeaturedProductsJobs {

    @NSManaged var createdByID: String?
    @NSManaged var fDescription: String?
    @NSManaged var fID: String?
    @NSManaged var image_URL: String?
    @NSManaged var itemCode: String?
    @NSManaged var jobId: String?
    @NSManaged var jobTypeName: String?
    @NSManaged var json: String?
    @NSManaged var name: String?
    @NSManaged var parentID: String?

}
