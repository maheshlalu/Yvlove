//
//  CXAppDataManager.swift
//  NowFloats
//
//  Created by Mahesh Y on 8/24/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit
private var _sharedInstance:CXAppDataManager! = CXAppDataManager()
public class CXAppDataManager: NSObject {

    
    class var sharedInstance : CXAppDataManager {
        return _sharedInstance
    }
    
    private override init() {
        
    }
    
    func destory () {
        _sharedInstance = nil
    }
    
    
}
