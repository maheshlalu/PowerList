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
import MagicalRecord
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
        
        
         if CXAppConfig.sharedInstance.isReachability() == true{
            
            print(CXAppConfig.sharedInstance.getBaseUrl() + CXAppConfig.sharedInstance.getMasterUrl())
            print(parameters)
            NSURLCache.sharedURLCache().removeAllCachedResponses()
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
        if CXAppConfig.sharedInstance.isReachability() == true{
        print(urlstring)
        print(parameters)
        LoadingView.show("Loading...", animated: true)
        Alamofire.request(.POST,urlstring, parameters: parameters)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .Success:
                   // print("Validation Successful\(response.result.value)")
                    completion(responseDict: (response.result.value as? NSDictionary)!)
                    LoadingView.hide()
                    break
                case .Failure(let error):
                    print(error)
                    LoadingView.hide()
                }
        }
        }else{
            print("No Internet Connectivity")
        
        }
        
    }
    
    public func imageUpload(imageData:NSData,completion:(Response:NSDictionary) -> Void){
        
        
        if CXAppConfig.sharedInstance.isReachability() == true {

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
        
        if CXAppConfig.sharedInstance.isReachability() == true {
            
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
    
    
    func productAddedToFavorites(jobID:String,likeStatus:String,product:NSDictionary,completion:(responseDict:NSDictionary) -> Void){
       // "http://sillymonksapp.com:8081/Services/saveOrUpdateSocialActivity?orgId=3&userId="+userId+"&jobId="+jobId+"&noOfLikes=1"
        self.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl() + CXAppConfig.sharedInstance.getProductLikeMethod(), parameters: ["orgId":CXAppConfig.sharedInstance.getAppMallID(),"userId":CXAppConfig.sharedInstance.getUserID(),"jobId":jobID,"noOfLikes":likeStatus]) { (responseDict) in
            print(responseDict)
            if likeStatus == "1"{
                self.productAddedToFavouritesList(product, isAdded: true)
            }else{
                self.productAddedToFavouritesList(product, isAdded: false)
            }
            completion(responseDict: responseDict)
        }
 
    }
    
    
    func productAddedToFavouritesList(product:NSDictionary,isAdded:Bool){
        
        if isAdded && !self.productIsAddedinList(CXAppConfig.resultString(product.valueForKey("id")!)){
            //Added to list
            MagicalRecord.saveWithBlock({ (localContext) in
                    let enProduct = CX_Stores.MR_createInContext(localContext) as! CX_Stores
                    enProduct.storeID = CXAppConfig.resultString(product.valueForKey("id")!)
                    let jsonString = self.convertDictionayToString(product)
                    enProduct.json = jsonString as String
            }) { (success, error) in
                if success == true {
                    
                } else {
                    print("Error\(error)")
                }
            }

        }else{
            let predicate: NSPredicate = NSPredicate(format: "storeID == \(CXAppConfig.resultString(product.valueForKey("id")!))")
            CX_Stores.MR_deleteAllMatchingPredicate(predicate)
            //Remove from list
            
        }
    }
    
    func productIsAddedinList(productID:String)->Bool{
     
        let predicate: NSPredicate = NSPredicate(format: "storeID == \(productID)")
        let fetchRequest = NSFetchRequest(entityName: "CX_Stores") //
        fetchRequest.predicate = predicate
        let productCatList :NSArray = CX_Stores.MR_executeFetchRequest(fetchRequest)
        let list : NSMutableArray = NSMutableArray(array: productCatList)
        if list.count == 0 {
            //MR_deleteAllMatchingPredicate
            return false
        }
        return true
    }
    
    
    func getTheLikesFromServer(){
        if (CX_Stores.MR_findAll().count != 0) {
            return
        }

        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile("\(CXAppConfig.sharedInstance.getBaseUrl())Services/favourites?", parameters: ["orgId":CXAppConfig.sharedInstance.getAppMallID(),"userId":CXAppConfig.sharedInstance.getUserID()]) { (responseDict) in
            //This project i am using cxstores entity for saving favourites
            //print(responseDict)
            let products:NSArray = NSArray(array: (responseDict.valueForKey("jobs") as? NSArray)!)
            MagicalRecord.saveWithBlock({ (localContext) in
                for prod in products {
                    let enProduct = CX_Stores.MR_createInContext(localContext) as! CX_Stores
                    enProduct.storeID = CXAppConfig.resultString(prod.valueForKey("id")!)
                    let jsonString = self.convertDictionayToString(prod as! NSDictionary)
                    enProduct.json = jsonString as String
                }
                
            }) { (success, error) in
                if success == true {
                   
                } else {
                    print("Error\(error)")
                }
            }
            
        }
    }
    
    /*
     
     @NSManaged var createdById: String?
     @NSManaged var favourite: String?
     @NSManaged var itemCode: String?
     @NSManaged var json: String?
     @NSManaged var name: String?
     @NSManaged var storeID: String?
     @NSManaged var type: String?

     */
    
}
