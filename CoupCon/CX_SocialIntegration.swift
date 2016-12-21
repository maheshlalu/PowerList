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
    func applicationRegisterWithFaceBook(userDataDic : NSDictionary,completion:(resPonce:Bool) -> Void) {
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
                let userPic : String = (userDataDic.valueForKeyPath("picture.data.url") as? String)!
                CXAppConfig.sharedInstance.saveEmail(email)
                //picture,data,url
                let userRegisterDic: NSDictionary = NSDictionary(objects: [CXAppConfig.sharedInstance.getAppMallID(),email,"DEVICES",fbID,strFirstName,strLastName,gender,userPic,"true"],
                                                                 forKeys: ["orgId","userEmailId","dt","password","firstName","lastName","gender","filePath","isLoginWithFB"])
                self.registerWithSocialNewtWokrk(userRegisterDic, completion: { (responseDict) in
                    completion(resPonce: true)

                })
                //self.profileImageStr = (responseDict.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as? String)!
                print("Welcome,\(email) \(strFirstName) \(strLastName) \(gender) ")
            }else{
                // get the details from server using below url
                CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getSignInUrl(), parameters: ["orgId":CXAppConfig.sharedInstance.getAppMallID(),"email":email,"dt":"DEVICES","isLoginWithFB":"true"]) { (responseDict) in
                    //"password":""
                    self.saveUserDeatils(responseDict)
                    completion(resPonce: true)
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
    
    
    func registerWithSocialNewtWokrk(registerDic:NSDictionary,completion:(responseDict:NSDictionary) -> Void){
        
        
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getSignUpInUrl(), parameters: registerDic as? [String : AnyObject]) { (responseDict) in
            self.saveUserDeatils(responseDict)
            completion(responseDict: responseDict)
           
        }
        
    }
    
    func userLogin(loginDic:NSDictionary,completion:(responseDict:NSDictionary) -> Void){
        print(loginDic)
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getSignInUrl(), parameters: ["dt":"DEVICES","orgId":CXAppConfig.sharedInstance.getAppMallID(),"email":loginDic.valueForKey("email")!,"password":loginDic.valueForKey("password")!]) { (responseDict) in
            //"password":""
            
            self.saveUserDeatils(responseDict)
            completion(responseDict: responseDict)
            LoadingView.hide()
        }
