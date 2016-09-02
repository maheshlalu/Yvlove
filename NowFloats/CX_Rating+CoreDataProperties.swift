//
//  CX_Rating+CoreDataProperties.swift
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

extension CX_Rating {

    @NSManaged var disabled: String?
    @NSManaged var jobId: String?
    @NSManaged var logo: String?
    @NSManaged var postedId: String?
    @NSManaged var rDescription: String?
    @NSManaged var rID: String?
    @NSManaged var time: String?
    @NSManaged var userName: String?
    @NSManaged var userRatingValue: String?

}
