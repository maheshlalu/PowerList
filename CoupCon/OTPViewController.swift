//
//  OTPViewController.swift
//  CoupCon
//
//  Created by Manishi on 10/24/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit

class OTPViewController: UIViewController,SWRevealViewControllerDelegate,UITextFieldDelegate {
    var window: UIWindow?
    var otpEmail:String!
    
    @IBOutlet weak var backImgView: UIImageView!
    @IBOutlet weak var otpTxtField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated:true);
        let navigation:UINavigationItem = navigationItem
        navigation.title = "OTP SCREEN"
        self.otpTxtField.delegate = self
        print("\(otpEmail)")
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(CXSigninViewController.keyboardWillShow(_:)),
                                                         name: UIKeyboardWillShowNotification,
                                                         object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(CXSigninViewController.keyboardWillHide(_:)),
                                                         name: UIKeyboardWillHideNotification,
                                                         object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(CXSigninViewController.handleTap(_:)))
        self.view.addGestureRecognizer(tap)
        
    //    self.updateThePhoneNumber()
        
    
    }
    
    
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.backImgView.endEditing(true)
    }

    @IBAction func otpSubmitAction(sender: AnyObject) {
        
       // http://storeongo.com:8081/MobileAPIs/verifyOTP?ownerId=530&consumerEmail=cxsample@gmail.com&otp=538849
        if otpTxtField.text != ""{
            //Comparing the Entered OTP With SMS OTP
            self.comparingFieldWithOTP()
            
        }else{
            showAlertView("Field Can't Be Empty!!!", status: 0)
        }
        
    }
    
    func comparingFieldWithOTP(){
    
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getComparingOTP(), parameters: ["ownerId":CXAppConfig.sharedInstance.getAppMallID(),"consumerEmail":otpEmail! as String,"otp":self.otpTxtField.text!]) { (responseDict) in
            LoadingView.hide()
            print(responseDict)
            let status: Int = Int(responseDict.valueForKey("status") as! String)!
            let message = responseDict.valueForKey("message") as! String
            
            if status == 1{
                // Leading to HomeView
                self.showAlertView(message, status: 0)
                let appDel = (UIApplication.sharedApplication().delegate) as! AppDelegate
                appDel.applicationNavigationFlow()
        
            }else{
                // Error
                self.showAlertView(message, status: 0)
            }
        }
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
    
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        // handling code
        self.view.endEditing(true)
    }
    
    func keyboardWillShow(sender: NSNotification) {
        if let keyboardSize = (sender.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if view.frame.origin.y == 0{
                self.view.frame.origin.y = -(keyboardSize.height-60)
            }
            else {
                
            }
        }
    }
    
    func keyboardWillHide(sender: NSNotification) {
        if ((sender.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()) != nil {
            if view.frame.origin.y != 0 {
                self.view.frame.origin.y = 0
            }
            else {
                
            }
        }
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.backImgView.resignFirstResponder()
    }

    
    //Showing Alert
    func showAlertView(message:String, status:Int) {
        let alert = UIAlertController(title:message, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            
            if status == 1 {
                
            }else{
                
            }
        }
        alert.addAction(okAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
 
}
