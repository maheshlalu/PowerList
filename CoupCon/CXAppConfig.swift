//
//  CXAppConfig.swift
//  NowFloats
//
//  Created by Mahesh Y on 8/22/16.
//  Copyright © 2016 CX. All rights reserved.
//

import Foundation

class CXAppConfig {
    
    /// the singleton
    static let sharedInstance = CXAppConfig()
    
    // This prevents others from using the default '()' initializer for this class.
    private init() {
        loadConfig()
    }
    
    /// the config dictionary
    var config: NSDictionary?
    
    /**
     Load config from Config.plist
     */
    func loadConfig() {
        if let path = NSBundle.mainBundle().pathForResource("CXProjectConfiguration", ofType: "plist") {
            config = NSDictionary(contentsOfFile: path)
            
            print(config)
        }
    }
    
    /**
     Get base url from Config.plist
     
     - Returns: the base url string from Config.plist      
     */
    func getBaseUrl() -> String {
        return config!.valueForKey("BaseUrl") as! String
    }
    //getMaster
    func getMasterUrl() -> String {
        return config!.valueForKey("getMaster") as! String
    }
    
    func getSignInUrl() -> String {
        return config!.valueForKey("signInMethod") as! String
    }
    
    func getSignUpInUrl() -> String {
        return config!.valueForKey("signUpMethod") as! String
    }
    //    //forgotPassordMethod
    func getForgotPassordUrl() -> String {
        return config!.valueForKey("forgotPassordMethod") as! String
    }
    
    func getPlaceOrderUrl() -> String{
        return config!.valueForKey("placeOrder") as! String
    }
    
    
    //updateProfile
    
    func getupdateProfileUrl() -> String {
        return config!.valueForKey("updateProfile") as! String
    }
    //photoUpload
    func getphotoUploadUrl() -> String {
        return config!.valueForKey("photoUpload") as! String
    }
    //getMallID
    func getAppMallID() -> String {
        return config!.valueForKey("MALL_ID") as! String
    }

    func productName() -> String{
        return config!.valueForKey("PRODUCT_NAME") as! String
    }
    func getSidePanelList() -> NSArray{
        
        return config!.valueForKey("SidePanelList") as! NSArray
    }
    
    // getOTPAPIs
    
    func getVarifyingEmailOTP() -> String{
        return config!.valueForKey("varifyingEmailForOTP") as! String
    }
    
    func getSendingOTP() -> String{
        return config!.valueForKey("sendingOTP") as! String
    }
    func getComparingOTP() -> String{
        return config!.valueForKey("comparingOTP") as! String
    }


    func getAppTheamColor() -> UIColor {
        
        let appTheamColorArr : NSArray = config!.valueForKey("AppTheamColor") as! NSArray
        let red : Double = (appTheamColorArr.objectAtIndex(0) as! NSString).doubleValue
        let green : Double = (appTheamColorArr.objectAtIndex(1) as! NSString).doubleValue
        let blue : Double = (appTheamColorArr.objectAtIndex(2) as! NSString).doubleValue
        return UIColor(
            red: CGFloat(red / 255.0),
            green: CGFloat(green / 255.0),
            blue: CGFloat(blue / 255.0),
            alpha: CGFloat(1.0)
        )
    }
    
    func getAppBGColor() -> UIColor {
        
        let appTheamColorArr : NSArray = config!.valueForKey("AppBgColr") as! NSArray
        let red : Double = (appTheamColorArr.objectAtIndex(0) as! NSString).doubleValue
        let green : Double = (appTheamColorArr.objectAtIndex(1) as! NSString).doubleValue
        let blue : Double = (appTheamColorArr.objectAtIndex(2) as! NSString).doubleValue
        return UIColor(
            red: CGFloat(red / 255.0),
            green: CGFloat(green / 255.0),
            blue: CGFloat(blue / 255.0),
            alpha: CGFloat(1.0)
        )
    }
    
    
    
    
    func mainScreenSize() -> CGSize {
        return UIScreen.mainScreen().bounds.size
    }
    
    //MARK:FONTS
    func appSmallFont() -> UIFont{
        
        return UIFont(name: config!.valueForKey("APPFONT_NAME_REGULAR") as! String, size: CGFloat((config!.valueForKey("APPFONT_SMALL") as?NSNumber)!))!
        
    }
    
    func appMediumFont() -> UIFont{
        
        return UIFont(name: config!.valueForKey("APPFONT_NAME_REGULAR") as! String, size: CGFloat((config!.valueForKey("APPFONT_MEDIUM") as?NSNumber)!))!
    }
    

    func appLargeFont() -> UIFont{
        
        return UIFont(name: config!.valueForKey("APPFONT_NAME_REGULAR") as! String, size: CGFloat((config!.valueForKey("APPFONT_LARGE") as?NSNumber)!))!

    }
    
    //MARK:Pager Enable
    
