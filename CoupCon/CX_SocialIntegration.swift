//
//  CX_SocialIntegration.swift
//  CoupCon
//
//  Created by apple on 20/10/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit
import CoreData
import MagicalRecord
private var _SingletonSharedInstance:CX_SocialIntegration! = CX_SocialIntegration()

class CX_SocialIntegration: NSObject {
    
    
    class var sharedInstance : CX_SocialIntegration {
        return _SingletonSharedInstance
    }
    
    private override init() {
        
    }
    
    //MARK: FACEBOOK
    func applicationRegisterWithFaceBook(userDataDic : NSDictionary) {
        //Before register with facebook check The MACID info API call
        // http://storeongo.com:8081/Services/getMasters?type=macidinfo&mallId=17018
        
        CXDataService.sharedInstance.getTheAppDataFromServer(["type" : "macidinfo","mallId" : CXAppConfig.sharedInstance.getAppMallID()]) { (responseDict) in
            let email: String = (userDataDic.objectForKey("email") as? String)!
            
            if !self.checkTheUserRegisterWithApp(email, macidInfoResultDic: responseDict).isRegistred {
                //Register with app
                let strFirstName: String = (userDataDic.objectForKey("first_name") as? String)!
                let strLastName: String = (userDataDic.objectForKey("last_name") as? String)!
                let gender: String = (userDataDic.objectForKey("gender") as? String)!
                let email: String = (userDataDic.objectForKey("email") as? String)!
                let fbID : String = (userDataDic.objectForKey("id") as? String)!
                //picture,data,url
                let userRegisterDic: NSDictionary = NSDictionary(objects: [CXAppConfig.sharedInstance.getAppMallID(),email,"DEVICES",fbID,strFirstName,strLastName,gender,"","true"],
                                                                 forKeys: ["orgId","userEmailId","dt","password","firstName","lastName","gender","filePath","isLoginWithFB"])
                self.registerWithSocialNewtWokrk(userRegisterDic)
                //self.profileImageStr = (responseDict.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as? String)!
                print("Welcome,\(email) \(strFirstName) \(strLastName) \(gender) ")
            }else{
                // get the details from server using below url
                
                CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getSignInUrl(), parameters: ["orgId":CXAppConfig.sharedInstance.getAppMallID(),"email":email,"dt":"DEVICES","isLoginWithFB":"true"]) { (responseDict) in
                    //"password":""
                    self.saveUserDeatils(responseDict)
                }
                //http://localhost:8081/MobileAPIs/loginConsumerForOrg?email=cxsample@gmail.com&orgId=530&dt=DEVICES&isLoginWithFB=true
            }
            
        }
        
    }
    
    
    func checkTheUserRegisterWithApp(userEmail:String , macidInfoResultDic : NSDictionary) -> (isRegistred:Bool, userDic:NSDictionary){
        let resultArray : NSArray = NSArray(array: (macidInfoResultDic.valueForKey("jobs") as? NSArray)!)
        for mackIDInfoDic in resultArray {
            let email: String = (mackIDInfoDic.objectForKey("Email") as? String)!
            if  email == userEmail {
                return (true,mackIDInfoDic as! NSDictionary)
            }
        }
        return (false,NSDictionary())
    }
    
    
    func registerWithSocialNewtWokrk(registerDic:NSDictionary){
        
        
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getSignUpInUrl(), parameters: registerDic as? [String : AnyObject]) { (responseDict) in
            self.saveUserDeatils(responseDict)
            print(responseDict)
        }
        
    }
    
    
    func saveUserDetailsFromMacIDInfo(userData:NSDictionary){
        
        
        MagicalRecord.saveWithBlock({ (localContext) in
            let enProduct =  NSEntityDescription.insertNewObjectForEntityForName("UserProfile", inManagedObjectContext: localContext) as? UserProfile
            enProduct?.userId = CXAppConfig.resultString(userData.valueForKey("id")!)
            enProduct?.emailId = userData.valueForKey("Email") as? String
            enProduct?.firstName = userData.valueForKey("firstName") as? String
            enProduct?.lastName = userData.valueForKey("lastName") as? String
            enProduct?.userPic =  userData.objectForKey("Image") as? String
            enProduct?.macId = enProduct?.userId
            enProduct?.macIdJobId = ""
        }) { (success, error) in
            if success == true {
                
            } else {
            }
        }
        
        
        
        
    }
    
    func saveUserDeatils(userData:NSDictionary){
        
        MagicalRecord.saveWithBlock({ (localContext) in
            let enProduct =  NSEntityDescription.insertNewObjectForEntityForName("UserProfile", inManagedObjectContext: localContext) as? UserProfile
            print(userData)
            enProduct?.userId = CXAppConfig.resultString(userData.valueForKey("UserId")!)
            enProduct?.emailId = userData.valueForKey("emailId") as? String
            enProduct?.firstName = userData.valueForKey("firstName") as? String
            enProduct?.lastName = userData.valueForKey("lastName") as? String
            enProduct?.userPic =  userData.objectForKey("userImagePath") as? String
            enProduct?.macId = userData.valueForKey("macId") as? String
            enProduct?.macIdJobId = userData.valueForKey("macIdJobId") as? String
            CXAppConfig.sharedInstance.saveUserID((enProduct?.userId)! )

        }) { (success, error) in
            if success == true {
                //                if let delegate = self.delegate {
                //                    delegate.didFinishProducts(productCatName)
                //                }
            } else {
            }
        }
        
    }
    
    //MARK: Google Plus
    
    func applicationRegisterWithGooglePlus(userDataDic : NSDictionary) {
        print(userDataDic)
        /*
         {
         email = "yernagulamahesh@gmail.com";
         "email_verified" = 1;
         "family_name" = Yernagulamahesh;
         gender = male;
         "given_name" = Yernagulamahesh;
         locale = "en-GB";
         name = "Yernagulamahesh Yernagulamahesh";
         picture = "https://lh3.googleusercontent.com/-S368cTqik1s/AAAAAAAAAAI/AAAAAAAAAGE/F2SCGi21XKQ/photo.jpg";
         profile = "https://plus.google.com/114362920567871916688";
         sub = 114362920567871916688;
         }
         */
        
        CXDataService.sharedInstance.getTheAppDataFromServer(["type" : "macidinfo","mallId" : CXAppConfig.sharedInstance.getAppMallID()]) { (responseDict) in
            let email: String = (userDataDic.objectForKey("email") as? String)!
            
            if !self.checkTheUserRegisterWithApp(email, macidInfoResultDic: responseDict).isRegistred {
                //Register with app
                let strFirstName: String =  userDataDic["given_name"] as! String

                let strLastName: String = userDataDic["family_name"] as! String
                //let gender: String =  userDataDic["gender"] as! String
                let email: String = (userDataDic.objectForKey("email") as? String)!
                let GoogleID : String = (userDataDic.objectForKey("sub") as? String)!
                let userPic : String = (userDataDic.objectForKey("picture") as? String)!

                //picture,data,url
                
                let userRegisterDic: NSDictionary = NSDictionary(objects: [CXAppConfig.sharedInstance.getAppMallID(),email,"DEVICES",GoogleID,strFirstName,strLastName,"","","true",userPic],
                                                                 forKeys: ["orgId","userEmailId","dt","password","firstName","lastName","gender","filePath","isLoginWithFB","userImagePath"])
                self.registerWithSocialNewtWokrk(userRegisterDic)
                //self.profileImageStr = (responseDict.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as? String)!
                print("Welcome,\(email) \(strFirstName) \(strLastName)  ")
            }else{
                // get the details from server using below url
                
                CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getSignInUrl(), parameters: ["orgId":CXAppConfig.sharedInstance.getAppMallID(),"email":email,"dt":"DEVICES","isLoginWithFB":"true"]) { (responseDict) in
                    //"password":""
                    self.saveUserDeatils(responseDict)
                }
                //http://localhost:8081/MobileAPIs/loginConsumerForOrg?email=cxsample@gmail.com&orgId=530&dt=DEVICES&isLoginWithFB=true
            }
            
        }
        
        
    }
    
    
    
}
