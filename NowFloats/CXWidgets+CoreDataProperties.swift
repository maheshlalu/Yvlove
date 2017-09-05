//
//  CXWidgets+CoreDataProperties.swift
//  NowFloats
//
//  Created by Manishi on 9/5/17.
//  Copyright © 2017 CX. All rights reserved.
//

import Foundation
import CoreData


extension CXWidgets {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CXWidgets> {
        return NSFetchRequest<CXWidgets>(entityName: "CXWidgets")
    }

    @NSManaged public var displayName: String?
    @NSManaged public var enabledReviews: String?
    @NSManaged public var enabledUserAddition: String?
    @NSManaged public var highlighted: String?
    @NSManaged public var name: String?
    @NSManaged public var visibility: String?
    @NSManaged public var widgetType: String?

}
