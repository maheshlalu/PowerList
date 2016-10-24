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
        if Bool(1) {
            print(CXAppConfig.sharedInstance.getBaseUrl() + CXAppConfig.sharedInstance.getMasterUrl())
            print(parameters)
            
        Alamofire.request(.GET,CXAppConfig.sharedInstance.getBaseUrl() + CXAppConfig.sharedInstance.getMasterUrl() , parameters: parameters)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .Success:
                   // print("Validation Successful\(response.result.value)")
                    completion(responseDict: (response.result.value as? NSDictionary)!)
                    break
                case .Failure(let error):
                    print(error)
                }
        }
        }else{
            
        }
        
    }
    
    public func synchDataToServerAndServerToMoblile(urlstring:String, parameters:[String: AnyObject]? = nil ,completion:(responseDict:NSDictionary) -> Void){
    
        print(urlstring)
        print(parameters)
        
        Alamofire.request(.POST,urlstring, parameters: parameters)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .Success:
                   // print("Validation Successful\(response.result.value)")
                    completion(responseDict: (response.result.value as? NSDictionary)!)
                    break
                case .Failure(let error):
                    print(error)
                }
        }

        
    }
    
    public func imageUpload(imageData:NSData,completion:(imageFileUrl:String) -> Void){
        
        Alamofire.upload(
            .POST,
            CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getphotoUploadUrl(),
            headers: ["" : ""],
            multipartFormData: { multipartFormData in
                multipartFormData.appendBodyPart(data: imageData, name: "srcFile",
                    fileName: "uploadedFile.jpg", mimeType: "")
            },
            encodingCompletion: { encodingResult in
                
                //print("result")
            }
        )
    }
    
    
    public func getTheUpdatesFromServer(parameters:[String: AnyObject]? = nil ,completion:(responseDict:NSDictionary) -> Void){
        
       /* https://api.withfloats.com/Discover/v2/floatingPoint/bizFloats?clientId=5FAE0707506C43BAB8B8C9F554586895577B22880B834423A473E797607EFCF6&skipBy=0&fpid=kljadlkcjasd898979
         
         clientId=5FAE0707506C43BAB8B8C9F554586895577B22880B834423A473E797607EFCF6&skipBy=0&fpid=kljadlkcjasd898979
        */
        //print(parameters)
        Alamofire.request(.GET,"https://api.withfloats.com/Discover/v2/floatingPoint/bizFloats?", parameters: parameters)
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
