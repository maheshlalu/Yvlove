//
//  CXDataService.swift
//  NowFloats
//
//  Created by Mahesh Y on 8/24/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit
import Alamofire
import AFNetworking
private var _SingletonSharedInstance:CXDataService! = CXDataService()

open class CXDataService: NSObject {

    class var sharedInstance : CXDataService {
        return _SingletonSharedInstance
    }
    
    fileprivate override init() {
        
    }
    
    func destory () {
        _SingletonSharedInstance = nil
    }
    
    open func getTheAppDataFromServer(_ parameters:[String: AnyObject]? = nil ,completion:@escaping (_ responseDict:NSDictionary) -> Void){
        if Bool(1) {
      /*  Alamofire.request(.GET,CXAppConfig.sharedInstance.getBaseUrl() + CXAppConfig.sharedInstance.getMasterUrl() , parameters: parameters)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    completion(responseDict: (response.result.value as? NSDictionary)!)
                    break
                case .failure(let error):
                }
        }
        }else{
            
        }
        */
        
        Alamofire.request(CXAppConfig.sharedInstance.getBaseUrl() + CXAppConfig.sharedInstance.getMasterUrl(), method: .post, parameters: parameters, encoding: URLEncoding.`default`)
            .responseJSON { response in
                
                //to get status code
                switch (response.result) {
                case .success:
                    //to get JSON return value
                    if let result = response.result.value {
                        let JSON = result as! NSDictionary
                        //completion((response.result.value as? NSDictionary)!)
                        completion(JSON)
                    }
                    break
                case .failure(let error):
                    if error._code == NSURLErrorTimedOut || error._code == NSURLErrorCancelled{
                        //timeout here
                    }
                    break
                }
        }        
    }
    }
    
    func generateBoundaryString() -> String
    {
        return "\(UUID().uuidString)"
    }
    
    open func synchDataToServerAndServerToMoblile(_ urlstring:String, parameters:[String: AnyObject]? = nil ,completion:@escaping (_ responseDict:NSDictionary) -> Void){
    
    
       /* Alamofire.request(.POST,urlstring, parameters: parameters)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    completion(responseDict: (response.result.value as? NSDictionary)!)
                    break
                case .failure(let error):
                }
        }*/
        Alamofire.request(urlstring, method: .post, parameters: parameters, encoding: URLEncoding.httpBody)
            .validate()
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                
                switch (response.result) {
                case .success:
                    //to get JSON return value
                    if let result = response.result.value {
                        let JSON = result as! NSDictionary
                        //completion((response.result.value as? NSDictionary)!)
                        completion(JSON)
                    }
                    break
                case .failure(let error):
                    if error._code == NSURLErrorTimedOut {
                        //timeout here
                    }
                    break
                }
                
        }

        
    }
    
    open func imageUpload(_ imageData:Data,completion:@escaping (_ Response:NSDictionary) -> Void){

        let mutableRequest : AFHTTPRequestSerializer = AFHTTPRequestSerializer()
        let request1 : NSMutableURLRequest =    mutableRequest.multipartFormRequest(withMethod: "POST", urlString: CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getphotoUploadUrl(), parameters: ["refFileName": self.generateBoundaryString()], constructingBodyWith: { (formatData:AFMultipartFormData) in
            formatData.appendPart(withFileData: imageData, name: "srcFile", fileName: "uploadedFile.jpg", mimeType: "image/jpeg")
            }, error: nil)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request1 as URLRequest) {
            (
            data, response, error) in
            
            guard let _:NSData = data as NSData?, let _:URLResponse = response  , error == nil else {
                return
            }
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            let myDic = self.convertStringToDictionary(dataString! as String)
            completion(myDic)
            
        }
        
        task.resume()
        
        
        
        
//        Alamofire.upload(
//            .POST,
//            CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getphotoUploadUrl(),
//            headers: ["Content-Type":"application/json"],
//            multipartFormData: { multipartFormData in
//                multipartFormData.appendBodyPart(data: imageData, name: "srcFile",
//                    fileName: "uploadedFile.jpg", mimeType: "")
//            },
//            encodingCompletion: { encodingResult in
//            }
//        )
    }
    
    
    func convertStringToDictionary(_ string:String) -> NSDictionary {
        var jsonDict : NSDictionary = NSDictionary()
        let data = string.data(using: String.Encoding.utf8)
        do {
            jsonDict = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.mutableContainers ) as! NSDictionary            // CXDBSettings.sharedInstance.saveAllMallsInDB((jsonData.valueForKey("orgs") as? NSArray)!)
        } catch {
        }
        return jsonDict
    }

    
    open func getTheUpdatesFromServer(_ parameters:[String: AnyObject]? = nil ,completion:@escaping (_ responseDict:NSDictionary) -> Void){
        
       /* https://api.withfloats.com/Discover/v2/floatingPoint/bizFloats?clientId=5FAE0707506C43BAB8B8C9F554586895577B22880B834423A473E797607EFCF6&skipBy=0&fpid=kljadlkcjasd898979
         
         clientId=5FAE0707506C43BAB8B8C9F554586895577B22880B834423A473E797607EFCF6&skipBy=0&fpid=kljadlkcjasd898979
        */
       /* Alamofire.request(.GET,"https://api.withfloats.com/Discover/v2/floatingPoint/bizFloats?", parameters: parameters)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    completion(responseDict: (response.result.value as? NSDictionary)!)
                    break
                case .failure(let error):
                }
        }
        */
   
        Alamofire.request("https://api.withfloats.com/Discover/v2/floatingPoint/bizFloats?", method: .post, parameters: parameters, encoding: URLEncoding.httpBody)
            .validate()
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                
                switch (response.result) {
                case .success:
                    //to get JSON return value
                    if let result = response.result.value {
                        let JSON = result as! NSDictionary
                        //completion((response.result.value as? NSDictionary)!)
                        completion(JSON)
                    }
                    break
                case .failure(let error):
                    if error._code == NSURLErrorTimedOut {
                        //timeout here
                    }
                    break
                }
        }
    }
}
