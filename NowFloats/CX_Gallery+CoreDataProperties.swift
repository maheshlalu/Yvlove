//
//  CX_Gallery+CoreDataProperties.swift
//  NowFloats
//
//  Created by apple on 07/09/16.
//  Copyright © 2016 CX. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension CX_Gallery {

    @NSManaged var gID: String?
    @NSManaged var gImageUrl: String?
    @NSManaged var isCoverImage: String?
    @NSManaged var isBannerImage: String?

}
