//
//  ProfileMembershipViewController.swift
//  CoupCon
//
//  Created by Manishi on 10/20/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit
import MagicalRecord


class ProfileMembershipViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate ,UIImagePickerControllerDelegate,UINavigationControllerDelegate, PGTransactionDelegate {
    
    let function = CommonFunctions()
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
    
    let jsonDic : NSMutableDictionary = NSMutableDictionary()
    
    typealias goBackToHomePage = (isGoBack:Bool) -> Void
    var goBackToHomePagecompletion: goBackToHomePage = { reason in print(reason) }
    
    var isFromSidePanel = false
    
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
        
        
        let backItem = UIBarButtonItem(image: UIImage(named: "back-120"), landscapeImagePhone: nil, style:  .Plain, target: self, action: #selector(ProfileMembershipViewController.goBack))
        //   backItem.title = "Back"
        //back-120
        //navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
        self.navigationItem.leftBarButtonItem = backItem
    }
    
    func goBack()
    {
        if isFromSidePanel {
            self.goBackToHomePagecompletion(isGoBack: true)
            
        }else{
            self.goBackToHomePagecompletion(isGoBack: true)
        }
        
        
        
        //        if self.goBackToHomePagecompletion(isGoBack: true){
        //
        //        }else{
        //
        //        }
        
        
    }
    
