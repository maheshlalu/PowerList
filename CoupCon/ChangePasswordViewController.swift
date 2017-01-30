//
//  ChangePasswordViewController.swift
//  Coupocon
//
//  Created by Manishi on 1/30/17.
//  Copyright © 2017 CX. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    
    @IBOutlet weak var currentPswTxtField: UITextField!
    @IBOutlet weak var newPswTxtField: UITextField!
    @IBOutlet weak var confirmPswTxtField: UITextField!
    @IBOutlet weak var changePswBtn: UIButton!
    var email:String!

    @IBOutlet weak var cVBtn: UIButton!
    @IBOutlet weak var nVBtn: UIButton!
    @IBOutlet weak var nRVBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.setUPTheNavigationProperty()
        resignKeyBoard()
        
        cVBtn.layer.cornerRadius = 4
        nVBtn.layer.cornerRadius = 4
        nRVBtn.layer.cornerRadius = 4
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
    
    @IBAction func cVBtnAction(sender: UIButton) {
        sender.selected = !sender.selected
        if sender.selected{
            self.currentPswTxtField.secureTextEntry = false
        }else{
        self.currentPswTxtField.secureTextEntry = true
        }
    }
    
    @IBAction func nVBtnAction(sender: UIButton) {
        sender.selected = !sender.selected
        if sender.selected{
            self.newPswTxtField.secureTextEntry = false
        }else{
            self.newPswTxtField.secureTextEntry = true
        }    }
    
    @IBAction func nRVBtnAction(sender: UIButton) {
        sender.selected = !sender.selected
        if sender.selected{
            self.confirmPswTxtField.secureTextEntry = false
        }else{
            self.confirmPswTxtField.secureTextEntry = true
        }    }
    
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        // handling code
        self.view.endEditing(true)
    }
    
    func keyboardWillShow(sender: NSNotification) {
        if let keyboardSize = (sender.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y = -(keyboardSize.height-150)
        }
    }
    
    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    @IBAction func changePswAction(sender: AnyObject) {
        self.view.endEditing(true)
        if self.confirmPswTxtField.text?.characters.count > 0
            && self.newPswTxtField.text?.characters.count > 0
            && self.currentPswTxtField.text?.characters.count > 0 {
            
            if newPswTxtField.text != confirmPswTxtField.text{
                let alert = UIAlertController(title: "Coupocon", message: "Password doesn't match!!!", preferredStyle: UIAlertControllerStyle.Alert)
                self.presentViewController(alert, animated: true, completion: nil)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: { (alert) in
                    self.newPswTxtField.text = nil
                    self.confirmPswTxtField.text = nil
                }))
                
            }else{
                
                CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getChangePswUrl(), parameters: ["orgId":CXAppConfig.sharedInstance.getAppMallID() as String,"dt":"DEVICES","cPassword":self.currentPswTxtField.text!,"nPassword":self.newPswTxtField.text!,"nrPassword":self.confirmPswTxtField.text!,"email":email]) { (responseDict) in
                    print(responseDict)
                    let message = responseDict.valueForKeyPath("myHashMap.msg") as! String
                    let status: Int = Int(responseDict.valueForKeyPath("myHashMap.status") as! String)!
                    self.showAlertView(message, status: status)
                    
                }
            }}else {
            let alert = UIAlertController(title: "NV Agencies", message: "All fields are mandatory. Please enter all fields.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func showAlertView(message:String, status:Int) {
        dispatch_async(dispatch_get_main_queue(), {
            let alert = UIAlertController(title: "Coupocon", message: message, preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                if status == 1 {
                    self.navigationController?.popToRootViewControllerAnimated(true)
                }else{
                
                }
            }
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true, completion: nil)
        })
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func setUPTheNavigationProperty(){
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController!.navigationBar.barTintColor = CXAppConfig.sharedInstance.getAppTheamColor()
        self.view.backgroundColor = UIColor.whiteColor()
        
        let navigation:UINavigationItem = navigationItem
        navigation.title = "Change Password"
        
    }
}
