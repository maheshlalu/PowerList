//
//  AppDelegate.swift
//  CoupCon
//
//  Created by apple on 13/10/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit
import CoreData
import FBSDKCoreKit
import Firebase
import FirebaseInstanceID
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate ,SWRevealViewControllerDelegate, GIDSignInDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = UIColor.whiteColor()
        navigationBarAppearace.barTintColor = CXAppConfig.sharedInstance.getAppTheamColor()
        
        let myAttributeTxtColor = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        let myAttribute = [ NSFontAttributeName: UIFont(name: "Roboto-Regular", size: 18.0)!]
        navigationBarAppearace.titleTextAttributes = myAttribute
        navigationBarAppearace.titleTextAttributes = myAttributeTxtColor
        
        
        self.configure()
        applicationNavigationFlow()
        self.setUpMagicalDB()
        
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        GIDSignIn.sharedInstance().delegate = self
        //self.constructTheOfferReedemJson()
        registerForPushNotifications(application)
        // Override point for customization after application launch.
        // Use Firebase library to configure APIs
        FIRApp.configure()
        

        return true
    }
    
    func application(application: UIApplication) {
       
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()

      
    }
    
    func registerForPushNotifications(application: UIApplication) {
        let notificationSettings = UIUserNotificationSettings(
            forTypes: [.Badge, .Sound, .Alert], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
    }

    
    func showAlertView(message:String, status:Int) {
        let alert = UIAlertController(title:message, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            
            if status == 100 {
                
            }else{
                
            }
        }
        alert.addAction(okAction)
        self.window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)

    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != .None {
            application.registerForRemoteNotifications()
        }
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
        var tokenString = ""
        
        for i in 0..<deviceToken.length {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        //Tricky line
        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.Unknown)
        print("Device Token:", tokenString)
    }
    
   
    
    func constructTheOfferReedemJson(){
        /*
         json={"list"":[{"ProductName":"Tabla","ProductDescription":"description","ProductImage":"https://s3-ap-southeast-1.amazonaws.com/storeongocontent/jobs/jobFldAttachments/20217_1477488244540.png","OfferName":"25 off on lunch","ProductId":"196429","OfferId":"9876543210","MacId":"102716-BHJAFCFH"}]}&dt=CAMPAIGNS&category=Notifications&userId=20217&consumerEmail=cxsample@gmail.com
         
         */
        let jsonDic : NSMutableDictionary = NSMutableDictionary()
        jsonDic.setObject("Club Republic", forKey: "ProductName")
        //jsonDic.setObject("23", forKey: "ProductDescription")
        jsonDic.setObject("https://s3-ap-southeast-1.amazonaws.com/storeongocontent/jobs/jobFldAttachments/20217_1477388128490.jpg", forKey: "ProductImage")
        jsonDic.setObject("10% off on total bill", forKey: "OfferName")
        jsonDic.setObject("196243", forKey: "ProductId")
        jsonDic.setObject("itemcode_5", forKey: "OfferId")
        jsonDic.setObject(CXAppConfig.sharedInstance.getTheUserData().macId, forKey: "MacId")
        
        let jsonListArray : NSMutableArray = NSMutableArray()
        jsonListArray.addObject(jsonDic)
        
        let listDic : NSDictionary = NSDictionary(object: jsonListArray, forKey: "list")
        print(listDic)
        
        var jsonData : NSData = NSData()
        do {
            jsonData = try NSJSONSerialization.dataWithJSONObject(listDic, options: NSJSONWritingOptions.PrettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
        } catch let error as NSError {
            print(error)
        }
        let jsonStringFormat = String(data: jsonData, encoding: NSUTF8StringEncoding)
        
        print(jsonStringFormat)
        
        
        
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getPlaceOrderUrl(), parameters: ["type":"RedeemHistory","json":jsonStringFormat!,"dt":"CAMPAIGNS","category":"Notifications","userId":CXAppConfig.sharedInstance.getAppMallID(),"consumerEmail":CXAppConfig.sharedInstance.getTheUserData().userEmail]) { (responseDict) in
            print(responseDict)
            let string = responseDict.valueForKeyPath("myHashMap.status")
            print(string)
        }
        
    }
    
    
    
  
    
    func applicationNavigationFlow(){
        let userId = CXAppConfig.sharedInstance.getUserID()
        print(userId)
        if userId == "" {
            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let exampleViewController: CXSigninViewController = mainStoryboard.instantiateViewControllerWithIdentifier("CXSigninViewController") as! CXSigninViewController
            let navCntl : UINavigationController = UINavigationController(rootViewController: exampleViewController)
            self.window?.rootViewController = navCntl
            self.window?.makeKeyAndVisible()
            
        }else{
            self.setUpSidePanl()
            
        }
        
    }
    
    
    func updateTheMobileNumber(){
        //http://storeongo.com:8081/MobileAPIs/saveConsumerProperty?ownerId=20217&consumerEmail=yernagulamahesh@gmail.com&propName=mobileNo&propValue=8096380038
        
        
    }
    
    func setUpSidePanl(){
        
        let wFrame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height)
        self.window = UIWindow.init(frame: wFrame)
    
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let homeView = storyBoard.instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
        let menuVC = storyBoard.instantiateViewControllerWithIdentifier("LeftViewController") as! LeftViewController
        
        let menuVCNav = UINavigationController(rootViewController: menuVC)
        menuVCNav.navigationBarHidden = true
        
        let navHome = UINavigationController(rootViewController: homeView)
        navHome.navigationBarHidden = true
        
        let revealVC = SWRevealViewController(rearViewController: menuVCNav, frontViewController: navHome)
        revealVC.delegate = self
        self.window?.rootViewController = revealVC
        self.window?.makeKeyAndVisible()
        
        
        //        let drawer : ICSDrawerController = ICSDrawerController(leftViewController: menuVC, centerViewController: homeView)
        //        self.window?.rootViewController = drawer
        //        self.window?.makeKeyAndVisible()
        
    }
    
    // MARK: - Core Data stack
    
    func setUpMagicalDB() {
        //MagicalRecord.setupCoreDataStackWithStoreNamed("Silly_Monks")
        NSPersistentStoreCoordinator.MR_setDefaultStoreCoordinator(persistentStoreCoordinator)
        NSManagedObjectContext.MR_initializeDefaultContextWithCoordinator(persistentStoreCoordinator)
    }
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()
        
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        let callBack:Bool
        // print("***************************url Schemaaa:", url.scheme);
        
        if url.scheme == "fb1256046541124360" {
            callBack = FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
        } else {
            callBack =  GIDSignIn.sharedInstance().handleURL(url, sourceApplication: sourceApplication, annotation: annotation)
        }
        
        return callBack
    }
    
    //MARK: - Google Sign in
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        if (error == nil) {
            var firstName = ""
            var lastName = ""
            // let userId = user.userID
            var gender = ""
            var profilePic = ""
            var email = ""
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            let url = NSURL(string:  "https://www.googleapis.com/oauth2/v3/userinfo?access_token=\(user.authentication.accessToken)")
            let session = NSURLSession.sharedSession()
            session.dataTaskWithURL(url!) {(data, response, error) -> Void in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                do {
                    let userData = try NSJSONSerialization.JSONObjectWithData(data!, options:[]) as? [String:AnyObject]
                    
                    let orgID:String! = CXAppConfig.sharedInstance.getAppMallID()
                    firstName = userData!["given_name"] as! String
                    lastName = userData!["family_name"] as! String
                    //gender = userData!["gender"] as! String
                    profilePic = userData!["picture"] as! String
                    email = userData!["email"] as! String
                    
                    print("\(email)\(firstName)\(lastName)\(gender)\(profilePic)\(orgID)")
                    
                    NSNotificationCenter.defaultCenter().postNotificationName("GoogleSignUp", object: userData)
                    
                } catch {
                    NSLog("Account Information could not be loaded")
                }
                
                }.resume()
        }
            
        else {
            //Login Failed
            NSLog("login failed")
            
        }
    }
    
    
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
                withError error: NSError!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "CX.Coupcon.CoupCon" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        print(urls)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("CoupCon", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    //MARK: Loader configuration
    
    func configure (){
        var config : LoadingView.Config = LoadingView.Config()
        config.size = 100
        config.backgroundColor = UIColor.blackColor() //UIColor(red:0.03, green:0.82, blue:0.7, alpha:1)
        config.spinnerColor = UIColor.whiteColor()//UIColor(red:0.88, green:0.26, blue:0.18, alpha:1)
        config.titleTextColor = UIColor.whiteColor()//UIColor(red:0.88, green:0.26, blue:0.18, alpha:1)
        config.spinnerLineWidth = 2.0
        config.foregroundColor = UIColor.blackColor()
        config.foregroundAlpha = 0.5
        LoadingView.setConfig(config)
    }
}


//MARK: Version


func checkVersion(){
    
    let nsObject: AnyObject? = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"]
    
    //Then just cast the object as a String, but be careful, you may want to double check for nil
    let version = nsObject as! String
    
    
    
}

//http://storeongo.com:8081/Services/getMasters?type=Consumer%20Codes&mallId=20217&keyWord=28DIF9