    func checkTheUserActive(){
        LoadingView.show("Loading...", animated: true)
        CXDataService.sharedInstance.getTheAppDataFromServer(["type" : "macidinfo","mallId" : CXAppConfig.sharedInstance.getAppMallID(),"keyWord":CXAppConfig.sharedInstance.getEmail()]) { (responseDict) in
            //CXAppConfig.sharedInstance.saveTheUserMacIDinfoData(responseDict)
            let array   =  NSMutableArray(array: (responseDict.valueForKey("jobs") as? NSArray!)!)
            if array.count != 0 {
                CXAppConfig.sharedInstance.saveTheUserMacIDinfoData((array.lastObject as? NSDictionary)!)
                LoadingView.hide()
                //if status == "1" {
                let resultArray : NSArray = NSArray(array: (responseDict.valueForKey("jobs") as? NSArray)!)
                if resultArray.count == 0{
                    return
                }
                let macIdDict : NSDictionary = (resultArray.lastObject as? NSDictionary)!
                let userStatus : String = (macIdDict.valueForKey("userStatus") as?String)!
                if userStatus.compare("active", options: .CaseInsensitiveSearch, range: nil, locale: nil) == NSComparisonResult.OrderedSame {
                    //self.stopTheUsrAccessBility(true, titleText: "Your Subscription Valid Till \((macIdDict.valueForKey("ValidTill") as?String)!)")
                    self.subscriptionStatusLbl.text = "Your Subscription Valid Till \(CXAppConfig.sharedInstance.setTheDateFormate((macIdDict.valueForKey("ValidTill") as?String)!))"
                    return
                }else{
                    // self.stopTheUsrAccessBility(false, titleText: "")
                    self.subscriptionStatusLbl.text = "Please Subscribe!!!"
                }
                // }else{
                
                // }
            }
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
        
        dispatch_async(dispatch_get_main_queue(), {
            let imageUrl = NSUserDefaults.standardUserDefaults().valueForKey("IMG_URL")
            if imageUrl != nil{
            self.dpImageView.sd_setImageWithURL(NSURL(string: imageUrl! as! String))
            }
        })
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
        if self.codeTextView.text!.isEmpty {
            self.showAlertView("Please enter code", status: 0)
            
        }else{
            //http://storeongo.com:8081/Services/getMasters?type=Consumer%20Codes&mallId=20217&keyWord=28DIF9
            LoadingView.show("Loading...", animated: true)
            CXDataService.sharedInstance.getTheAppDataFromServer(["type":"Consumer Codes","mallId":CXAppConfig.sharedInstance.getAppMallID(),"keyWord":self.codeTextView.text!]) { (responseDict) in
                //print(responseDict)
                let list : NSArray = NSArray(array: (responseDict.valueForKey("jobs") as? NSArray)!)
                if list.count == 0 {
                    //Code not valid
                    self.showAlertView("Invalid Code", status: 0)
                    LoadingView.hide()
                    
                }else{
                    //Active The User
                    let dic : NSDictionary = (list.lastObject as? NSDictionary)!
                    let jobStatus : String = (dic.valueForKey("Current_Job_Status") as? String)!
                    if jobStatus.compare("Inactive", options: .CaseInsensitiveSearch, range: nil, locale: nil) == NSComparisonResult.OrderedSame {
                        //Show the alert for error code
                        
                        self.showAlertView("Invalid Code", status: 0)
                        LoadingView.hide()
                        
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
                if status == 100{
                }
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
    
    //MARK : Alert for Payment
    func showAlertViewpytm(message:String, status:Int) {
        let alertController = UIAlertController(title: "Payment Mode", message: "", preferredStyle: .Alert)
        let card = UIAlertAction(title: "Credit/Debit Card", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            if (status == 1){
                print(" message \(message)")
               // self.paymoneyfrompaytem(message)
                self.sendThePayMentDetailsToServer("99")
            
            }else if(status == 2){
                self.sendThePayMentDetailsToServer("149")
            
            }else if(status == 3){
                self.sendThePayMentDetailsToServer("249")
            }
        }
        let paytm = UIAlertAction(title: "", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            if (status == 1){
                print(" message \(message)")
               // self.paymoneyfrompaytem(message)
                
            }
        }

        let imageView = UIImageView(frame: CGRectMake(85, 5, 52, 52))
        let view1: UIView = UIView()
        alertController.view.addSubview(view1)
        view1.backgroundColor = UIColor.clearColor()
        view1.frame = CGRectMake(20, 100, 250, 52)
       // imageView.center = CGPoin
        
        let imge: UIImage = UIImage(named: "paytmicon")!
        imageView.image = imge
        view1.addSubview(imageView)
        alertController.addAction(card)
        alertController.addAction(paytm)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    //MARK : paytm integration
    func showController(controller: PGTransactionViewController) {
        
        if self.navigationController != nil {
            self.navigationController!.pushViewController(controller, animated: true)
        }
        else {
            self.presentViewController(controller, animated: true, completion: {() -> Void in
            })
        }
    }
    
    func removeController(controller: PGTransactionViewController) {
        if self.navigationController != nil {
            self.navigationController!.popViewControllerAnimated(true)
        }
        else {
            controller.dismissViewControllerAnimated(true, completion: {() -> Void in
            })
        }
    }
    
    // MARK: Delegate methods of Payment SDK.
    func didSucceedTransaction(controller: PGTransactionViewController, response: [NSObject : AnyObject]) {
        
        // After Successful Payment
        
        print("ViewController::didSucceedTransactionresponse= %@", response)
        let msg: String = "Your order was completed successfully.\n Rs. \(response["TXNAMOUNT"]!)"
        
        self.function.alert_for("Thank You for Payment", message: msg)
        self.removeController(controller)
        
    }
    
    func didFailTransaction(controller: PGTransactionViewController, error: NSError, response: [NSObject : AnyObject]) {
        // Called when Transation is Failed
        print("ViewController::didFailTransaction error = %@ response= %@", error, response)
        
        if response.count == 0 {
            
            self.function.alert_for(error.localizedDescription, message: response.description)
            
        }
        else if error != 0 {
            
            self.function.alert_for("Error", message: error.localizedDescription)
            
            
        }
        
        self.removeController(controller)
        
    }
    
    func didCancelTransaction(controller: PGTransactionViewController, error: NSError, response: [NSObject : AnyObject]) {
        
        //Cal when Process is Canceled
        var msg: String? = nil
        
        if error != 0 {
            
            msg = String(format: "Successful")
        }
        else {
            msg = String(format: "UnSuccessful")
        }
        
        
       
        self.function.alert_for("Transaction Cancel", message: msg!)
        
        self.removeController(controller)
        
    }
    
    func didFinishCASTransaction(controller: PGTransactionViewController, response: [NSObject : AnyObject]) {
        
        print("ViewController::didFinishCASTransaction:response = %@", response);
        
    }
    
    
    func paymoneyfrompaytem(amount: String){
        
        //Step 1: Create a default merchant config object
        let mc: PGMerchantConfiguration = PGMerchantConfiguration.defaultConfiguration()
        
        //Step 2: If you have your own checksum generation and validation url set this here. Otherwise use the default Paytm urls
        
        mc.checksumGenerationURL = "https://pguat.paytm.com/paytmchecksum/paytmCheckSumGenerator.jsp"
        mc.checksumValidationURL = "https://pguat.paytm.com/paytmchecksum/paytmCheckSumVerify.jsp"
        
        //Step 3: Create the order with whatever params you want to add. But make sure that you include the merchant mandatory params
        let orderDict = NSMutableDictionary()
        
        orderDict["MID"] = "WorldP64425807474247"
        //Merchant configuration in the order object
        orderDict["CHANNEL_ID"] = "WAP"
        orderDict["INDUSTRY_TYPE_ID"] = "Retail"
        orderDict["WEBSITE"] = "worldpressplg"
        //Order configuration in the order object
        orderDict["TXN_AMOUNT"] = amount
        orderDict["ORDER_ID"] = ProfileMembershipViewController.generateOrderIDWithPrefix("")
        orderDict["REQUEST_TYPE"] = "DEFAULT"
        orderDict["CUST_ID"] = "1234567890"
        
        let order: PGOrder = PGOrder(params: orderDict as! [NSObject : AnyObject])
        
        print("oder list is \(order)")
        //Step 4: Choose the PG server. In your production build dont call selectServerDialog. Just create a instance of the
        //PGTransactionViewController and set the serverType to eServerTypeProduction
        PGServerEnvironment.selectServerDialog(self.view, completionHandler: {(type: ServerType) -> Void in
            
            let txnController = PGTransactionViewController.init(transactionForOrder: order)
            
            
            if type != eServerTypeNone {
                txnController.serverType = type
                txnController.merchant = mc
                txnController.delegate = self
                self.showController(txnController)
            }
        })
        
        
    }
    
    class func generateOrderIDWithPrefix(prefix: String) -> String {
        
        srandom(UInt32(time(nil)))
        
        let randomNo: Int = random();        //just randomizing the number
        let orderID: String = "\(prefix)\(randomNo)"
        return orderID
        
    }
   @IBAction func oneMonthAccessBtnAction(sender: AnyObject) {
        //  http://test.com:9000/PaymentGateway/payments?name=&email=&amount=100&description=Test&phone=&macId=&mallId=
       // self.sendThePayMentDetailsToServer("99")
        showAlertViewpytm("99", status: 1)
        
        
    }
    @IBAction func sixMonthsAccessBtnAction(sender: AnyObject) {
        
        showAlertViewpytm("149", status: 2)
        //self.sendThePayMentDetailsToServer("149")
    }
    @IBAction func oneYearAccessBtnAction(sender: AnyObject) {
        
        showAlertViewpytm("249", status: 3)
       // self.sendThePayMentDetailsToServer("249")
        
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
    
    //Change Profile Picture Action
    @IBAction func editProfilePicAction(sender: AnyObject) {
        imagePickerAction()
    }
    
    func imagePickerAction(){
        
        //Create the AlertController and add Its action like button in Actionsheet
        let choosePhotosActionSheet: UIAlertController = UIAlertController(title: "Select An Option", message: nil , preferredStyle: .ActionSheet)
        
        let chooseFromPhotos: UIAlertAction = UIAlertAction(title: "Choose From Photos", style: .Default)
        { action -> Void in
            print("choose from photos")
            let image = UIImagePickerController()
            image.delegate = self
            image.sourceType = .PhotoLibrary
            image.allowsEditing = false
            self.presentViewController(image, animated: true, completion: nil)
        }
        choosePhotosActionSheet.addAction(chooseFromPhotos)
        
        let capturePicture: UIAlertAction = UIAlertAction(title: "Capture Image", style: .Default)
        { action -> Void in
            print("camera shot")
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = false
            picker.sourceType = .Camera
            picker.cameraCaptureMode = .Photo
            picker.modalPresentationStyle = .FullScreen
            self.presentViewController(picker, animated: true, completion: nil)
        }
        choosePhotosActionSheet.addAction(capturePicture)
        
        
        let cancel: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel)
        { action -> Void in
            
        }
        choosePhotosActionSheet.addAction(cancel)
        
        self.presentViewController(choosePhotosActionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            dpImageView.contentMode = .ScaleToFill
            dpImageView.image = pickedImage
            let image = pickedImage as UIImage
            
            let imageData = NSData(data: UIImageJPEGRepresentation(image.correctlyOrientedImage(), 0.2)!)
            NSUserDefaults.standardUserDefaults().setObject(imageData, forKey: "IMG_DATA")
            uploadPIc()
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func uploadPIc(){
        
        LoadingView.show("Loading...", animated: true)
        let imageData = NSUserDefaults.standardUserDefaults().valueForKey("IMG_DATA") as? NSData
        LoadingView.show("Updating...", animated: true)
        
        if imageData != nil {
            CXDataService.sharedInstance.imageUpload(imageData!, completion: { (Response) in
                print(Response)
                let status: Int = Int(Response.valueForKey("status") as! String)!
                if status == 1{
                    let urlStr = Response.valueForKey("filePath") as! String
                    self.jsonDic.setObject(urlStr, forKey: "Image")
                    
                    var jsonData : NSData = NSData()
                    do {
                        jsonData = try NSJSONSerialization.dataWithJSONObject(self.jsonDic, options: .PrettyPrinted)
                        
                    } catch let error as NSError {
                        print("json error: \(error.localizedDescription)")
                    }
                    
                    let jsonStringFormat = String(data:jsonData as NSData, encoding: NSUTF8StringEncoding)
                    print(jsonStringFormat)
                    
                    CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getUpdatedUserDetails(), parameters: ["jobId":CXAppConfig.sharedInstance.getMacJobID() as AnyObject,"jsonString":jsonStringFormat! ,"ownerId":CXAppConfig.sharedInstance.getAppMallID() as AnyObject]) { (responseDic) in
                        print(responseDic)
                        let status: Int = Int(responseDic.valueForKey("status") as! String)!
                        if status == 1{
                            self.showAlertView("Profile Picture Successfully Updated!!!", status: 100)
                            let imageStr = self.jsonDic.valueForKey("Image")
                            NSUserDefaults.standardUserDefaults().setObject(imageStr as! String, forKey: "IMG_URL")
                            
                        }else{
                            self.showAlertView("Something went wrong! Try again later.", status: 0)
                        }
                    }
                }
            })
        }else{
            
        }
    }
}


extension UIImage{
    
    func correctlyOrientedImage() -> UIImage {
        if self.imageOrientation == UIImageOrientation.Up {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.drawInRect(CGRectMake(0, 0, self.size.width, self.size.height))
        let normalizedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return normalizedImage;
    }
}