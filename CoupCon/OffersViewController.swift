//
//  OffersViewController.swift
//  CoupCon
//
//  Created by apple on 18/10/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit

class OffersViewController: UIViewController {

    
    
    var offersDic : NSDictionary?
    var offersList : NSMutableArray!
    var offersCodes : NSMutableString!

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
        
        let offerString :String =  self.offersDic?.valueForKey("Offers") as! String
       let  offersListArry = NSArray(array: offerString.componentsSeparatedByString("#"))
        print(offerString)
        print(offersListArry)
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
        LoadingView.show("Loading...", animated: true)
        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile("http://storeongo.com:8081/Services/getOffers?", parameters: ["mallId":CXAppConfig.sharedInstance.getAppMallID(),"consumerEmail":CXAppConfig.sharedInstance.getTheUserData().userEmail,"macJobId":CXAppConfig.sharedInstance.getTheUserData().macIdJobId,"productId":CXAppConfig.resultString(self.offersDic!.valueForKey("id")!),"prefferedJobs":self.getTheOfferCodes()]) { (responseDict) in
            self.offersList   =  NSMutableArray(array: (responseDict.valueForKey("jobs") as? NSArray!)!)
            LoadingView.hide()
            self.offersTableView.reloadData()
        }
        //
        //        CXDataService.sharedInstance.getTheAppDataFromServer(["type":"offers","mallId":CXAppConfig.sharedInstance.getAppMallID(),"PrefferedJobs":self.getTheOfferCodes()]) { (responseDict) in
        //            self.filterTheOffers((responseDict.valueForKey("jobs") as? NSArray)!)
        //            LoadingView.hide()
        //            self.offersTableView.reloadData()
        //        }
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
        print(offerDic)
        cell.offersLblText.text = offerDic.valueForKey("Name") as? String
        cell.redeemBtn.layer.cornerRadius = 8.0
  
        if indexPath.row % 2 != 0 {
            
            cell.backgroundColor = UIColor(red: 233.0/255.0, green: 233.0/255.0, blue: 233.0/255.0, alpha: 1.0)
        }
        else {
            cell.backgroundColor = UIColor.whiteColor()
        }

        
//        if indexPath.row == 0 {
//            let color = UIColor.redColor().CGColor
//            
//            let shapeLayer:CAShapeLayer = CAShapeLayer()
//            let frameSize =  cell.offersLblText.bounds
//            print(NSStringFromCGRect(frameSize))
//            let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
//            
//            shapeLayer.bounds = shapeRect
//            shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
//            shapeLayer.fillColor = UIColor.clearColor().CGColor
//            shapeLayer.strokeColor = color
//            shapeLayer.lineWidth = 1
//            shapeLayer.lineJoin = kCALineJoinRound
//            shapeLayer.lineDashPattern = [2,4]
//            shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).CGPath
//            print(NSStringFromCGRect(shapeLayer.frame))
//
//            cell.offersLblText.layer.addSublayer(shapeLayer)
//
//        }
        

        return cell
        
    }


    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let offerDic : NSDictionary = self.offersList[indexPath.row] as! NSDictionary
        let logoImg = NSUserDefaults.standardUserDefaults().valueForKey("POPUP_LOGO") as! String
        let popUpName = offerDic.valueForKey("Name") as? String
       // guard let terms = offerDic.valueForKey("TermsAndConditions") as? NSArray else{()}
        let terms = offerDic.valueForKey("TermsAndConditions")
        print(terms)
        
        if (terms as? String == ""){
            let popUpDict:[String: AnyObject] = [ "popUpLogo":logoImg,  "popUpName": popUpName!]
            NSNotificationCenter.defaultCenter().postNotificationName("ShowPopUp", object: nil)
            NSNotificationCenter.defaultCenter().postNotificationName("PopUpData", object: popUpDict)
        }else{
            let popUpDict:[String: AnyObject] = [ "popUpLogo":logoImg,  "popUpName": popUpName!,"terms":terms!]
            NSNotificationCenter.defaultCenter().postNotificationName("ShowPopUp", object: nil)
            NSNotificationCenter.defaultCenter().postNotificationName("PopUpData", object: popUpDict)
        }
        
        
        let jsonDic : NSMutableDictionary = NSMutableDictionary(dictionary: CXAppConfig.sharedInstance.getRedeemDictionary())
        
        jsonDic.setObject(offerDic.valueForKey("Name")!, forKey: "OfferName")
        jsonDic.setObject(offerDic.valueForKey("ItemCode")!, forKey: "OfferId")
        jsonDic.setObject(offerDic.valueForKey("Code")!, forKey: "OfferCode")
        
        print(jsonDic)
        
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
        print(listDic)
        
    }
    


}
