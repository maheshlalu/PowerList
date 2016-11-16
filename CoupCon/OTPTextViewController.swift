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
    var otpEmail:String! = CXAppConfig.sharedInstance.getEmail()
    var fromSignUp:Bool = false
    let chooseArticleDropDown = DropDown()
    
    @IBOutlet weak var selectCityBtn: UIButton!
    @IBOutlet weak var mobileTxtField: UITextField!
    @IBOutlet weak var bgImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = true
        self.mobileTxtField.delegate = self
        self.keyBoardShowUp()
        self.setupDropDowns()
        
    }
    
    func keyBoardShowUp(){
        
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
    
    }
    
    //Dropdown
    @IBAction func selectCityBtn(sender: AnyObject) {
        chooseArticleDropDown.show()
    }
    
    func setupDropDowns() {
        self.selectCityBtn.setTitle("Select City", forState: .Normal)
        setupChooseArticleDropDown()
    }

    
    //Submit Action
    @IBAction func submitAction(sender: AnyObject) {
        
        //        let appDel = (UIApplication.sharedApplication().delegate) as! AppDelegate
        //        appDel.applicationNavigationFlow()
        //
        //        return
        
        if (mobileTxtField.text?.characters.count == 0 || selectCityBtn.titleLabel?.text == "Select City"){
            self.showAlertView("Fields can't be empty!!", status: 0)
            
        }else{
            
            if mobileTxtField.text?.characters.count < limitLength{
                self.showAlertView("Please Enter Valid Mobile Number!!!!", status: 0)
                
            }else{
                if fromSignUp == false{
                    
                    emailCheckingForOTP()
                    self.updateThePhoneNumber(mobileTxtField.text!, city: (selectCityBtn.titleLabel?.text!)!, completion: { (responseDict) in
                        print(responseDict)
                        let status: Int = Int(responseDict.valueForKey("status") as! String)!
                        if status == 1{
                            print("Updated Successfully")
                        }
                    })
                }else{
                    self.updateThePhoneNumber(mobileTxtField.text!, city: (selectCityBtn.titleLabel?.text!)!, completion: { (responseDict) in
                        print(responseDict)
                        let status: Int = Int(responseDict.valueForKey("status") as! String)!
                        if status == 1{
                            print("Updated Successfully")
                            self.sendingOTPForGivenNumber()
                        }
                    })
                }
            }
        }
    }

    //Checking email
    func emailCheckingForOTP(){
        // http://storeongo.com:8081/ MobileAPIs/accountVerification?ownerId=530&consumerEmail=cxsample@gmail.com
        LoadingView.show("Checking Entered Email...", animated: true)
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getVarifyingEmailOTP(), parameters: ["ownerId":CXAppConfig.sharedInstance.getAppMallID(),"consumerEmail":otpEmail]) { (responseDict) in
            LoadingView.hide()
            print(responseDict)
            let status: Int = Int(responseDict.valueForKey("status") as! String)!
            let message = responseDict.valueForKey("message") as! String
            
            if status == 1{
                // If Status is 1 then the user email id is already regesterd with email.Can't able to send OTP. Which means give another email.
                self.showAlertView(message, status: 0)
                return
            }else{
                //Sending the OTP to given mobile number (status is -1 or 0). Eligible to send OTP.
                LoadingView.show("Loading...", animated: true)
                self.sendingOTPForGivenNumber()
                LoadingView.hide()
            }
            
        }
        
    }
    
    // Otp sending call
    func sendingOTPForGivenNumber(){
        
        //http://storeongo.com:8081/MobileAPIs/sendCoupoconSMS? ownerId=530& consumerEmail=cxsample@gmail.com& mobile=919581552229
        
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getSendingOTP(), parameters: ["ownerId":CXAppConfig.sharedInstance.getAppMallID(),"consumerEmail":otpEmail,"mobile":"91\(self.mobileTxtField.text!)"]) { (responseDict) in
            // sleep(1000)
            print(responseDict)
            let status: Int = Int(responseDict.valueForKey("status") as! String)!
            
            if status == 1{
                // OTP SENT
                self.showAlertView("OTP sent Successfully!!!", status: 100)
                
            }else{
                // OTP NOT SENT
                self.showAlertView("Something Went Wrong!! Pleace check Email!!!", status: 0)
            }
        }
    }
    

    
    
    // Updating user mobile and city
    func updateThePhoneNumber(mobile:String,city:String,completion:(responseDict:NSDictionary) -> Void){
        
        let jsonDic : NSMutableDictionary = NSMutableDictionary()
        jsonDic.setObject(mobile, forKey: "mobileNo")
        jsonDic.setObject(city, forKey: "city")
        
        var jsonData : NSData = NSData()
        do {
            jsonData = try NSJSONSerialization.dataWithJSONObject(jsonDic, options: NSJSONWritingOptions.PrettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
        } catch let error as NSError {
            print(error)
        }
        let jsonStringFormat = String(data: jsonData, encoding: NSUTF8StringEncoding)
        print(jsonStringFormat)
        
        
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getUpdatedUserDetails(), parameters: ["jobId":CXAppConfig.sharedInstance.getMacJobID() as AnyObject,"jsonString":jsonStringFormat! ,"ownerId":CXAppConfig.sharedInstance.getAppMallID() as AnyObject]) { (responseDic) in
            print(responseDic)
            completion(responseDict:responseDic)
            
        }
        
        //http://storeongo.com:8081/ MobileAPIs/updateMultipleProperties? jobId=200689&jsonString=%7B%22mobileNo%22:%229848441331%22,%22city%22:%22P une%22%7D&ownerId=20217
        //    http://storeongo.com:8081/MobileAPIs/updateMultipleProperties/jobId=200400&jsonString= {"PaymentType":"249","ValidTill":"11-11-2017","userStatus":"active"}&ownerId=20217
        
    }
    
    
    
    //Showing Alert
    func showAlertView(message:String, status:Int) {
        let alert = UIAlertController(title:message, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            
            if status == 100 {
                let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                let profile = storyBoard.instantiateViewControllerWithIdentifier("OTP_VIEW") as! OTPViewController
                profile.otpEmail = CXAppConfig.sharedInstance.getTheUserData().userEmail
                self.navigationController?.pushViewController(profile, animated: true)
                
            }else{
                
            }
        }
        alert.addAction(okAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
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
    
}



//Droup down
extension OTPTextViewController{
    
    func setupChooseArticleDropDown() {
        
        chooseArticleDropDown.anchorView = selectCityBtn
        chooseArticleDropDown.bottomOffset = CGPoint(x: 0,y: self.selectCityBtn.frame.size.height+4)
        chooseArticleDropDown.dataSource = ["Hyderabad","Pune"]
        
        // You can also use localizationKeysDataSource instead. Check the docs.
        chooseArticleDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.selectCityBtn.setTitle(item, forState: .Normal)
            
        }
        
    }
}
