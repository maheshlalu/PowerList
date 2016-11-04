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
        
         if Reachability.isConnectedToNetwork() == true{
            
            print(CXAppConfig.sharedInstance.getBaseUrl() + CXAppConfig.sharedInstance.getMasterUrl())
            print(parameters)
            //NSURLCache.sharedURLCache().removeAllCachedResponses()
            Alamofire.Manager.sharedInstance.session.configuration.requestCachePolicy = .ReturnCacheDataDontLoad
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
            
            print("No Internet Connectivity")
            //UIApplication.sharedApplication().openURL(NSURL(string:"prefs:root=General")!)
            UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
            LoadingView.hide()
        }
        
    }
    
    public func synchDataToServerAndServerToMoblile(urlstring:String, parameters:[String: AnyObject]? = nil ,completion:(responseDict:NSDictionary) -> Void){
    
        
        if Reachability.isConnectedToNetwork() == true{
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
        }else{
            print("No Internet Connectivity")
        
        }
        
    }
    
    public func imageUpload(imageData:NSData,completion:(Response:NSDictionary) -> Void){
        
        
        if Reachability.isConnectedToNetwork() == true {

            let mutableRequest : AFHTTPRequestSerializer = AFHTTPRequestSerializer()
            let request1 : NSMutableURLRequest =    mutableRequest.multipartFormRequestWithMethod("POST", URLString: CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getphotoUploadUrl(), parameters: ["refFileName": self.generateBoundaryString()], constructingBodyWithBlock: { (formatData:AFMultipartFormData) in
                formatData.appendPartWithFileData(imageData, name: "srcFile", fileName: "uploadedFile.jpg", mimeType: "image/jpeg")
                }, error: nil)
            
            let session = NSURLSession.sharedSession()
            
            let task = session.dataTaskWithRequest(request1) {
                (
                let data, let response, let error) in
                
                guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                    print("error")
                    return
                }
                let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                let myDic = self.convertStringToDictionary(dataString! as String)
                completion(Response:myDic)
                
            }
            
            task.resume()
            
            
        } else {
            print("Internet connection FAILED")
        }
        
  
        
        
        //        Alamofire.upload(
        //            .POST,
        //            CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getphotoUploadUrl(),
        //            headers: ["Content-Type":"application/json"],
        //            multipartFormData: { multipartFormData in
        //                multipartFormData.appendBodyPart(data: imageData, name: "srcFile",
        //                    fileName: "uploadedFile.jpg", mimeType: "")
        //            },
        //            encodingCompletion: { encodingResult in
        //                print(encodingResult)
        //                print("result")
        //            }
        //        )
    }
    
    func generateBoundaryString() -> String
    {
        return "\(NSUUID().UUIDString)"
    }
    
    public func getTheUpdatesFromServer(parameters:[String: AnyObject]? = nil ,completion:(responseDict:NSDictionary) -> Void){
        
       /* https://api.withfloats.com/Discover/v2/floatingPoint/bizFloats?clientId=5FAE0707506C43BAB8B8C9F554586895577B22880B834423A473E797607EFCF6&skipBy=0&fpid=kljadlkcjasd898979
         
         clientId=5FAE0707506C43BAB8B8C9F554586895577B22880B834423A473E797607EFCF6&skipBy=0&fpid=kljadlkcjasd898979
        */
        //print(parameters)
        
        if Reachability.isConnectedToNetwork() == true {
            
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
        } else {
            print("Internet connection FAILED")
        }
        

        
        
    }

    
    
    func convertDictionayToString(dictionary:NSDictionary) -> NSString {
        var dataString: String!
        do {
            let jsonData = try NSJSONSerialization.dataWithJSONObject(dictionary, options: NSJSONWritingOptions.PrettyPrinted)
            //print("JSON data is \(jsonData)")
            dataString = String(data: jsonData, encoding: NSUTF8StringEncoding)
            //print("Converted JSON string is \(dataString)")
            // here "jsonData" is the dictionary encoded in JSON data
        } catch let error as NSError {
            dataString = ""
            print(error)
        }
        return dataString
    }
    
    func convertStringToDictionary(string:String) -> NSDictionary {
        var jsonDict : NSDictionary = NSDictionary()
        let data = string.dataUsingEncoding(NSUTF8StringEncoding)
        do {
            jsonDict = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers ) as! NSDictionary            // CXDBSettings.sharedInstance.saveAllMallsInDB((jsonData.valueForKey("orgs") as? NSArray)!)
        } catch {
            //print("Error in parsing")
        }
        return jsonDict
    }
    
    
}
