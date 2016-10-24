//
//  OTPViewController.swift
//  CoupCon
//
//  Created by Manishi on 10/24/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit

class OTPViewController: UIViewController,SWRevealViewControllerDelegate {
    var window: UIWindow?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    @IBAction func otpSubmitAction(sender: AnyObject) {
        let firstName = NSUserDefaults.standardUserDefaults().valueForKey("FIRST_NAME") as? String
        let lastName = NSUserDefaults.standardUserDefaults().valueForKey("LAST_NAME") as? String
        //let mobile = NSUserDefaults.standardUserDefaults().valueForKey("FULL_NAME") as? String
        let email = NSUserDefaults.standardUserDefaults().valueForKey("USER_EMAIL") as? String
        let password = NSUserDefaults.standardUserDefaults().valueForKey("PASSWORD") as? String
        //let imageData = NSUserDefaults.standardUserDefaults().valueForKey("IMG_DATA") as? String
        
        
        let userRegisterDic: NSDictionary = NSDictionary(objects: [CXAppConfig.sharedInstance.getAppMallID(),email!,"DEVICES",password!,firstName!,lastName!,"","","false"],
                                                         forKeys: ["orgId","userEmailId","dt","password","firstName","lastName","gender","filePath","isLoginWithFB"])
        CX_SocialIntegration.sharedInstance.registerWithSocialNewtWokrk(userRegisterDic, completion: { (responseDict) in
            
        })
    }
    
    func leadToHomeScreen() {
        //HomeViewController
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
        
    }
    
 
}
