//
//  ProfileMembershipViewController.swift
//  CoupCon
//
//  Created by Manishi on 10/20/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit

class ProfileMembershipViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var oneYearBtn: UIButton!
    @IBOutlet weak var sixMonthsBtn: UIButton!
    @IBOutlet weak var threeMonthsBtn: UIButton!
    @IBOutlet weak var oneMonthBtn: UIButton!
    @IBOutlet weak var dpImageView: UIImageView!
    @IBOutlet weak var detailsTableView: UITableView!
    
    @IBOutlet weak var subscribeBtn: UIButton!
    @IBOutlet weak var codeTextView: UITextField!
    @IBOutlet weak var MemberShipLbl: UILabel!
    
    @IBOutlet weak var subscriptionStatusLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        membershipBtnLabels()
        
        codeTextView.delegate = self
        self.automaticallyAdjustsScrollViewInsets = false
        let nib = UINib(nibName: "membershipTableViewCell", bundle: nil)
        self.detailsTableView.registerNib(nib, forCellReuseIdentifier: "membershipTableViewCell")
        self.view.backgroundColor = CXAppConfig.sharedInstance.getAppBGColor()
        self.setUPTheNavigationProperty()
        self.setUpSideMenu()
        self.detailsTableView.removeFromSuperview()
       self.checkTheUserActive()
        self.subscribeBtn.layer.cornerRadius = 8.0
    }
    
    func checkTheUserActive(){
        LoadingView.show("Loading...", animated: true)
        CXDataService.sharedInstance.getTheAppDataFromServer(["type" : "macidinfo","mallId" : CXAppConfig.sharedInstance.getAppMallID(),"keyWord":CXAppConfig.sharedInstance.getEmail()]) { (responseDict) in
            //CXAppConfig.sharedInstance.saveTheUserMacIDinfoData(responseDict)
            let array   =  NSMutableArray(array: (responseDict.valueForKey("jobs") as? NSArray!)!)
            CXAppConfig.sharedInstance.saveTheUserMacIDinfoData((array.lastObject as? NSDictionary)!)
            
            LoadingView.hide()
            //if status == "1" {
            let resultArray : NSArray = NSArray(array: (responseDict.valueForKey("jobs") as? NSArray)!)
            let macIdDict : NSDictionary = (resultArray.lastObject as? NSDictionary)!
                let userStatus : String = (macIdDict.valueForKey("userStatus") as?String)!
                if userStatus.compare("active", options: .CaseInsensitiveSearch, range: nil, locale: nil) == NSComparisonResult.OrderedSame {
                    //self.stopTheUsrAccessBility(true, titleText: "Your Subscription Valid Till \((macIdDict.valueForKey("ValidTill") as?String)!)")
                    self.subscriptionStatusLbl.text = "Your Subscription Valid Till \((macIdDict.valueForKey("ValidTill") as?String)!)"
                    return
                }else{
                   // self.stopTheUsrAccessBility(false, titleText: "")
                    self.subscriptionStatusLbl.text = "Please Subscribe!!!"
            }
           // }else{
            
           // }
            
        }

        
     /*  // http://storeongo.com:8081/MobileAPIs/userVerification?mallId=20217&consumerEmail=cxsample@gmail.com
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile("http://storeongo.com:8081/MobileAPIs/userVerification?", parameters: ["consumerEmail":CXAppConfig.sharedInstance.getEmail(),"mallId":CXAppConfig.sharedInstance.getAppMallID()]) { (responseDict) in
            print(responseDict)
            let status : String = (responseDict.valueForKey("status") as?String)!
            if status == "1" {
                let userStatus : String = (responseDict.valueForKey("userStatus") as?String)!
                if userStatus.compare("active", options: .CaseInsensitiveSearch, range: nil, locale: nil) == NSComparisonResult.OrderedSame {
                    self.stopTheUsrAccessBility(true, titleText: "Your subscription valid Till")
                    
                    return
                }
            }else{
                self.stopTheUsrAccessBility(false, titleText: "")

            }
        }*/
    }
    //Your subscription valid Till
    
    
    func stopTheUsrAccessBility(isAccess:Bool,titleText:String){
        if isAccess == true{
            //Add the black transperent view with label for valid date
            let transperentView:UIView = UIView(frame: self.view.frame)
            transperentView.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.8)
            self.view.addSubview(transperentView)
            self.view.userInteractionEnabled = false
            let validLbl : UILabel = UILabel(frame:CGRect(x: 50, y: 0, width: UIScreen.mainScreen().bounds.size.width, height: 50) )
            transperentView.addSubview(validLbl)
            validLbl.text = titleText
            validLbl.textAlignment = NSTextAlignment.Center
            validLbl.textColor = UIColor.whiteColor()
            validLbl.center = CGPoint(x: UIScreen.mainScreen().bounds.size.width/2, y: UIScreen.mainScreen().bounds.size.height/2)
        
        }else{
            
        }
    }
    
    
    
    
    func membershipBtnLabels(){
        
        let appdata:NSArray = UserProfile.MR_findAll() as NSArray
        let userProfileData:UserProfile = appdata.lastObject as! UserProfile
        
        let imageUrl = userProfileData.userPic
        if (imageUrl != ""){
            dpImageView.sd_setImageWithURL(NSURL(string: imageUrl!))
        }
        self.dpImageView.layer.borderColor = UIColor.whiteColor().CGColor
        self.dpImageView.layer.cornerRadius = 73
        self.dpImageView.layer.borderWidth = 5
        self.dpImageView.clipsToBounds = true

    }
    
    func setUpSideMenu(){
        
        let menuItem = UIBarButtonItem(image: UIImage(named: "sidePanelMenu"), style: .Plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
        menuItem.tintColor = UIColor.whiteColor()
        
        self.navigationItem.leftBarButtonItem = menuItem
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        let navigation:UINavigationItem = navigationItem
        navigation.title  = "Profile & Membership"
        //self.sideMenuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), forControlEvents: .TouchUpOutside)
    }
    
    func setUPTheNavigationProperty(){
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController!.navigationBar.barTintColor = CXAppConfig.sharedInstance.getAppTheamColor()
        //self.view.backgroundColor = UIColor.whiteColor()
        
        /* navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
         navigationController?.navigationBar.shadowImage = UIImage()
         navigationController?.navigationBar.translucent = true*/
        
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
      
        
        return 2
        
    }
    

    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField.maxLength == 6{
           // print("its 6 chars \(textField.text!)")
        }
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func inActiveTheJob(parameterDic:NSDictionary,jobId:String){
        
        var jsonData : NSData = NSData()
        do {
            jsonData = try NSJSONSerialization.dataWithJSONObject(parameterDic, options: NSJSONWritingOptions.PrettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
        } catch let error as NSError {
            print(error)
        }
        let jsonStringFormat = String(data: jsonData, encoding: NSUTF8StringEncoding)
        
        CX_SocialIntegration.sharedInstance.updateTheSaveConsumerProperty(["ownerId":CXAppConfig.sharedInstance.getAppMallID(),"jobId":jobId,"jsonString":jsonStringFormat!]) { (resPonce) in
            self.navigationController?.popToRootViewControllerAnimated(true)
            
        }
        
        //http://storeongo.com:8081/MobileAPIs/changeJobStatus?providerEmail=kushalkanna@gmail.com&mallId=17018&jobId=177971&jobStatusId=167192
    }
    
    func activeTheUser(parameterDic:NSDictionary,jobId:String){
        var jsonData : NSData = NSData()
        do {
            jsonData = try NSJSONSerialization.dataWithJSONObject(parameterDic, options: NSJSONWritingOptions.PrettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
        } catch let error as NSError {
            print(error)
        }
        let jsonStringFormat = String(data: jsonData, encoding: NSUTF8StringEncoding)
      
        
        //We change api call after payment last on 21/12/2016
        
        /*
         After payment call this API
         http://localhost:8081/MobileAPIs/createOrUpdateSubscription?mallId=6&consumerEmail=satyasasi.b@gmail.com&months=3&amount=99
         
         parameters :
         mallID =
         consumerEmail = mail id
         Month =  1,6,12 for one month ,six months and one year respectively .
         amount =
         */
        
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getcreateOrUpdateSubscriptionUrl(), parameters: ["mallId":"","consumerEmail":"","months":"","amount":""]) { (responseDict) in
            
        }
        
        CX_SocialIntegration.sharedInstance.updateTheSaveConsumerProperty(["ownerId":CXAppConfig.sharedInstance.getAppMallID(),"jobId":jobId,"jsonString":jsonStringFormat!]) { (resPonce) in     0
            self.checkTheUserActive()
            self.navigationController?.popToRootViewControllerAnimated(true)
            
        }
        
            //    http://storeongo.com:8081/MobileAPIs/updateMultipleProperties/jobId=200400&jsonString={"PaymentType":"249","ValidTill":"11-11-2017","userStatus":"active"}&ownerId=20217
    }
    
    func updateTheUserSubscription(month:String,amount:String,code:String,isOfflineSbscribe:Bool){
        
        //We change api call after payment last on 21/12/2016
        
        /*
         After payment call this API
         http://localhost:8081/MobileAPIs/createOrUpdateSubscription?mallId=6&consumerEmail=satyasasi.b@gmail.com&months=3&amount=99
         
         parameters :
         mallID =
         consumerEmail = mail id
         Month =  1,6,12 for one month ,six months and one year respectively .
         amount =
         */
        
        var postDic = ["mallId":CXAppConfig.sharedInstance.getAppMallID(),"consumerEmail":CXAppConfig.sharedInstance.getEmail(),"months":month,"amount":amount]
        
        if isOfflineSbscribe {
           postDic = ["mallId":CXAppConfig.sharedInstance.getAppMallID(),"consumerEmail":CXAppConfig.sharedInstance.getEmail(),"months":month,"amount":amount,"ConsumerCode":code]
        }
        
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getcreateOrUpdateSubscriptionUrl(), parameters: postDic) { (responseDict) in
            self.checkTheUserActive()
            self.codeTextView.text = ""
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
        
        
    }
    
    @IBAction func subscribeBtnAction(sender: AnyObject) {
        //http://storeongo.com:8081/Services/getMasters?type=Consumer%20Codes&mallId=20217&keyWord=28DIF9
        LoadingView.show("Loading...", animated: true)
        CXDataService.sharedInstance.getTheAppDataFromServer(["type":"Consumer Codes","mallId":CXAppConfig.sharedInstance.getAppMallID(),"keyWord":self.codeTextView.text!]) { (responseDict) in
            //print(responseDict)
            let list : NSArray = NSArray(array: (responseDict.valueForKey("jobs") as? NSArray)!)
            if list.count == 0 {
                //Code not valid
                self.showAlertView("Invalid Code", status: 0)

            }else{
                //Active The User
                let dic : NSDictionary = (list.lastObject as? NSDictionary)!
                let jobStatus : String = (dic.valueForKey("Current_Job_Status") as? String)!
                if jobStatus.compare("Inactive", options: .CaseInsensitiveSearch, range: nil, locale: nil) == NSComparisonResult.OrderedSame {
                    //Show the alert for error code
                    
                    self.showAlertView("Invalid Code", status: 0)
                    
                    return
                }
                
                let payMent : String = dic.valueForKey("SubscriptionType")! as! String
                var validTill : String = String()
                let jsondDic : NSMutableDictionary = NSMutableDictionary()
                jsondDic.setObject(dic.valueForKey("SubscriptionType")!, forKey: "PaymentType")
                var month : String = String()
                var amount : String = String()

                if (payMent == "RS99") {
                    amount = "99"
                    month = "1"
                    //One Month
                   // validTill = CXAppConfig.sharedInstance.getExpiresDate(0) as String
                }else if (payMent == "RS149") {
                    //six Months
                    amount = "149"
                    month = "6"
                    //validTill = CXAppConfig.sharedInstance.getExpiresDate(1) as String
                    
                }else if (payMent == "RS249") {
                    //One Year
                    amount = "249"
                    month = "12"
                    //validTill = CXAppConfig.sharedInstance.getExpiresDate(2) as String
                    
                }
                
                //jsondDic.setObject("Active", forKey: "userStatus")
                //jsondDic.setObject(validTill, forKey: "ValidTill")
                
               // self.activeTheUser(jsondDic, jobId:CXAppConfig.sharedInstance.getMacJobID())
                
               // self.updateTheUserSubscription(month, amount: amount)
                //"Code"
                self.updateTheUserSubscription(month, amount: amount, code: dic.valueForKey("Code")! as! String, isOfflineSbscribe: true)

                
                // inactive the job also key is Current_Job_Status
                
               // let inactivedic : NSMutableDictionary = NSMutableDictionary()
              //  inactivedic.setObject(dic.valueForKey("jobTypeId")!, forKey: "PaymentType")
          
                //inactivedic.setObject("11-11-2017", forKey: "ValidTill")
                //inactivedic.setObject("Inactive", forKey: "Current_Job_Status")
                ///self.inActiveTheJob(inactivedic, jobId:"200105") 
                
                //This below Api call for Deactive the Code
                //jobStatusId  from "Next_Job_Statuses" -> "Status_Id" in comsumer code
                let nextJobStatus = dic.valueForKey("Next_Job_Statuses") as? NSArray
                let statusIDdic = nextJobStatus?.lastObject as?NSDictionary
                CXDataService.sharedInstance.synchDataToServerAndServerToMoblile("\(CXAppConfig.sharedInstance.getBaseUrl())MobileAPIs/changeJobStatus?", parameters: ["providerEmail":CXAppConfig.sharedInstance.getEmail(),"mallId":CXAppConfig.sharedInstance.getAppMallID(),"jobId":CXAppConfig.resultString(dic.valueForKey("id")!),"jobStatusId":statusIDdic!.valueForKeyPath("Status_Id")!]) { (responseDict) in
                }
                //SubscriptionType
            }
            
            LoadingView.hide()
        }
        
        /*
         CXDataService.sharedInstance.getTheAppDataFromServer(["type":"Consumer Codes","mallId":CXAppConfig.sharedInstance.getAppMallID(),"keyWord":self.codeTextView.text!]) { (responseDict) in
         
         print(Dictionary)
         }
         */
    }
    
    
    func showAlertView(message:String, status:Int) {
        dispatch_async(dispatch_get_main_queue(), {
            let alert = UIAlertController(title: "CoupCon", message: message, preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default) {
                UIAlertAction in

            }
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true, completion: nil)
        })
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
        
    {
       let cell = tableView.dequeueReusableCellWithIdentifier("membershipTableViewCell", forIndexPath: indexPath) as! membershipTableViewCell
        
        detailsTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        detailsTableView.allowsSelection = false
        
        let appdata:NSArray = UserProfile.MR_findAll() as NSArray
        let userProfileData:UserProfile = appdata.lastObject as! UserProfile
        
        if indexPath.row == 0{
            
            cell.nameLbl.text = CXAppConfig.sharedInstance.getPhoneNumber()
            cell.descriptionLbl.text = "Phone"
            cell.imageLbl.setImage(UIImage(named: "phone20"), forState:.Normal)

        }else if indexPath.row == 1{
            cell.nameLbl.text = userProfileData.emailId! as String
            cell.descriptionLbl.text = "Email"
            cell.imageLbl.setImage(UIImage(named: "mail20"), forState:.Normal)
            
        }else if indexPath.row == 2{
            cell.nameLbl.text = "sureshyadavalli93"
            cell.descriptionLbl.text = "Skype"
            cell.imageLbl.setImage(UIImage(named: "skype20"), forState:.Normal)
            
        }
        return cell
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 70
        
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false
    }
    
    @IBAction func oneMonthAccessBtnAction(sender: AnyObject) {
      //  http://test.com:9000/PaymentGateway/payments?name=&email=&amount=100&description=Test&phone=&macId=&mallId=
        self.sendThePayMentDetailsToServer("99")

   
        
    }
    @IBAction func sixMonthsAccessBtnAction(sender: AnyObject) {
        
        self.sendThePayMentDetailsToServer("149")
    }
    @IBAction func oneYearAccessBtnAction(sender: AnyObject) {
        self.sendThePayMentDetailsToServer("249")
        
    }
    
    func sendThePayMentDetailsToServer(amount:String){
        let userProfileData:UserProfile = CXAppConfig.sharedInstance.getTheUserDetails()
        LoadingView.show("Loading...", animated: true)
        //http://test.com:9000/OngoStoresPG/coupoconPG?name=vinodha&email=vinodhapudari@gmail.com&amount=10&description=Test%20api&phone=9660008880&macId=101&mallId=2
        
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getPaymentGateWayUrl(), parameters: ["name":userProfileData.firstName!,"email":userProfileData.emailId!,"amount":amount,"description":"Coupocon Payment","phone":CXAppConfig.sharedInstance.getPhoneNumber(),"macId":userProfileData.macId!,"mallId":CXAppConfig.sharedInstance.getAppMallID()]) { (responseDict) in
           // print(responseDict.valueForKey("payment_url"))
            let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let profileView = storyBoard.instantiateViewControllerWithIdentifier("CXPayMentController") as! CXPayMentController
            profileView.paymentUrl =  NSURL(string: responseDict.valueForKey("payment_url")! as! String)
            profileView.completion = { _ in responseDict
                //let payMent : String = dic.valueForKey("SubscriptionType")! as! String
                var month : String = String()
                let jsondDic : NSMutableDictionary = NSMutableDictionary()
                jsondDic.setObject(amount, forKey: "PaymentType")
                if (amount == "99") {
                    month = "1"
                    //One Month
                  //  validTill = CXAppConfig.sharedInstance.getExpiresDate(0) as String
                }else if (amount == "149") {
                    //six Months
                    month = "6"
                   // validTill = CXAppConfig.sharedInstance.getExpiresDate(1) as String
                }else if (amount == "249") {
                    //One Year
                    month = "12"
                    //validTill = CXAppConfig.sharedInstance.getExpiresDate(2) as String
                }
               // jsondDic.setObject("Active", forKey: "userStatus")
               // jsondDic.setObject(validTill, forKey: "ValidTill")
               // self.activeTheUser(jsondDic, jobId:CXAppConfig.sharedInstance.getMacJobID())
                
               // self.updateTheUserSubscription(month, amount: amount)
                self.updateTheUserSubscription(month, amount: amount, code: "", isOfflineSbscribe: false)
            }
            
            profileView.goBackcompletion = { _ in
                self.navigationController?.popViewControllerAnimated(true)
            }
            
            let backItem = UIBarButtonItem()
            self.title = ""
            self.navigationController?.navigationItem.backBarButtonItem = backItem
            
            self.navigationController?.pushViewController(profileView, animated: true)
              LoadingView.hide()
        }
        
        
    }
    
    
    
    
}
