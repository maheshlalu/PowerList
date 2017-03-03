//
//  OffersViewController.swift
//  CoupCon
//
//  Created by apple on 18/10/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit

class OffersViewController: UIViewController {

    var okAction: (() -> Void)?

    
    var offersList : NSMutableArray!
    var offersCodes : NSMutableString!
    
    var productDic : NSDictionary?
    var subJobDic : NSDictionary?


    @IBOutlet weak var offersTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        offersList = NSMutableArray()
        self.offersCodes = NSMutableString()
        let nib = UINib(nibName: "OfferTableViewCell", bundle: nil)
        self.offersTableView.registerNib(nib, forCellReuseIdentifier: "OfferTableViewCell")
        self.getTheOffers()
        self.view.backgroundColor = UIColor.clearColor()
        self.navigationController?.navigationBar.backgroundColor = UIColor.grayColor()
               //Offers
        // Do any additional setup after loading the view.
    }
    
    
    func getTheOfferCodes() ->NSMutableString{
        let keyExists = self.productDic![ "Offers"] != nil
        //let keyExists = self.subJobDic![ "Offers"] != nil

        if !keyExists {
            // now val is not nil and the Optional has been unwrapped, so use it
            return ""
        }
        //self.subJobDic?.valueForKey("Offers") as! String
        let offerString :String =  CXAppConfig.sharedInstance.getTheDataInDictionaryFromKey(self.productDic!, sourceKey: "Offers")
        // let offerString :String =  CXAppConfig.sharedInstance.getTheDataInDictionaryFromKey(self.subJobDic!, sourceKey: "Offers")
        if offerString.isEmpty{
            return ""
        }
       let  offersListArry = NSArray(array: offerString.componentsSeparatedByString("#"))
        for (index ,offerCode ) in offersListArry.enumerate() {
            self.offersCodes.appendString(self.getTheofferDisplayString(offerCode as! String))
            if index != offersListArry.count-1 {
                self.offersCodes.appendString(",")
            }
        }
        return self.offersCodes
    }
    
    func getTheOffers(){
        // http://storeongo.com:8081/Services/getOffers?mallId=20217&%20consumerEmail=yernagulamahesh@gmail.com&macJobId=195735&%20productId=196429prefferedJobs=196663
        
        if self.subJobDic?.allKeys.count == 0{
            return
        }
        
        LoadingView.show("Loading...", animated: true)
        let preferedJobs = self.getTheOfferCodes()
        
        if preferedJobs.isEqualToString("") {
            self.offersList   =  NSMutableArray()
            LoadingView.hide()
            self.offersTableView.reloadData()
        }else{
            
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile("\(CXAppConfig.sharedInstance.getBaseUrl())Services/getOffers?", parameters: ["mallId":CXAppConfig.sharedInstance.getAppMallID(),"consumerEmail":CXAppConfig.sharedInstance.getTheUserData().userEmail,"macJobId":CXAppConfig.sharedInstance.getTheUserData().macIdJobId,"productId":CXAppConfig.resultString(self.productDic!.valueForKey("id")!),"prefferedJobs":preferedJobs,"currentSubscriptionJobId":CXAppConfig.sharedInstance.getUserCurrentSubscriptionJobId(),"subJobId":CXAppConfig.resultString(self.subJobDic!.valueForKey("id")!)]) { (responseDict) in
            self.offersList   =  NSMutableArray(array: (responseDict.valueForKey("jobs") as? NSArray!)!)
            LoadingView.hide()
            self.offersTableView.reloadData()
        }
        }

    }
    
    
    func filterTheOffers(jobsArray:NSArray){
        for jobs in jobsArray {
            let jobCommentsArray : NSArray = (jobs.valueForKey("jobComments") as? NSArray)!
            //jobComments
            var isJobCommented : Bool = false
            for jobCommentDic in jobCommentsArray {
                if CXAppConfig.sharedInstance.getUserID() == jobCommentDic.valueForKey("postedBy_Id") as! String {
                    isJobCommented = true
                    break
                }
            }
            if !isJobCommented {
                self.offersList.addObject(jobs)
            }
        }

    }
    
    
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        
        return self.offersList.count
        
        
    }
    
    
    func getTheofferDisplayString(inputString : String) -> String{
        let component = inputString.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
        let list = component.filter({ $0 != "" })
        let number: Int64? = Int64(list.last!)
        return String(number!)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell : OfferTableViewCell = (tableView.dequeueReusableCellWithIdentifier("OfferTableViewCell", forIndexPath: indexPath) as? OfferTableViewCell)!
        tableView.separatorStyle = .None
        cell.selectionStyle = .None
        let offerDic : NSDictionary = self.offersList[indexPath.row] as! NSDictionary
        cell.offersLblText.text = offerDic.valueForKey("Name") as? String
        cell.redeemBtn.layer.cornerRadius = 8.0
        
        
        //isRedeemed
        let isReedemed = CXAppConfig.sharedInstance.getTheDataInDictionaryFromKey(offerDic, sourceKey: "isRedeemed")
        if(isReedemed.caseInsensitiveCompare("yes") == NSComparisonResult.OrderedSame){
            cell.backgroundColor = UIColor(red: 233.0/255.0, green: 233.0/255.0, blue: 233.0/255.0, alpha: 1.0)
            cell.redeemBtn.backgroundColor = UIColor(red: 233.0/255.0, green: 233.0/255.0, blue: 233.0/255.0, alpha: 1.0)

        }else{
            cell.backgroundColor = UIColor.whiteColor()
        }

        return cell
        
    }

    
    func showAlertView(message:String, status:Int) {
        dispatch_async(dispatch_get_main_queue(), {
            let alert = UIAlertController(title: "CoupCon", message: message, preferredStyle: UIAlertControllerStyle.Alert)
            
            let okAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: { (alert) in
                 self.okAction?()
            })
            let cancelActon = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: { (alert) in
                
            })
            alert.addAction(okAction)
            alert.addAction(cancelActon)

            self.presentViewController(alert, animated: true, completion: nil)
        })
    }

  

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Free Coupons
        let offerDic : NSDictionary = self.offersList[indexPath.row] as! NSDictionary
        
        let isReedemed = CXAppConfig.sharedInstance.getTheDataInDictionaryFromKey(offerDic, sourceKey: "isRedeemed")
        
        if(isReedemed.caseInsensitiveCompare("yes") == NSComparisonResult.OrderedSame){
            self.showAlertView("Do you want to redeem this offer again?", status: 0)
            
        }else if (CXAppConfig.sharedInstance.getSelectedCategory() == "Free Coupons"){
            //User want use free coupons user must subscribe with 6 months validity and more
            CXDataService.sharedInstance.getTheAppDataFromServer(["type" : "macidinfo","mallId" : CXAppConfig.sharedInstance.getAppMallID(),"keyWord":CXAppConfig.sharedInstance.getEmail()]) { (responseDict) in
                // let email: String = (userDataDic.objectForKey("email") as? String)!
                let array   =  NSMutableArray(array: (responseDict.valueForKey("jobs") as? NSArray!)!)
                if array.count != 0 {
                let userDic = (array.lastObject as? NSDictionary)!
                CXAppConfig.sharedInstance.saveTheUserMacIDinfoData(userDic)
                let payMentType =  userDic.valueForKey("PaymentType") as? String
                if (payMentType == "149" || payMentType == "249" ){
                    self.redeemTheOffer(offerDic)
                }else{
                    self.showAlertView("If you want to redeem free coupons please subscribe with 6months or more..", status: 0)
                }
                //"PaymentType"
                }
            }
        }else{
            self.redeemTheOffer(offerDic)
        }
    }
    
    
    func redeemTheOffer(offerDic:NSDictionary){
    
        let logoImg = NSUserDefaults.standardUserDefaults().valueForKey("POPUP_LOGO") as! String
        let popUpName = offerDic.valueForKey("Name") as? String
        let offerString :String =  CXAppConfig.sharedInstance.getTheDataInDictionaryFromKey(self.productDic!, sourceKey: "Terms and conditions")
        //        let offerString :String =  CXAppConfig.sharedInstance.getTheDataInDictionaryFromKey(self.subJobDic!, sourceKey: "Terms and conditions")

        let  offersListArry = NSArray(array: offerString.componentsSeparatedByString("#"))
        var termArray = ""
        for (index ,offerCode ) in offersListArry.enumerate() {
            let result = offerCode.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ.,").invertedSet)
            termArray += result
            if index != offersListArry.count-1 {
                termArray += ("#")
            }
        }
        
        if (termArray  == ""){
            let popUpDict:[String: AnyObject] = [ "popUpLogo":logoImg,  "popUpName": popUpName!]
            NSNotificationCenter.defaultCenter().postNotificationName("ShowPopUp", object: nil)
            NSNotificationCenter.defaultCenter().postNotificationName("PopUpData", object: popUpDict)
        }else{
            let popUpDict:[String: AnyObject] = [ "popUpLogo":logoImg,  "popUpName": popUpName!,"terms":termArray]
            NSNotificationCenter.defaultCenter().postNotificationName("ShowPopUp", object: nil)
            NSNotificationCenter.defaultCenter().postNotificationName("PopUpData", object: popUpDict)
        }
        
        let jsonDic : NSMutableDictionary = NSMutableDictionary(dictionary: CXAppConfig.sharedInstance.getRedeemDictionary())
        
        jsonDic.setObject(CXAppConfig.resultString(self.productDic!.valueForKey("id")!), forKey: "ProductId")
        jsonDic.setObject(offerDic.valueForKey("Name")!, forKey: "OfferName")
        jsonDic.setObject(offerDic.valueForKey("ItemCode")!, forKey: "OfferId")
        //jsonDic.setObject(CXAppConfig.sharedInstance.getSubscriptionJobItemCode(), forKey: "SubscriptionJobId") //SubscriptionJobItemCode from user macIdInfo
        jsonDic.setObject(CXAppConfig.resultString(self.subJobDic!.valueForKey("ItemCode")!), forKey: "subJobId") //Item code in Offers
        jsonDic.setObject(CXAppConfig.resultString(self.productDic!.valueForKey("Code")!), forKey: "OfferCode")
        CXAppConfig.sharedInstance.setRedeemDictionary(jsonDic)
    
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        tableView.rowHeight = 122
        return 122
        
    }
    
    
    func constructTheOfferReedemJson(){
        /*
         json={"list"":[{"ProductName":"Tabla","ProductDescription":"description","ProductImage":"https://s3-ap-southeast-1.amazonaws.com/storeongocontent/jobs/jobFldAttachments/20217_1477488244540.png","OfferName":"25 off on lunch","ProductId":"196429","OfferId":"9876543210","MacId":"102716-BHJAFCFH"}]}&dt=CAMPAIGNS&category=Notifications&userId=20217&consumerEmail=cxsample@gmail.com
         
         */
        let jsonDic : NSMutableDictionary = NSMutableDictionary(dictionary: CXAppConfig.sharedInstance.getRedeemDictionary())
        
        jsonDic.setObject("456", forKey: "OfferName")
        jsonDic.setObject("456", forKey: "OfferId")


        let jsonListArray : NSMutableArray = NSMutableArray()
        jsonListArray.addObject(jsonDic)
        
        let listDic : NSDictionary = NSDictionary(object: jsonListArray, forKey: "list")
        
    }
    


}
