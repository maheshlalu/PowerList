//
//  SignUpViewController.swift
//  CoupCon
//
//  Created by Manishi on 10/21/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit


class SignUpViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,SWRevealViewControllerDelegate{

    @IBOutlet weak var firstNameTxtField: SkyFloatingLabelTextField!
    @IBOutlet weak var lastNameTxtField: SkyFloatingLabelTextField!
    @IBOutlet weak var mobileTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var emailTxtField: SkyFloatingLabelTextField!
    @IBOutlet weak var pwdTxtField: SkyFloatingLabelTextField!
    @IBOutlet weak var confirmPwdTxtField: SkyFloatingLabelTextField!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var editDPImage: UIImageView!
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
    
        self.navigationController?.navigationBarHidden = false
        self.editDPImage.layer.cornerRadius = self.editDPImage.frame.size.width / 3
        self.editDPImage.clipsToBounds = true
        self.editDPImage.layer.borderWidth = 3.0
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
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.editDPImage.endEditing(true)
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
            }
            
            if !self.isValidEmail(self.emailTxtField.text!) {
                self.emailTxtField.errorMessage = "Invalid Email"
                return
            }

            if self.pwdTxtField.text != self.confirmPwdTxtField.text{
                self.pwdTxtField.errorMessage = "Unequal Password"
                return
            }
            self.sendSignUpDetails()
            
        } else {

            let alert = UIAlertController(title: "Alert!!!", message: "All fields are mandatory. Please enter all fields.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)

        }
    }
    
    func sendSignUpDetails() {
        
        savingDataInUserDefaults()
        self.emailTxtField.errorMessage = ""
        self.mobileTextField.errorMessage = ""
        self.pwdTxtField.errorMessage = ""

        let alert = UIAlertController(title: "CoupoCon", message: "Enter Valid Mobile Number To Get OTP", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addTextFieldWithConfigurationHandler(configurationTextField)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Destructive, handler:handleCancel))
        alert.addAction(UIAlertAction(title: "Submit", style: UIAlertActionStyle.Default, handler:{ (UIAlertAction)in
            print("Item : \(self.alertTextField.text)")
            if self.alertTextField?.text?.characters.count < 10 {
                self.showAlertView("Please Enter Valid Mobile Number", status: 0)
            }else{
                //let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                //let profile = storyBoard.instantiateViewControllerWithIdentifier("OTP_VIEW") as! OTPViewController
                self.signUp()
               // self.navigationController?.pushViewController(profile, animated: true)
            }

        }))
//        self.presentViewController(alert, animated: true, completion: {
//            print("completion block")
//        })
    }
    
    func signUp(){
        
        let firstName = NSUserDefaults.standardUserDefaults().valueForKey("FIRST_NAME") as? String
        let lastName = NSUserDefaults.standardUserDefaults().valueForKey("LAST_NAME") as? String
        //let mobile = NSUserDefaults.standardUserDefaults().valueForKey("FULL_NAME") as? String
        let email = NSUserDefaults.standardUserDefaults().valueForKey("USER_EMAIL") as? String
        let password = NSUserDefaults.standardUserDefaults().valueForKey("PASSWORD") as? String
        //let imageData = NSUserDefaults.standardUserDefaults().valueForKey("IMG_DATA") as? String
        
        
        let userRegisterDic: NSDictionary = NSDictionary(objects: [CXAppConfig.sharedInstance.getAppMallID(),email!,"DEVICES",password!,firstName!,lastName!,"","","false"],
                                                         forKeys: ["orgId","userEmailId","dt","password","firstName","lastName","gender","filePath","isLoginWithFB"])
        CX_SocialIntegration.sharedInstance.registerWithSocialNewtWokrk(userRegisterDic, completion: { (responseDict) in
            self.leadToHomeScreen()
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

    
    func configurationTextField(alertTextField: UITextField!)
    {
        print("generating the TextField")
        alertTextField.delegate = self
        alertTextField.frame = CGRectMake(0, 0, 100, 60)
        alertTextField.placeholder = "Mobile"
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
        NSUserDefaults.standardUserDefaults().setObject(self.mobileTextField.text, forKey: "MOBILE")
        NSUserDefaults.standardUserDefaults().setObject(self.confirmPwdTxtField.text, forKey: "PASSWORD")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else { return true }
        
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= limitLength
        

    }
    
    func showAlertView(message:String, status:Int) {
        let alert = UIAlertController(title:message, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default) {
            UIAlertAction in
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
