//
//  CXDataService.swift
//  NowFloats
//
//  Created by Mahesh Y on 8/24/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit
import Alamofire

private var _SingletonSharedInstance:CXDataService! = CXDataService()

public class CXDataService: NSObject {

    class var sharedInstance : CXDataService {
        return _SingletonSharedInstance
    }
    
    private override init() {
        
    }
    
    func destory () {
        _SingletonSharedInstance = nil
    }
    
    public func getTheAppDataFromServer(parameters:[String: AnyObject]? = nil ,completion:(responseDict:NSDictionary) -> Void){
        Alamofire.request(.GET,CXAppConfig.sharedInstance.getBaseUrl() + CXAppConfig.sharedInstance.getMasterUrl() , parameters: parameters)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .Success:
                    //print("Validation Successful\(response.result.value)")
                    completion(responseDict: (response.result.value as? NSDictionary)!)
                    break
                case .Failure(let error):
                    print(error)
                }
        }
        
        
    }
    
    
    
}
