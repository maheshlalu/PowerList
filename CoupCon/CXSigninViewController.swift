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
class CXSigninViewController: UIViewController,UITextFieldDelegate,FBSDKLoginButtonDelegate,GIDSignInUIDelegate {

    
    @IBOutlet weak var userBtn: UIButton!
    
    @IBOutlet weak var passwordBtn: UIButton!
    
    @IBOutlet weak var userTf: UITextField!
    
    @IBOutlet weak var passwordTf: UITextField!
    
    @IBOutlet weak var checkboxBtn: UIButton!
    
    @IBOutlet weak var rememberLabel: UILabel!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var loginBtn1: UIButton!
    
    @IBOutlet weak var facebookBtn: UIButton!
    
    @IBOutlet weak var gmailBtn: UIButton!
    
    
    @IBOutlet weak var credientailsView: UIView!
    
    
    
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
          GIDSignIn.sharedInstance().uiDelegate = self
        self.userTf.delegate = self
        self.passwordTf.delegate = self
        
        GIDSignIn.sharedInstance().signInSilently()

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
        
        self.facebookBtn.layer.borderColor = UIColor.whiteColor().CGColor
        self.facebookBtn.layer.borderWidth = 1
        self.facebookBtn.layer.cornerRadius = 3
        self.facebookBtn.clipsToBounds = true
       // self.loginBtn2.delegate = self
         //self.loginBtn2.readPermissions = ["public_profile", "email", "user_friends"];
        
        
        self.gmailBtn.layer.borderColor = UIColor.whiteColor().CGColor
        self.gmailBtn.layer.borderWidth = 1
        self.gmailBtn.layer.cornerRadius = 3
        self.gmailBtn.clipsToBounds = true
        
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("Response \(result)")
        FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields":"first_name,email,last_name,gender,picture.type(large),id"]).startWithCompletionHandler { (connection, result, error) -> Void in
            print ("FB Result is \(result)")
            if result != nil {
//                
//                let strFirstName: String = (result.objectForKey("first_name") as? String)!
//                let strLastName: String = (result.objectForKey("last_name") as? String)!
//                let gender: String = (result.objectForKey("gender") as? String)!
//                let email: String = (result.objectForKey("email") as? String)!
//                self.profileImageStr = (result.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as? String)!
//                print("Welcome,\(email) \(strFirstName) \(strLastName) \(gender) \(self.profileImageStr)")
//                
//                self.registeringWithSillyMonks(email, firstname: strFirstName, lastname: strLastName, gender: gender, profilePic: self.profileImageStr)
//                NSUserDefaults.standardUserDefaults().setObject(self.profileImageStr, forKey: "PROFILE_PIC")
//                NSUserDefaults.standardUserDefaults().synchronize()
//                
//                self.showAlertView("Login successfully.", status: 1)
            }
            //NSNotificationCenter.defaultCenter().postNotificationName("UpdateProfilePic", object: nil)
        }
        
    }

    
    // Google
    
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

}

