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

               //Offers
        // Do any additional setup after loading the view.
    }
    
    
    func getTheOfferCodes() ->NSMutableString{
        
        let offerString :String =  self.offersDic?.valueForKey("Offers") as! String
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
        CXDataService.sharedInstance.getTheAppDataFromServer(["type":"offers","mallId":CXAppConfig.sharedInstance.getAppMallID(),"PrefferedJobs":self.getTheOfferCodes()]) { (responseDict) in
            self.filterTheOffers((responseDict.valueForKey("jobs") as? NSArray)!)
            self.offersTableView.reloadData()
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
        
        let offerDic : NSDictionary = self.offersList[indexPath.row] as! NSDictionary
        cell.offersLblText.text = offerDic.valueForKey("Name") as? String
        tableView.allowsSelection = false
        return cell
        
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let offerTitle : String = (self.offersList[indexPath.row] as?String)!
        self.getTheofferDisplayString(offerTitle)

    }
    
    
/*
     
     let reqString = "http://sillymonksapp.com:8081/jobs/saveJobCommentJSON?userId="+userID+"&jobId="+jobID+"&comment="+comment+"&rating="+rating+"&commentId="+commentId
     //http://sillymonksapp.com:8081/jobs/saveJobCommentJSON?/ userId=11&jobId=239&comment=excellent&rating=0.5&commentId=74
 */

    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        tableView.rowHeight = 110
        return 110
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
