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
        
    }
    
    func redeemViewAligner(){
        
        if showBackBtn == true{
            navigationItem.backBarButtonItem?.tintColor = UIColor.grayColor()
            navigationItem.hidesBackButton = false
            codeStackView.hidden = false
            
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
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.translucent = true
        
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
        cell.redeemLogo.sd_setImageWithURL(NSURL(string: categoryDic.valueForKey("ProductDescription") as! String))
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
        return 10
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        /*textField.returnKeyType = UIReturnKeyType.done
         self.view.endEditing(true)
         return true*/
        
        if textField == textField1
        {
            
            textField.resignFirstResponder()
            textField2.becomeFirstResponder()
        }
            
        else if textField == textField2
        {
            
            textField.resignFirstResponder()
            textF3.becomeFirstResponder()
        }
        else if textField == textF3
        {
            textField.resignFirstResponder()
            textField4.becomeFirstResponder()
            
        }
        else if textField == textField4
        {
            
            textField.resignFirstResponder()
            textField5.becomeFirstResponder()
        }
        else if textField == textField5
        {
            textField.resignFirstResponder()
            textField6.becomeFirstResponder()
            
        }
        else if textField == textField6
        {
            // self.codeLbl.text = ("\(textField1.text)\(textField2.text)\(textF3.text)\(textField4.text)\(textField5.text)\(textField6.text)")
            resignFirstResponder()
            
        }
        
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
        
    {
        
        if((textField.text?.characters.count)! < 1 && string.characters.count > 0){
            
            let nexttag = textField.tag+1
            var nextresponder = textField.superview?.viewWithTag(nexttag)
            if (nextresponder == nil)
            {
                nextresponder = textField.superview?.viewWithTag(1)
            }
            textField.text = string
            nextresponder?.becomeFirstResponder()
            return false
        }
            
        else if (textField.text?.characters.count)! <= 1 && string.characters.count>0
        {
            return false
            
        }
        else
        {
            return true
        }
        
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool // return NO to disallow editing.
    {
        if textField.text?.characters.count == 1  {
            return true
        }else{
            return false
        }
    }
    
    //http://storeongo.com:8081/Services/getMasters?mallId=20217&type= RedeemHistory&refTypeProperty1=MacId&refId1=195735
    
    func redeemHistoryApiCall(){
        LoadingView.show("Loading...", animated: true)
        CXDataService.sharedInstance.getTheAppDataFromServer(["type":"RedeemHistory","mallId":CXAppConfig.sharedInstance.getAppMallID(),"refTypeProperty1":"MacId","refId1":CXAppConfig.sharedInstance.getTheUserData().macIdJobId]) { (responseDict) in
            print(responseDict)
            self.redeemHistoryJobsArr = responseDict.valueForKey("jobs") as! NSArray
            print(self.redeemHistoryJobsArr.count)
            self.RedeemTableView.reloadData()
           // self.offerReedem()
            LoadingView.hide()
        }
    }

    
    // note: After successful completino of Marchant entered pin is equals to offerDict pin code then call this api. Here userId = getUserId and jobid = offerId http://storeongo.com:8081/jobs/saveJobCommentJSON?userId=20217&jobId=196446&comment=excellent&rating=0.5
    
    
    // note: To get redeem history http://localhost:8081/MobileAPIs/getJobsFollowingBy?email=cxsample@gmail.com&mallId=530&type=RedeemHystory.
    
    
    
    
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

        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(CXAppConfig.sharedInstance.getBaseUrl()+CXAppConfig.sharedInstance.getPlaceOrderUrl(), parameters: ["type":"RedeemHistory","json":jsonStringFormat!,"dt":"CAMPAIGNS","category":"Notifications","userId":CXAppConfig.sharedInstance.getAppMallID(),"consumerEmail":"yernagulamahesh@gmail.com"]) { (responseDict) in
            print(responseDict)
            let string = responseDict.valueForKeyPath("myHashMap.status")
            print(string)
            LoadingView.hide()
        }
        
    }
    
}
