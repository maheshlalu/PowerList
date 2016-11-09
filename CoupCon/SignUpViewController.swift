//
//  SignUpViewController.swift
//  CoupCon
//
//  Created by Manishi on 10/21/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit


class SignUpViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,SWRevealViewControllerDelegate,UIScrollViewDelegate{
    
    @IBOutlet weak var firstNameTxtField: SkyFloatingLabelTextField!
    @IBOutlet weak var lastNameTxtField: SkyFloatingLabelTextField!
    @IBOutlet weak var mobileTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var emailTxtField: SkyFloatingLabelTextField!
    @IBOutlet weak var pwdTxtField: SkyFloatingLabelTextField!
    @IBOutlet weak var confirmPwdTxtField: SkyFloatingLabelTextField!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var editDPImage: UIImageView!
    @IBOutlet weak var signUpScrollView: UIScrollView!
    var window: UIWindow?
    var alertTextField:UITextField! = nil
    let limitLength = 10
    
    //    var firstName:String!
    //    var lastName:String!
    //    var emai:String!
    //    var mobile:String!
    //    var dpImg:String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUPTheNavigationProperty()
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.editDPImage.layer.cornerRadius = 85
        self.editDPImage.clipsToBounds = true
        self.editDPImage.layer.borderWidth = 5.0
        
        self.editDPImage.layer.borderColor = UIColor.whiteColor().CGColor
        
