//
//  OTPTextViewController.swift
//  Coupocon
//
//  Created by apple on 10/11/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit

class OTPTextViewController: UIViewController,UITextFieldDelegate {
    
    var limitLength = 10
    @IBOutlet weak var mobileTxtField: UITextField!
    @IBOutlet weak var bgImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mobileTxtField.delegate = self
        
        
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
        // Do any additional setup after loading the view.
        
        
    }
    
    
    func updateThePhoneNumber(){
        CX_SocialIntegration.sharedInstance.updateTheSaveConsumerProperty(["ownerId":CXAppConfig.sharedInstance.getAppMallID(),"consumerEmail":CXAppConfig.sharedInstance.getEmail(),"propName":"mobileNo","propValue":self.mobileTxtField.text!]) { (resPonce) in
            
        }
        // http://storeongo.com:8081/MobileAPIs/saveConsumerProperty?ownerId=20217&consumerEmail=yernagulamahesh@gmail.com&propName=mobileNo&propValue=8096380038
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func submitAction(sender: AnyObject) {
        
        if mobileTxtField.text?.characters.count < limitLength{
            self.showAlertView("Please Enter Valid Mobile Number!!!!", status: 0)
            
        }else{
            CX_SocialIntegration.sharedInstance.sendingOTPForGivenNumber(mobileTxtField.text!, completion: { (resPonce) in
                if resPonce {
                    let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                    let profile = storyBoard.instantiateViewControllerWithIdentifier("OTP_VIEW") as! OTPViewController
                    profile.otpEmail = CXAppConfig.sharedInstance.getTheUserData().userEmail
                    self.navigationController?.pushViewController(profile, animated: true)
                    self.updateThePhoneNumber()
                }
            })
        
        }
        
        
    }
    /*
     

     */
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
            guard let text = textField.text else { return true }
            let newLength = text.characters.count + string.characters.count - range.length
            return newLength <= limitLength

        }
        
        return true
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
        self.bgImageView.resignFirstResponder()
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