    func ispagerEnable() -> Bool {
       return config!.valueForKey("ISPagerEnable") as! Bool
    }
    
    
    static func resultString(input: AnyObject) -> String{
        if let value: AnyObject = input {
            var reqType : String!
            switch value {
            case let i as NSNumber:
                reqType = "\(i)"
            case let s as NSString:
                reqType = "\(s)"
            case let a as NSArray:
                reqType = "\(a.objectAtIndex(0))"
            default:
                reqType = "Invalid Format"
            }
            return reqType
        }
        return ""
    }
    
    //MARK: User ID Saving
    func saveUserID(userID:String){
        NSUserDefaults.standardUserDefaults().setObject(userID, forKey: "USERID")
    }
    
    func getUserID() ->String{
        
        if(NSUserDefaults.standardUserDefaults().objectForKey("USERID") == nil)
        {
            print("NULL")
            return ""
            
        }else{
            
            return NSUserDefaults.standardUserDefaults().valueForKey("USERID") as! String
        }
        
    }
    
    //MARK: User ID Saving
    func saveEmail(userID:String){
        NSUserDefaults.standardUserDefaults().setObject(userID, forKey: "EMAIL")
    }
    
    func getEmail() ->String{
        
        if(NSUserDefaults.standardUserDefaults().objectForKey("EMAIL") == nil)
        {
            print("NULL")
            return ""
            
        }else{
            
            return NSUserDefaults.standardUserDefaults().valueForKey("EMAIL") as! String
        }
        
    }
    
    
    //MARK: User ID Saving
    func savePhoneNumber(userID:String){
        NSUserDefaults.standardUserDefaults().setObject(userID, forKey: "PHONE")
    }
    
    func getPhoneNumber() ->String{
        
        if(NSUserDefaults.standardUserDefaults().objectForKey("PHONE") == nil)
        {
            print("NULL")
            return ""
            
        }else{
            
            return NSUserDefaults.standardUserDefaults().valueForKey("PHONE") as! String
        }
        
    }
    
    
    //MARK: User MacJob Id Saving
    func saveMacJobID(macJobId:String){
        NSUserDefaults.standardUserDefaults().setObject(macJobId, forKey: "MAC_JOB_ID")
    }
    
    func getMacJobID() ->String{
        
        if(NSUserDefaults.standardUserDefaults().objectForKey("MAC_JOB_ID") == nil)
        {
            print("NULL")
            return ""
            
        }else{
            
            return NSUserDefaults.standardUserDefaults().valueForKey("MAC_JOB_ID") as! String
        }
        
    }
    
    func setRedeemDictionary(dictionary:NSMutableDictionary){
        
        NSUserDefaults.standardUserDefaults().setObject(dictionary, forKey: "Redeem_Dict")
        
    }
    
    
    func getRedeemDictionary() -> NSMutableDictionary {
        
        let redeemDict :NSMutableDictionary = NSUserDefaults.standardUserDefaults().valueForKey("Redeem_Dict") as! NSMutableDictionary
        return redeemDict
        
    }
    
    func getTheUserData() ->(userID:String,macId:String,macIdJobId:String,userEmail:String){
        
        let appdata:NSArray = UserProfile.MR_findAll() as NSArray
        let userProfileData:UserProfile = appdata.lastObject as! UserProfile
        print(userProfileData.emailId)
        return(userID:userProfileData.userId!,macId:userProfileData.macId!,macIdJobId:userProfileData.macIdJobId!,userProfileData.emailId!)
    }
    
    func getTheUserDetails() -> UserProfile{
        
        let appdata:NSArray = UserProfile.MR_findAll() as NSArray
        let userProfileData:UserProfile = appdata.lastObject as! UserProfile
        return userProfileData
    }
    
    func getExpiresDate(mode:NSInteger) -> NSString{
        
        let currDate = NSDate()
        var endDate = NSDate()
        let dateComponent = NSDateComponents()
        let cal = NSCalendar.currentCalendar()
        print(currDate)
        
        switch mode {
        case 0:
            
            dateComponent.month = 1
            endDate = cal.dateByAddingComponents(dateComponent, toDate: currDate, options: NSCalendarOptions(rawValue: 0))!
            
        case 1:
            
            dateComponent.month = 6
            endDate = cal.dateByAddingComponents(dateComponent, toDate: currDate, options: NSCalendarOptions(rawValue: 0))!
            
        case 2:
            
            dateComponent.year = 1
            endDate = cal.dateByAddingComponents(dateComponent, toDate: currDate, options: NSCalendarOptions(rawValue: 0))!
            
        default:
            print("No matches found")
        }
        
        let myFormatter = NSDateFormatter()
        myFormatter.dateFormat = "dd-MM-yyyy"
        let expiryDate = myFormatter.stringFromDate(endDate)
        return expiryDate
        
    }
    
}
