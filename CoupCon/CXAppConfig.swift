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
    
    
    
    
    
}