//        
//        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getSignInUrl(), parameters: loginDic as? [String : AnyObject]) { (responseDict) in
//            
//            if responseDict.valueForKey("status") as? String == "1"{
//                self.saveUserDeatils(responseDict)
//                print(responseDict)
//            }else{
//                
//            }
//        }
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
            
            let status: Int = Int(userData.valueForKey("status") as! String)!
            
            if status == 1{
                enProduct?.userId = CXAppConfig.resultString(userData.valueForKey("UserId")!)
                enProduct?.emailId = userData.valueForKey("emailId") as? String
                enProduct?.firstName = userData.valueForKey("firstName") as? String
                enProduct?.lastName = userData.valueForKey("lastName") as? String
                if enProduct?.userPic == nil{
                    enProduct?.userPic =  userData.objectForKey("userImagePath") as? String
                }
                enProduct?.macId = userData.valueForKey("macId") as? String
                enProduct?.macIdJobId = CXAppConfig.resultString(userData.valueForKey("macIdJobId")!)
                CXAppConfig.sharedInstance.saveUserID((enProduct?.userId)!)
                CXAppConfig.sharedInstance.saveMacJobID((enProduct?.macIdJobId)!)
                CXAppConfig.sharedInstance.saveEmail((enProduct?.emailId)!)
            
                self.getTheUserDetailsFromMacIdInfo()
            }
        }) { (success, error) in
            if success == true {
                //                if let delegate = self.delegate {
                //                    delegate.didFinishProducts(productCatName)
                //                }
            } else {
            }
        }
        
    }
    
    
    func updateTheSaveConsumerProperty(parameters:NSDictionary,completion:(resPonce:Bool) -> Void){
        LoadingView.show("Loading", animated: true)
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile("\(CXAppConfig.sharedInstance.getBaseUrl())MobileAPIs/updateMultipleProperties?", parameters: parameters as? [String : AnyObject]) { (responseDict) in
            print(responseDict)
            completion(resPonce: true)
            LoadingView.hide()
        }
        
        //http://storeongo.com:8081/MobileAPIs/saveConsumerProperty?ownerId=20217&consumerEmail=yernagulamahesh@gmail.com&propName=mobileNo&propValue=8096380038
        
        

    }
    //MARK: Google Plus
    
    func applicationRegisterWithGooglePlus(userDataDic : NSDictionary,completion:(resPonce:Bool) -> Void) {
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
            print(responseDict)
            if !self.checkTheUserRegisterWithApp(email, macidInfoResultDic: responseDict).isRegistred {
                //Register with app
                let strFirstName: String =  userDataDic["given_name"] as! String

                let strLastName: String = userDataDic["family_name"] as! String
                //let gender: String =  userDataDic["gender"] as! String
                let email: String = (userDataDic.objectForKey("email") as? String)!
                let GoogleID : String = (userDataDic.objectForKey("sub") as? String)!
                let userPic : String = (userDataDic.objectForKey("picture") as? String)!
                CXAppConfig.sharedInstance.saveEmail(email)
                //picture,data,url
                
                let userRegisterDic: NSDictionary = NSDictionary(objects: [CXAppConfig.sharedInstance.getAppMallID(),email,"DEVICES",GoogleID,strFirstName,strLastName,"",userPic,"true",userPic],
                                                                 forKeys: ["orgId","userEmailId","dt","password","firstName","lastName","gender","filePath","isLoginWithFB","userImagePath"])
                print(userRegisterDic)
                self.registerWithSocialNewtWokrk(userRegisterDic, completion: { (responseDict) in
                    completion(resPonce: true)

                })                //self.profileImageStr = (responseDict.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as? String)!
                print("Welcome,\(email) \(strFirstName) \(strLastName)  ")
            }else{
                // get the details from server using below url
                
                CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getSignInUrl(), parameters: ["orgId":CXAppConfig.sharedInstance.getAppMallID(),"email":email,"dt":"DEVICES","isLoginWithFB":"true"]) { (responseDict) in
                    //"password":""
                    self.saveUserDeatils(responseDict)
                    completion(resPonce: true)

                }
                //http://localhost:8081/MobileAPIs/loginConsumerForOrg?email=cxsample@gmail.com&orgId=530&dt=DEVICES&isLoginWithFB=true
            }
            
        }
        
        
    }
    
    func chekTheEmailForSendingTheOTP(completion:(resPonce:Bool) -> Void){
        
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getVarifyingEmailOTP(), parameters: ["ownerId":CXAppConfig.sharedInstance.getAppMallID(),"consumerEmail":CXAppConfig.sharedInstance.getEmail()]) { (responseDict) in
            LoadingView.hide()
            print(responseDict)
            let status: Int = Int(responseDict.valueForKey("status") as! String)!
            let message = responseDict.valueForKey("message") as! String
            if status == 1{
                // If Status is 1 then the user email id is already regesterd with email.Can't able to send OTP. Which means give another email.
               // self.showAlertView(message, status: 0)
                completion(resPonce: false)
                return
            }else{
                //Sending the OTP to given mobile number (status is -1 or 0). Eligible to send OTP.
                //LoadingView.show("Loading...", animated: true)
              //  self.sendingOTPForGivenNumber()
                completion(resPonce: true)
                LoadingView.hide()
            }
        }
    }
    
    func sendingOTPForGivenNumber(mobileNumber:String,completion:(resPonce:Bool) -> Void){
        
        //http://storeongo.com:8081/MobileAPIs/sendCoupoconSMS? ownerId=530& consumerEmail=cxsample@gmail.com& mobile=919581552229
        
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getSendingOTP(), parameters: ["ownerId":CXAppConfig.sharedInstance.getAppMallID(),"consumerEmail":CXAppConfig.sharedInstance.getEmail(),"mobile":mobileNumber]) { (responseDict) in
            // sleep(1000)
            print(responseDict)
            let status: Int = Int(responseDict.valueForKey("status") as! String)!
            
            if status == 1{
                // OTP SENT
                NSUserDefaults.standardUserDefaults().setObject(responseDict.valueForKey("OTP"), forKey: "OTP")
                //self.showAlertView("OTP sent Successfully!!!", status: 100)
                //After sending the OTP to given number, pushing to OTPViewController
                completion(resPonce: true)
            }else{
                // OTP NOT SENT
               // self.showAlertView("Something Went Wrong!! Pleace check Email!!!", status: 0)
            }
            
        }
        
        
    }
    
    func getTheUserDetailsFromMacIdInfo(){
        
        
        CXDataService.sharedInstance.getTheAppDataFromServer(["type" : "macidinfo","mallId" : CXAppConfig.sharedInstance.getAppMallID(),"keyWord":CXAppConfig.sharedInstance.getEmail()]) { (responseDict) in
           // let email: String = (userDataDic.objectForKey("email") as? String)!
            
           let array   =  NSMutableArray(array: (responseDict.valueForKey("jobs") as? NSArray!)!)
            CXAppConfig.sharedInstance.saveTheUserMacIDinfoData((array.lastObject as? NSDictionary)!)
            
        }
        
    }
    
}
