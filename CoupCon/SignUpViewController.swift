//
//  SignUpViewController.swift
//  CoupCon
//
//  Created by Manishi on 10/21/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit


class SignUpViewController: UIViewController,UITextFieldDelegate{

    @IBOutlet weak var firstNameTxtField: SkyFloatingLabelTextField!
    @IBOutlet weak var lastNameTxtField: SkyFloatingLabelTextField!
    @IBOutlet weak var mobileTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var emailTxtField: SkyFloatingLabelTextField!
    @IBOutlet weak var pwdTxtField: SkyFloatingLabelTextField!
    @IBOutlet weak var confirmPwdTxtField: SkyFloatingLabelTextField!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var editDPImage: UIImageView!
    let limitLength = 10
    
    
//    var firstName:String!
//    var lastName:String!
//    var emai:String!
//    var mobile:String!
//    var dpImg:String!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.editDPImage.layer.cornerRadius = self.editDPImage.frame.size.width / 3
        self.editDPImage.clipsToBounds = true
        self.editDPImage.layer.borderWidth = 3.0
        self.editDPImage.layer.borderColor = UIColor.whiteColor().CGColor
        
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
    
    @IBAction func signUpBtnAction(sender: AnyObject) {
        
        let alert = UIAlertController(title: "CoupoCon", message: "Enter Valid Mobile Number To Get OTP", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addTextFieldWithConfigurationHandler { (alertTxtField) in
            
            alertTxtField.delegate = self
            alertTxtField.frame = CGRectMake(0, 0, 100, 60)
            alertTxtField.placeholder = "Mobile"
            alertTxtField.font = UIFont.systemFontOfSize(15)
            alertTxtField.autocorrectionType = UITextAutocorrectionType.No
            alertTxtField.keyboardType = UIKeyboardType.NumberPad
            alertTxtField.returnKeyType = UIReturnKeyType.Done
            alertTxtField.clearButtonMode = UITextFieldViewMode.WhileEditing;
            alertTxtField.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Destructive, handler:handleCancel))
        alert.addAction(UIAlertAction(title: "Submit", style: UIAlertActionStyle.Default, handler:{ (UIAlertAction)in
            print("User click Ok button")

        }))
        self.presentViewController(alert, animated: true, completion: {
            print("completion block")
        })
        
    }

    func handleCancel(alertView: UIAlertAction!)
    {
        print("User click Cancel button")
    }
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= limitLength
    }
    
