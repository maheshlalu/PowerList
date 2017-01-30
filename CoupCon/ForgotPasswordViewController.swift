//
//  ForgotPasswordViewController.swift
//  Coupocon
//
//  Created by Manishi on 1/30/17.
//  Copyright © 2017 CX. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        resignKeyBoard()
        setUPTheNavigationProperty()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.emailTxtField.text = nil
    }

    @IBAction func submitAction(sender: AnyObject) {
        self.view.endEditing(true)
        
        if self.isValidEmail(self.emailTxtField.text!) {
            
            LoadingView.show("Processing...", animated: true)
            CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getForgotPassordUrl(), parameters: ["email":emailTxtField.text! as String,"orgId":CXAppConfig.sharedInstance.getAppMallID()]) { (responseDict) in
                print(responseDict)
                let message = responseDict.valueForKey("result") as? String
                let status = Int(responseDict.valueForKey("status") as! String)
                if status == 1{
                    self.showAlertView("Please check your mail. Password sent successfully!!", status: 1)
                }else{
                    self.showAlertView(message!, status: 0)
                }
            }
        } else {
                self.showAlertView("Please enter valid email address.", status: 0)
        }
    }
    
    func resignKeyBoard(){
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(ChangePasswordViewController.keyboardWillShow(_:)),
                                                         name: UIKeyboardWillShowNotification,
                                                         object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(ChangePasswordViewController.keyboardWillHide(_:)),
                                                         name: UIKeyboardWillHideNotification,
                                                         object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ChangePasswordViewController.handleTap(_:)))
        self.view.addGestureRecognizer(tap)
        
    }
    
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        // handling code
        self.view.endEditing(true)
    }
    
    func keyboardWillShow(sender: NSNotification) {
        if let keyboardSize = (sender.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y = -(keyboardSize.height-120)
        }
    }
    
    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if emailTest.evaluateWithObject(email) {
            return true
        }
        return false
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func showAlertView(message:String, status:Int) {
        dispatch_async(dispatch_get_main_queue(), {
            let alert = UIAlertController(title: "Coupocon", message: message, preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                if status == 1 {
                    let changePswController:ChangePasswordViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ChangePasswordViewController") as! ChangePasswordViewController
                    changePswController.email = self.emailTxtField.text!
                    self.navigationItem.leftBarButtonItem?.title = "Back"
                    self.navigationController?.pushViewController(changePswController, animated: true)
                    
                }else if status == 0{
                   
                }else{
                     self.navigationController?.popViewControllerAnimated(true)
                }
            }
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true, completion: nil)
        })
    }
    
    func setUPTheNavigationProperty(){
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController!.navigationBar.barTintColor = CXAppConfig.sharedInstance.getAppTheamColor()
        self.view.backgroundColor = UIColor.whiteColor()
        
        let navigation:UINavigationItem = navigationItem
        //let image = UIImage(named: "logo_white")
        navigation.title = "Forgot Password"
        
    }
}
