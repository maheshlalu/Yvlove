//
//  Serices.swift
//  NowFloats
//
//  Created by apple on 30/09/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit

class Serices {

    var name: String
    var addMore: Bool
    var type: String
    var mandatory: String
    var allowedValues: String
    var multiselect: String
    var groupName: String
    var dependentFields: String
    var propgateValueToSubFormFields: String

    
    init(name: String,
         addMore: Bool,
         type: String,
         dependentFields: String,
         mandatory: String,
         allowedValues: String,
         multiselect: String,
         groupName: String,
         propgateValueToSubFormFields: String)
    {
        self.name = name
        self.addMore = addMore
        self.type = type
        self.mandatory = mandatory
        self.allowedValues = allowedValues
        self.multiselect = multiselect
        self.groupName = groupName
        self.dependentFields = dependentFields
        self.propgateValueToSubFormFields = propgateValueToSubFormFields
        
    }
    
    
}