        let imgTap:UIGestureRecognizer = UITapGestureRecognizer.init()
        imgTap.addTarget(self, action: #selector(imagePickerAction(_:)))
        self.editDPImage.addGestureRecognizer(imgTap)
        
        
        //        headerViewAlignments()
        //        dataIntegration()
        //        editDropDown()
        //        self.saveImageBtn.hidden = true
        //        let imgTap:UIGestureRecognizer = UITapGestureRecognizer.init()
        //        imgTap.addTarget(self, action: #selector(editBtnAction(_:)))
        //        editDPImage.addGestureRecognizer(imgTap)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(SignUpViewController.keyboardWillShow(_:)),
                                                         name: UIKeyboardWillShowNotification,
                                                         object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(SignUpViewController.keyboardWillHide(_:)),
                                                         name: UIKeyboardWillHideNotification,
                                                         object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.handleTap(_:)))
        self.signUpScrollView.addGestureRecognizer(tap)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.editDPImage.endEditing(true)
    }
    
    @IBAction func editImgBtnAction(sender: AnyObject) {
        imagePickerAction(sender)
    }
    func setUPTheNavigationProperty(){
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController!.navigationBar.barTintColor = CXAppConfig.sharedInstance.getAppTheamColor()
        self.view.backgroundColor = UIColor.whiteColor()
        
        let navigation:UINavigationItem = navigationItem
        //let image = UIImage(named: "logo_white")
        navigation.title = "Sign Up"
        
    }
    
    func imagePickerAction(sender: AnyObject){
        
        print("choose from photos")
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        self.presentViewController(image, animated: true, completion: nil)
    }
    
    
    
    @IBAction func signUpBtnAction(sender: AnyObject) {
        self.view.endEditing(true)
        
        if self.firstNameTxtField.text?.characters.count > 0
            && self.lastNameTxtField.text?.characters.count > 0
            && self.emailTxtField.text?.characters.count > 0
            && self.pwdTxtField.text?.characters.count > 0 && self.confirmPwdTxtField.text?.characters.count>0 &&
            self.mobileTextField.text?.characters.count > 0 {
            
            
            if self.mobileTextField.text?.characters.count < 10 {
                self.mobileTextField.errorMessage = "Invalid Mobile"
                return
            }else{
                self.mobileTextField.errorMessage = nil
            }
            
            if !self.isValidEmail(self.emailTxtField.text!) {
                self.emailTxtField.errorMessage = "Invalid Email"
                return
            }else{
                self.emailTxtField.errorMessage = nil
            }
            
            if self.pwdTxtField.text != self.confirmPwdTxtField.text{
                self.confirmPwdTxtField.errorMessage = "Unequal Password"
                return
            }else{
                self.confirmPwdTxtField.errorMessage = nil
            }
            
            self.sendSignUpDetails()
            
        } else {
            
            let alert = UIAlertController(title: "Alert!!!", message: "All fields are mandatory. Please enter all fields.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
    }
    
    func sendSignUpDetails() {
        
        if NSUserDefaults.standardUserDefaults().valueForKey("IMG_DATA") == nil{
            let alert = UIAlertController(title:"Please Upload Profile Image", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                
            }
            let anywayAction = UIAlertAction(title: "SignUp Anyway!!!", style: UIAlertActionStyle.Destructive) {
                UIAlertAction in
                
                let image = self.editDPImage.image! as UIImage
                let imageData = NSData(data: UIImagePNGRepresentation(image)!)
                NSUserDefaults.standardUserDefaults().setObject(imageData, forKey: "IMG_DATA")
                self.showOTPAlertView()
                
            }
            alert.addAction(okAction)
            alert.addAction(anywayAction)
            self.presentViewController(alert, animated: true, completion: nil)
            
        } else {
            
            showOTPAlertView()
            
        }
    }
    
    func showOTPAlertView(){
        
        let alert = UIAlertController(title: "Coupocon", message: "You will get an OTP for below number...\n(You can change the number if you want...) ", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addTextFieldWithConfigurationHandler(configurationTextField)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Destructive, handler:handleCancel))
        alert.addAction(UIAlertAction(title: "Submit", style: UIAlertActionStyle.Default, handler:{ (UIAlertAction)in
            print("Item : \(self.alertTextField.text)")
            if self.alertTextField?.text?.characters.count < 10 {
                self.showAlertView("Please Enter Valid Mobile Number", status: 0)
            }else{
                //Validating User EmailId for OTP
                 self.savingDataInUserDefaults()
                self.signUp()
                
            }
            
            
        }))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func emailCheckingForOTP(){
        // http://storeongo.com:8081/ MobileAPIs/accountVerification?ownerId=530&consumerEmail=cxsample@gmail.com
        LoadingView.show("Checking Entered Email...", animated: true)
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getVarifyingEmailOTP(), parameters: ["ownerId":CXAppConfig.sharedInstance.getAppMallID(),"consumerEmail":emailTxtField.text! as String]) { (responseDict) in
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
    
    func sendingOTPForGivenNumber(){
        
        //http://storeongo.com:8081/MobileAPIs/sendCoupoconSMS? ownerId=530& consumerEmail=cxsample@gmail.com& mobile=919581552229
        
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getSendingOTP(), parameters: ["ownerId":CXAppConfig.sharedInstance.getAppMallID(),"consumerEmail":emailTxtField.text! as String,"mobile":"91\(self.alertTextField.text!)"]) { (responseDict) in
           // sleep(1000)
            print(responseDict)
            let status: Int = Int(responseDict.valueForKey("status") as! String)!
            
            if status == 1{
                // OTP SENT
                NSUserDefaults.standardUserDefaults().setObject(responseDict.valueForKey("OTP"), forKey: "OTP")
                self.showAlertView("OTP sent Successfully!!!", status: 100)
               //After sending the OTP to given number, pushing to OTPViewController
       
            }else{
                // OTP NOT SENT
                self.showAlertView("Something Went Wrong!! Pleace check Email!!!", status: 0)
            }
        }
    }
    
    func configurationTextField(alertTextField: UITextField!)
    {
        print("generating the TextField")
        alertTextField.delegate = self
        alertTextField.frame = CGRectMake(0, 0, 100, 60)
        alertTextField.placeholder = "Mobile"
        alertTextField.text = self.mobileTextField.text
        alertTextField.font = UIFont.systemFontOfSize(15)
        alertTextField.autocorrectionType = UITextAutocorrectionType.No
        alertTextField.keyboardType = UIKeyboardType.NumberPad
        alertTextField.returnKeyType = UIReturnKeyType.Done
        alertTextField.clearButtonMode = UITextFieldViewMode.WhileEditing;
        alertTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        self.alertTextField = alertTextField
    }
    
    func handleCancel(alertView: UIAlertAction!)
    {
        print("User click Cancel button")
    }
    
    func savingDataInUserDefaults() {
        
        NSUserDefaults.standardUserDefaults().setObject(self.emailTxtField.text, forKey: "USER_EMAIL")
        NSUserDefaults.standardUserDefaults().setObject(self.firstNameTxtField.text, forKey: "FIRST_NAME")
        NSUserDefaults.standardUserDefaults().setObject(self.lastNameTxtField.text, forKey: "LAST_NAME")
        NSUserDefaults.standardUserDefaults().setObject(self.alertTextField.text, forKey: "MOBILE")
        NSUserDefaults.standardUserDefaults().setObject(self.confirmPwdTxtField.text, forKey: "PASSWORD")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func signUp(){
        
        LoadingView.show("Loading...", animated: true)

        let firstName = NSUserDefaults.standardUserDefaults().valueForKey("FIRST_NAME") as? String
        let lastName = NSUserDefaults.standardUserDefaults().valueForKey("LAST_NAME") as? String
       // let mobile = NSUserDefaults.standardUserDefaults().valueForKey("FULL_NAME") as? String
        let email = NSUserDefaults.standardUserDefaults().valueForKey("USER_EMAIL") as? String
        let password = NSUserDefaults.standardUserDefaults().valueForKey("PASSWORD") as? String
        let imageData = NSUserDefaults.standardUserDefaults().valueForKey("IMG_DATA") as? NSData
        LoadingView.show("Regestiring...", animated: true)
        
        if imageData != nil {
            CXDataService.sharedInstance.imageUpload(imageData!, completion: { (Response) in
                print(Response)
                let status: Int = Int(Response.valueForKey("status") as! String)!
                if status == 1{
                    let imgStr = Response.valueForKey("filePath") as! String
                    let userRegisterDic: NSDictionary = NSDictionary(objects: [CXAppConfig.sharedInstance.getAppMallID(),email!,"DEVICES",password!,firstName!,lastName!,"",imgStr,"false"],
                        forKeys: ["orgId","userEmailId","dt","password","firstName","lastName","gender","filePath","isLoginWithFB"])
                    CX_SocialIntegration.sharedInstance.registerWithSocialNewtWokrk(userRegisterDic, completion: { (responseDict) in
                        print(responseDict)
                        self.emailCheckingForOTP()
                        LoadingView.hide()
                    })
                    //NSUserDefaults.standardUserDefaults().setObject(Response.valueForKey("filePath"), forKey: "IMG_URL")
                }
            })
        }else{
            let userRegisterDic: NSDictionary = NSDictionary(objects: [CXAppConfig.sharedInstance.getAppMallID(),email!,"DEVICES",password!,firstName!,lastName!,"","","false"],
                                                             forKeys: ["orgId","userEmailId","dt","password","firstName","lastName","gender","filePath","isLoginWithFB"])
            CX_SocialIntegration.sharedInstance.registerWithSocialNewtWokrk(userRegisterDic, completion: { (responseDict) in
                print(responseDict)
                self.emailCheckingForOTP()
                LoadingView.hide()
            })
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else { return true }
        
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= limitLength
        
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func showAlertView(message:String, status:Int) {
        let alert = UIAlertController(title:message, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            
            if status == 100 {
                let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                let profile = storyBoard.instantiateViewControllerWithIdentifier("OTP_VIEW") as! OTPViewController
                profile.otpEmail = NSUserDefaults.standardUserDefaults().valueForKey("USER_EMAIL") as? String
                self.navigationController?.pushViewController(profile, animated: true)
            }else{
                
            }
        }
        alert.addAction(okAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func isValidEmail(email: String) -> Bool {
        // print("validate email: \(email)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if emailTest.evaluateWithObject(email) {
            return true
        }
        return false
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
        self.signUpScrollView.resignFirstResponder()
    }
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            editDPImage.contentMode = .ScaleToFill
            editDPImage.image = pickedImage
            let image = pickedImage as UIImage
            let imageData = NSData(data: UIImagePNGRepresentation(image)!)
            NSUserDefaults.standardUserDefaults().setObject(imageData, forKey: "IMG_DATA")
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
}
