//
//  ViewController.swift
//  CoupCon
//
//  Created by apple on 13/10/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class CXSigninViewController: UIViewController,UITextFieldDelegate,FBSDKLoginButtonDelegate,GIDSignInUIDelegate,SWRevealViewControllerDelegate {
    
    @IBOutlet weak var userBtn: UIButton!
    @IBOutlet weak var passwordBtn: UIButton!
    @IBOutlet weak var userTf: UITextField!
    @IBOutlet weak var passwordTf: UITextField!
    @IBOutlet weak var checkboxBtn: UIButton!
    @IBOutlet weak var rememberLabel: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var loginBtn1: UIButton!
    @IBOutlet weak var facebookBtn:  FBSDKLoginButton!
    @IBOutlet weak var gmailBtn: GIDSignInButton!
    @IBOutlet weak var credientailsView: UIView!
    var window: UIWindow?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
        
        GIDSignIn.sharedInstance().uiDelegate = self
        self.userTf.delegate = self
        self.passwordTf.delegate = self

        self.userTf.layer.borderColor = UIColor.whiteColor().CGColor
        self.userTf.layer.borderWidth = 0.8
        self.userTf.layer.cornerRadius = 5
        self.userTf.clipsToBounds = true
        self.userTf.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.3)

        self.passwordTf.layer.borderColor = UIColor.whiteColor().CGColor
        self.passwordTf.layer.borderWidth = 0.8
        self.passwordTf.layer.cornerRadius = 5
        self.passwordTf.clipsToBounds = true
        self.passwordTf.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.3)
        
        self.checkboxBtn.layer.borderColor = UIColor.whiteColor().CGColor
        self.checkboxBtn.layer.borderWidth = 1
        self.checkboxBtn.layer.cornerRadius = 5
        self.checkboxBtn.clipsToBounds = true
        
        self.loginBtn.layer.borderColor = UIColor.whiteColor().CGColor
        self.loginBtn.layer.borderWidth = 1
        self.loginBtn.layer.cornerRadius = 5
        self.loginBtn.clipsToBounds = true
        
        self.facebookBtn.delegate = self
        self.facebookBtn.readPermissions = ["public_profile", "email", "user_friends"];

        self.gmailBtn = GIDSignInButton.init(frame:self.gmailBtn.frame)
        
        //        self.userBtn.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.3)
        //        self.userBtn.layer.borderColor = UIColor.whiteColor().CGColor
        //        self.userBtn.layer.cornerRadius = 2
        //        self.userBtn.layer.borderWidth = 1
        //        self.userBtn.clipsToBounds = true
        //
        //        self.passwordBtn.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.3)
        //        self.passwordBtn.layer.borderColor = UIColor.whiteColor().CGColor
        //        self.passwordBtn.layer.cornerRadius = 2
        //        self.passwordBtn.layer.borderWidth = 1
        //        self.passwordBtn.clipsToBounds = true
   
        
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
        
        //        let fbLoginBtn = FBSDKLoginButton.init(frame: CGRectMake((self.view.frame.size.width-200)/2, hLabel.frame.size.height+hLabel.frame.origin.y+10, 200, 40))
        //        fbLoginBtn.delegate = self
        //        fbLoginBtn.readPermissions = ["public_profile", "email", "user_friends"];
        
        // Do any additional setup after loading the view, typically from a nib.
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(CXSigninViewController.googleSignUp(_:)), name: "GoogleSignUp", object: nil)
        
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()

    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        // handling code
        self.view.endEditing(true)
    }
    
    func keyboardWillShow(sender: NSNotification) {
        if let keyboardSize = (sender.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y = -(keyboardSize.height-60)
        }
    }
    
    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    
    @IBAction func signUpBtnAction(sender: AnyObject) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let profile = storyBoard.instantiateViewControllerWithIdentifier("SignUpViewController") as! SignUpViewController
        self.navigationController?.pushViewController(profile, animated: true)
        
    }
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        //print("Response \(result)")
        FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields":"first_name,email,last_name,gender,picture.type(large),id"]).startWithCompletionHandler { (connection, result, error) -> Void in
            print ("FB Result is \(result)")
            if result != nil {
                CX_SocialIntegration.sharedInstance.applicationRegisterWithFaceBook(result as! NSDictionary, completion: { (resPonce) in
                    self.leadToHomeScreen()
                })
            }
        }
        
    }
    
    // Login Action
    @IBAction func userLoginAction(sender: AnyObject) {
        
        LoadingView.show("loading", animated: true)
//        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getSignInUrl(), parameters: ["orgId":CXAppConfig.sharedInstance.getAppMallID(),"email":email,"dt":"DEVICES","password":password]) { (responseDict) in
//            completion(responseDict: responseDict)
        //http://storeongo.com:8081/MobileAPIs/loginConsumerForOrg?
        let userLoginDict: NSDictionary = NSDictionary(objects: [CXAppConfig.sharedInstance.getAppMallID(),self.userTf.text!,"DEVICES",passwordTf.text!],
                                                         forKeys: ["orgId","email","dt","password"])
        CX_SocialIntegration.sharedInstance.userLogin(userLoginDict) { (responseDict) in
            print(responseDict)
            let status: Int = Int(responseDict.valueForKey("status") as! String)!
            if status == 1{
                self.leadToHomeScreen()
                LoadingView.hide()
            }

            let message = responseDict.valueForKey("msg") as? String
            dispatch_async(dispatch_get_main_queue(), {
                let alert = UIAlertController(title: "Alert!!!", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) in
                    //self.moveBackView()
                    self.navigationController!.popViewControllerAnimated(true)
                    LoadingView.hide()
                }))
                self.presentViewController(alert, animated: true, completion: nil)
            })
            
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

    
    // Google+ Integration
    
    @IBAction func googleBtnAction(sender: AnyObject) {
        
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().clientID = "454116202484-33qe5mvf2ttp49s96dqahr4me91nuft1.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().signIn()
    }
    
    func signInWillDispatch(signIn: GIDSignIn!, error: NSError!) {
        //  myActivityIndicator.stopAnimating()
    }
    
    // Present a view that prompts the user to sign in with Google
    func signIn(signIn: GIDSignIn!,
                presentViewController viewController: UIViewController!) {
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func signIn(signIn: GIDSignIn!,
                dismissViewController viewController: UIViewController!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func googleSignUp(notification: NSNotification){
        
        let dic = notification.object as! [String:AnyObject]
        let orgID:String! = CXAppConfig.sharedInstance.getAppMallID()
        let firstName = dic["given_name"] as! String
        let lastName = dic["family_name"] as! String
        //let gender = dic["gender"] as! String
        let  profilePic = dic["picture"] as! String
        let  email = dic["email"] as! String
        
        
        CX_SocialIntegration.sharedInstance.applicationRegisterWithGooglePlus(dic) { (resPonce) in
            self.leadToHomeScreen()
        }

        print("\(email)\(firstName)\(lastName)\(profilePic)\(orgID)")
        
        NSUserDefaults.standardUserDefaults().setObject(profilePic, forKey: "PROFILE_PIC")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        //self.registeringWithSillyMonks(email,firstname:firstName, lastname: lastName, gender: gender, profilePic:profilePic)
        self.showAlertView("Login successfully.", status: 1)
        
    }
    
    
    func showAlertView(message:String, status:Int) {
        dispatch_async(dispatch_get_main_queue(), {
            let alert = UIAlertController(title: "CoupoCon", message: message, preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                if status == 1 {
                        self.navigationController?.popViewControllerAnimated(true)
                    }
            }
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true, completion: nil)
        })
    }
    
}

