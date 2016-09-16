//
//  CX_SingleMall+CoreDataProperties.swift
//  NowFloats
//
//  Created by apple on 16/09/16.
//  Copyright © 2016 CX. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension CX_SingleMall {

    @NSManaged var address: String?
    @NSManaged var city: String?
    @NSManaged var countryCode: String?
    @NSManaged var countryName: String?
    @NSManaged var coverImage: String?
    @NSManaged var email: String?
    @NSManaged var fbLink: String?
    @NSManaged var location: String?
    @NSManaged var mallDesc: String?
    @NSManaged var mallID: String?
    @NSManaged var mobile: String?
    @NSManaged var name: String?
    @NSManaged var state: String?
    @NSManaged var json: String?

}
