//
//  Events+CoreDataProperties.swift
//  NowFloats
//
//  Created by Manishi on 9/5/17.
//  Copyright © 2017 CX. All rights reserved.
//

import Foundation
import CoreData


extension Events {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Events> {
        return NSFetchRequest<Events>(entityName: "Events")
    }

    @NSManaged public var eventDate: String?

}
