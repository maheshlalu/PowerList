//
//  ReedemViewController.swift
//  CoupoConLoginScreen
//
//  Created by Rama kuppa on 20/10/16.
//  Copyright © 2016 Mahesh. All rights reserved.
//

import UIKit

class ReedemViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate  {
    
    @IBOutlet weak var enterRedeemCodeLbl: UILabel!
    @IBOutlet weak var RedeemTableView: UITableView!
    @IBOutlet weak var textField6: UITextField!
    @IBOutlet weak var textField5: UITextField!
    @IBOutlet weak var backgroundImg: UIImageView!
    
    @IBOutlet weak var codeStackView: UIStackView!
    @IBOutlet weak var textField4: UITextField!
    @IBOutlet weak var textF3: UITextField!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var textField1: UITextField!
    
    @IBOutlet weak var tableviewHeight: NSLayoutConstraint!
    @IBOutlet weak var yourRedeemHistoryLbl: UILabel!
    var showBackBtn:Bool! = false
    let TEXT_FIELD_LIMIT = 1
    var redeemHistoryJobsArr:NSArray! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField1.delegate = self
        textField2.delegate = self
        textF3.delegate = self
        textField4.delegate = self
        textField5.delegate = self
        textField6.delegate = self

        let nib = UINib(nibName: "RedeemTableViewCell", bundle: nil)
        self.RedeemTableView.registerNib(nib, forCellReuseIdentifier: "RedeemTableViewCell")
        self.setUPTheNavigationProperty()
        
        self.redeemHistoryJobsArr = NSArray()
        self.redeemViewAligner()
        redeemHistoryApiCall()
        
        textField1.addTarget(self, action: #selector(ReedemViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        textField2.addTarget(self, action: #selector(ReedemViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        textF3.addTarget(self, action: #selector(ReedemViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        textField4.addTarget(self, action: #selector(ReedemViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        textField5.addTarget(self, action: #selector(ReedemViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        textField6.addTarget(self, action: #selector(ReedemViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        
    }
    
    func redeemViewAligner(){
        
        if showBackBtn == true{
            
            navigationItem.backBarButtonItem?.tintColor = UIColor.grayColor()
            navigationItem.hidesBackButton = false
            RedeemTableView.separatorStyle = .None

        }else{
            navigatingFromSidePanel()
        }
        
    }
    
    func navigatingFromSidePanel() {
        
        enterRedeemCodeLbl.text = "YOUR REDEEM HISTORY"
        codeStackView.hidden = true
        yourRedeemHistoryLbl.hidden = true
        self.RedeemTableView.removeFromSuperview()
        
        var redeem:UITableView = self.RedeemTableView
        redeem = UITableView(frame: CGRectMake(10,self.enterRedeemCodeLbl.frame.size.height+enterRedeemCodeLbl.frame.origin.y+(self.navigationController?.navigationBar.frame.size.height)!+20 ,self.view.frame.size.width-20, (self.view.frame.size.height)), style: UITableViewStyle.Plain)
        redeem.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0);
        redeem.delegate = self
        redeem.dataSource = self
        redeem.backgroundColor = UIColor.clearColor()
        redeem.separatorStyle = .None
        let nib = UINib(nibName: "RedeemTableViewCell", bundle: nil)
        redeem.registerNib(nib, forCellReuseIdentifier: "RedeemTableViewCell")
        self.backgroundImg.addSubview(redeem)
        self.RedeemTableView = redeem
        self.setUpSideMenu()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
    
