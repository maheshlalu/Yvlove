//
//  CX_FeaturedProducts+CoreDataProperties.swift
//  NowFloats
//
//  Created by apple on 06/09/16.
//  Copyright © 2016 CX. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension CX_FeaturedProducts {

    @NSManaged var campaign_Jobs: String?
    @NSManaged var createdByID: String?
    @NSManaged var fDescription: String?
    @NSManaged var fID: String?
    @NSManaged var item_Code: String?
    @NSManaged var jobId: String?
    @NSManaged var json: String?
    @NSManaged var name: String?
    @NSManaged var itHasJobs: NSNumber?

}