//    func dataIntegration(){
//        staticEmail.text = emai
//        staticMobileNumber.text = mobile
//        
//        firstNameTxtField.text = firstName
//        lastNameTxtField.text = lastName
//        addressTxtField.text = NSUserDefaults.standardUserDefaults().valueForKey("ADDRESS") as? String
//        cityTxtField.text = NSUserDefaults.standardUserDefaults().valueForKey("CITY") as? String
//        stateTxtField.hidden = true
//        
//        
//        
//    }
//    @IBAction func editBtnAction(sender: AnyObject) {
//        
//        let image = UIImagePickerController()
//        image.delegate = self
//        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
//        image.allowsEditing = false
//        self.presentViewController(image, animated: true, completion: nil)
//    }
//    
//    @IBAction func saveChangesAction(sender: AnyObject) {
//        self.view.endEditing(true)
//        
//        self.editProfileDetails()
//        
//    }
//    
//     /*
//    func editProfileDetails(){
//        let alert = UIAlertController(title:"Save Changes?", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
//        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { (UIAlertAction) in
//            LoadingView.show("Uploading!!", animated: true)
//            let imgStr = NSUserDefaults.standardUserDefaults().valueForKey("IMAGE_PATH") as! String
//            CXAppDataManager.sharedInstance.profileUpdate(self.staticEmail.text!, address:self.addressTxtField.text!, firstName: self.firstNameTxtField.text!, lastName: self.lastNameTxtField.text!, mobileNumber: self.staticMobileNumber.text!, city: self.cityTxtField.text!, state:"",country:"",image:imgStr ) { (responseDict) in
//                print(responseDict)
//                let status: Int = Int(responseDict.valueForKey("status") as! String)!
//                if status == 1{
//                    dispatch_async(dispatch_get_main_queue(), {
//                        
//                        // NSUserDefaults.standardUserDefaults().setObject(responseDict.valueForKey("state"), forKey: "STATE")
//                        NSUserDefaults.standardUserDefaults().setObject(responseDict.valueForKey("emailId"), forKey: "USER_EMAIL")
//                        NSUserDefaults.standardUserDefaults().setObject(responseDict.valueForKey("firstName"), forKey: "FIRST_NAME")
//                        NSUserDefaults.standardUserDefaults().setObject(responseDict.valueForKey("lastName"), forKey: "LAST_NAME")
//                        NSUserDefaults.standardUserDefaults().setObject(responseDict.valueForKey("UserId"), forKey: "USER_ID")
//                        NSUserDefaults.standardUserDefaults().setObject(responseDict.valueForKey("macId"), forKey: "MAC_ID")
//                        NSUserDefaults.standardUserDefaults().setObject(responseDict.valueForKey("mobile"), forKey: "MOBILE")
//                        NSUserDefaults.standardUserDefaults().setObject(responseDict.valueForKey("address"), forKey: "ADDRESS")
//                        NSUserDefaults.standardUserDefaults().setObject(responseDict.valueForKey("fullName"), forKey: "FULL_NAME")
//                        NSUserDefaults.standardUserDefaults().setObject(responseDict.valueForKey("city"), forKey: "CITY")
//                        NSUserDefaults.standardUserDefaults().setObject(responseDict.valueForKey("orgId"), forKey: "ORG_ID")
//                        NSUserDefaults.standardUserDefaults().setObject(responseDict.valueForKey("macIdJobId"), forKey: "MACID_JOBID")
//                        NSUserDefaults.standardUserDefaults().setObject(responseDict.valueForKey("organisation"), forKey: "ORGANIZATION")
//                        LoadingView.hide()
//                        self.showAlertView("Profile Updated Successfully!!!", status: 1)
//                    })
//                }
//            }
//        }
//        
//        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Destructive) {
//            (UIAlertAction) in
//            
//        }
//        alert.addAction(okAction)
//        alert.addAction(cancelAction)
//        self.presentViewController(alert, animated: true, completion: nil)
//        
//    }
//   
//    @IBAction func saveImageAction(sender: AnyObject) {
//        LoadingView.show("Uploading!!", animated: true)
//        let image = self.editDPImage.image! as UIImage
//        let imageData = NSData(data: UIImagePNGRepresentation(image)!)
//        CXDataService.sharedInstance.imageUpload(imageData) { (Response) in
//            print("\(Response)")
//            
//            let status: Int = Int(Response.valueForKey("status") as! String)!
//            if status == 1{
//                dispatch_async(dispatch_get_main_queue(), {
//                    let imgStr = Response.valueForKey("filePath") as! String
//                    NSUserDefaults.standardUserDefaults().setValue(imgStr, forKey: "IMAGE_PATH")
//                    self.saveImageBtn.hidden = true
//                    LoadingView.hide()
//                    self.showAlertView("Photo Uploaded Successfully!!!", status: 1)
//                    
//                })
//                
//            }
//        }
//        
//    }
//    
//    func editDropDown(){
//        
//        chooseArticleDropDown.anchorView = editDPImage
//        chooseArticleDropDown.anchorView = editBtn
//        chooseArticleDropDown.bottomOffset = CGPoint(x:-10, y:self.editBtn.bounds.size.height+2)
//        chooseArticleDropDown.dataSource = [
//            "Choose from Photos", "Get from Facebook", "Remove profile pic"
//        ]
//        chooseArticleDropDown.selectionAction = {(index, item) in
//            if index == 0{
//                print("choose from photos")
//                let image = UIImagePickerController()
//                image.delegate = self
//                image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
//                image.allowsEditing = false
//                self.presentViewController(image, animated: true, completion: nil)
//                
//            }else if index == 1{
//                print("choose from fb")
//                
//            }else if index == 2{
//                self.editDPImage.image = UIImage(named:"placeholder")
//                self.editDPImage.alpha = 0.4
//                self.saveImageBtn.hidden = false
//            }
//        }
//        
//    }
//    */
//    // MARK: - UIImagePickerControllerDelegate Methods
//    
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
//        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
//            self.saveImageBtn.hidden = false
//            editDPImage.contentMode = .ScaleToFill
//            editDPImage.image = pickedImage
//            editDPImage.alpha = 1
//            editDPImage.backgroundColor = UIColor.clearColor()
//            
//        }
//        
//        dismissViewControllerAnimated(true, completion: nil)
//    }
//    
//    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
//        dismissViewControllerAnimated(true, completion: nil)
//        
//    }
//    
//    func headerViewAlignments(){
//        saveChangesBtn.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
//        stateTxtField.selectedLineColor = CXAppConfig.sharedInstance.getAppTheamColor()
//        cityTxtField.selectedLineColor = CXAppConfig.sharedInstance.getAppTheamColor()
//        addressTxtField.selectedLineColor = CXAppConfig.sharedInstance.getAppTheamColor()
//        firstNameTxtField.selectedLineColor = CXAppConfig.sharedInstance.getAppTheamColor()
//        lastNameTxtField.selectedLineColor = CXAppConfig.sharedInstance.getAppTheamColor()
//        self.editProfileView.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
//        
//        self.editDPImage.layer.cornerRadius = self.editDPImage.frame.size.width / 4
//        self.editDPImage.clipsToBounds = true
//        self.editDPImage.layer.borderWidth = 3.0
//        self.editDPImage.layer.borderColor = UIColor.whiteColor().CGColor
//        
//        let imageUrl = NSUserDefaults.standardUserDefaults().valueForKey("IMAGE_PATH") as? String
//        if (imageUrl != ""){
//            editDPImage.sd_setImageWithURL(NSURL(string: (NSUserDefaults.standardUserDefaults().valueForKey("IMAGE_PATH") as?String)!))
//            editDPImage.alpha = 1
//            editDPImage.backgroundColor = UIColor.clearColor()
//        }else{
//            editDPImage.image = UIImage(named: "placeholder")
//            editDPImage.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
//            editDPImage.alpha = 0.5
//        }
//        
//        
//    }
//    
//    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
//        if textField.tag == 3 {
//            if  range.length==1 && string.characters.count == 0 {
//                return true
//            }
//            if textField.text?.characters.count >= 10 {
//                return false
//            }
//            let invalidCharacters = NSCharacterSet(charactersInString: "0123456789").invertedSet
//            return string.rangeOfCharacterFromSet(invalidCharacters, options: [], range: string.startIndex ..< string.endIndex) == nil
//        }
//        return true
//    }
//    
//    func isValidEmail(email: String) -> Bool {
//        // print("validate email: \(email)")
//        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
//        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
//        if emailTest.evaluateWithObject(email) {
//            return true
//        }
//        return false
//    }
//    // AlertView
//    func showAlertView(message:String, status:Int) {
//        dispatch_async(dispatch_get_main_queue(), {
//            let alert = UIAlertController(title: "Alert!!!", message: message, preferredStyle: UIAlertControllerStyle.Alert)
//            let okAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default) {
//                UIAlertAction in
//                if status == 1 {
//                    self.navigationController?.popToRootViewControllerAnimated(true)
//                }
//            }
//            alert.addAction(okAction)
//            self.presentViewController(alert, animated: true, completion: nil)
//        })
//    }
//    



}