    func setUpSideMenu(){
        
        let menuItem = UIBarButtonItem(image: UIImage(named: "sidePanelMenu"), style: .Plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
        menuItem.tintColor = UIColor.grayColor()
        self.navigationItem.leftBarButtonItem = menuItem
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        //self.sideMenuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), forControlEvents: .TouchUpOutside)
    }
    
    func setUPTheNavigationProperty(){
        
        navigationController?.setNavigationBarHidden(false, animated: true)
       /* navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.translucent = true*/
        
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return self.redeemHistoryJobsArr.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("RedeemTableViewCell", forIndexPath: indexPath) as! RedeemTableViewCell
        RedeemTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        let categoryDic : NSDictionary = self.redeemHistoryJobsArr[indexPath.section] as! NSDictionary
        
        cell.redeemImageView.sd_setImageWithURL(NSURL(string:categoryDic.valueForKey("ProductImage") as! String))
        cell.redeemLogo.sd_setImageWithURL(NSURL(string: categoryDic.valueForKey("productLogo") as! String))
        cell.redeemLbl.text = "\(categoryDic.valueForKey("OfferName")!)"
        cell.redeemPercentLbl.text = "\(categoryDic.valueForKey("OfferName")!)"
        
        return cell
        
        
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        tableView.rowHeight = 150
        return 150
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func textFieldDidChange(textField: UITextField){
        textField.text = textField.text?.uppercaseString

        let text = textField.text
        
        if text?.utf16.count==1{
            switch textField{
            case textField1:
                textField2.becomeFirstResponder()
                
            case textField2:
                textF3.becomeFirstResponder()
                
            case textF3:
                textField4.becomeFirstResponder()
                
            case textField4:
                textField5.becomeFirstResponder()
                
            case textField5:
                textField6.becomeFirstResponder()
                
            case textField6:
                
                let Code = "\(textField1.text!)\(textField2.text!)\(textF3.text!)\(textField4.text!)\(textField5.text!)\(textField6.text!)"
                let codeStr = Code.uppercaseString
                let jsonListArray : NSMutableArray = NSMutableArray()
                jsonListArray.addObject(CXAppConfig.sharedInstance.getRedeemDictionary())
                
                let OfferCode = jsonListArray.valueForKeyPath("OfferCode") as! NSArray
                let offerCodeStr = OfferCode[0] as! String
                //OCS72K
                if (offerCodeStr != ""){
                    if offerCodeStr == codeStr{
                        textField6.resignFirstResponder()
                        print("Code is Equal to OfferCode")
                        self.offerReedem()
                    }else{
                        self.showAlertView("Please Check Code Once!!!", status: 0)
                    }
                }else{
                     textField6.resignFirstResponder()
                    print("OfferCode is not available")
                }
                
            default:
                break
            }
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
        
    {
       return (textField.text?.utf16.count ?? 0) + string.utf16.count - range.length <= TEXT_FIELD_LIMIT
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool // return NO to disallow editing.
    {
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }
    
    
    //http://storeongo.com:8081/Services/getMasters?mallId=20217&type= RedeemHistory&refTypeProperty1=MacId&refId1=195735
    //http://storeongo.com:8081/Services/getMasters?mallId=20217&type=RedeemHistory&refTypeProperty1=MacId&refId1=197024
    func redeemHistoryApiCall(){
        LoadingView.show("Loading...", animated: true)
        CXDataService.sharedInstance.getTheAppDataFromServer(["type":"RedeemHistory","mallId":CXAppConfig.sharedInstance.getAppMallID(),"refTypeProperty1":"MacId","refId1":CXAppConfig.sharedInstance.getTheUserData().macIdJobId]) { (responseDict) in
            print(responseDict)
            self.redeemHistoryJobsArr = responseDict.valueForKey("jobs") as! NSArray
            print(self.redeemHistoryJobsArr.count)
            self.RedeemTableView.reloadData()
            LoadingView.hide()
            
        }
    }
    
    
    func offerReedem(){
        LoadingView.show("Loading...", animated: true)

        /*
         json={"list"":[{"ProductName":"Tabla","ProductDescription":"description","ProductImage":"https://s3-ap-southeast-1.amazonaws.com/storeongocontent/jobs/jobFldAttachments/20217_1477488244540.png","OfferName":"25 off on lunch","ProductId":"196429","OfferId":"9876543210","MacId":"102716-BHJAFCFH"}]}&dt=CAMPAIGNS&category=Notifications&userId=20217&consumerEmail=cxsample@gmail.com
         
         */
//        let jsonDic : NSMutableDictionary = NSMutableDictionary()
//        jsonDic.setObject("Club Republic", forKey: "ProductName")
//        //jsonDic.setObject("23", forKey: "ProductDescription")
//        jsonDic.setObject("https://s3-ap-southeast-1.amazonaws.com/storeongocontent/jobs/jobFldAttachments/20217_1477388128490.jpg", forKey: "ProductImage")
//        jsonDic.setObject("10% off on total bill", forKey: "OfferName")
//        jsonDic.setObject("196243", forKey: "ProductId")
//        jsonDic.setObject("itemcode_5", forKey: "OfferId")
//        jsonDic.setObject(CXAppConfig.sharedInstance.getTheUserData().macId, forKey: "MacId")
        
        let jsonListArray : NSMutableArray = NSMutableArray()
        
        jsonListArray.addObject(CXAppConfig.sharedInstance.getRedeemDictionary())
        
        let listDic : NSDictionary = NSDictionary(object: jsonListArray, forKey: "list")
        print(listDic)
        
        var jsonData : NSData = NSData()
        do {
            jsonData = try NSJSONSerialization.dataWithJSONObject(listDic, options: NSJSONWritingOptions.PrettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
        } catch let error as NSError {
            print(error)
        }
        let jsonStringFormat = String(data: jsonData, encoding: NSUTF8StringEncoding)
        
        print(jsonStringFormat)

        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getPlaceOrderUrl(), parameters: ["type":"RedeemHistory","json":jsonStringFormat!,"dt":"CAMPAIGNS","category":"Notifications","userId":CXAppConfig.sharedInstance.getAppMallID(),"consumerEmail":CXAppConfig.sharedInstance.getTheUserData().userEmail]) { (responseDict) in
            print(responseDict)
            let string = responseDict.valueForKeyPath("myHashMap.status") as! String
            print(string)
            
            if string == "1"{
                self.showAlertView("Product Redeemed Successfully!!!", status: 1)
            }
            LoadingView.hide()
        }
        
    }
    
    func showAlertView(message:String, status:Int) {
        dispatch_async(dispatch_get_main_queue(), {
            let alert = UIAlertController(title: "CoupCon", message: message, preferredStyle: UIAlertControllerStyle.Alert)
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
    
}
