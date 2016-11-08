//
//  ProfileMembershipViewController.swift
//  CoupCon
//
//  Created by Manishi on 10/20/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit

class ProfileMembershipViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var oneYearBtn: UIButton!
    @IBOutlet weak var sixMonthsBtn: UIButton!
    @IBOutlet weak var threeMonthsBtn: UIButton!
    @IBOutlet weak var oneMonthBtn: UIButton!
    @IBOutlet weak var dpImageView: UIImageView!
    @IBOutlet weak var detailsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        membershipBtnLabels()
        
        let nib = UINib(nibName: "membershipTableViewCell", bundle: nil)
        self.detailsTableView.registerNib(nib, forCellReuseIdentifier: "membershipTableViewCell")
        
        self.setUPTheNavigationProperty()
        self.setUpSideMenu()
        
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
        
        //self.sideMenuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), forControlEvents: .TouchUpOutside)
    }
    
    func setUPTheNavigationProperty(){
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController!.navigationBar.barTintColor = CXAppConfig.sharedInstance.getAppTheamColor()
        self.view.backgroundColor = UIColor.whiteColor()
        
        /* navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
         navigationController?.navigationBar.shadowImage = UIImage()
         navigationController?.navigationBar.translucent = true*/
        
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return 3
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
        
    {
       let cell = tableView.dequeueReusableCellWithIdentifier("membershipTableViewCell", forIndexPath: indexPath) as! membershipTableViewCell
        
        detailsTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        detailsTableView.allowsSelection = false
        
        let appdata:NSArray = UserProfile.MR_findAll() as NSArray
        let userProfileData:UserProfile = appdata.lastObject as! UserProfile
        
        if indexPath.row == 0{
            
            cell.nameLbl.text = "Not Available"
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
        print(self.navigationController)
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
        var urlString : String = String("http://54.179.48.83:9000/CoupoconPG/payments?")
        urlString.appendContentsOf("name="+userProfileData.firstName!)
        urlString.appendContentsOf("&email="+userProfileData.emailId!)
        urlString.appendContentsOf("&amount="+amount)
        urlString.appendContentsOf("&description="+"Coupocon Payment")
        urlString.appendContentsOf("&phone="+"8096380038")
        urlString.appendContentsOf("&macId="+userProfileData.macId!)
        urlString.appendContentsOf("&mallId="+CXAppConfig.sharedInstance.getAppMallID())
        print(urlString)
        let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let profileView = storyBoard.instantiateViewControllerWithIdentifier("CXPayMentController") as! CXPayMentController
        let urlSet = NSMutableCharacterSet()
        urlSet.formUnionWithCharacterSet(.URLFragmentAllowedCharacterSet())
        urlSet.formUnionWithCharacterSet(.URLHostAllowedCharacterSet())
        urlSet.formUnionWithCharacterSet(.URLPasswordAllowedCharacterSet())
        urlSet.formUnionWithCharacterSet(.URLQueryAllowedCharacterSet())
        urlSet.formUnionWithCharacterSet(.URLUserAllowedCharacterSet())
        
        if let urlwithPercentEscapes = urlString.stringByAddingPercentEncodingWithAllowedCharacters( urlSet) {
            print(urlwithPercentEscapes)
            
            profileView.paymentUrl = NSURL(string: urlwithPercentEscapes)

            // "http://www.mapquestapi.com/geocoding/v1/batch?key=YOUR_KEY_HERE&callback=renderBatch&location=Pottsville,PA&location=Red%20Lion&location=19036&location=1090%20N%20Charlotte%20St,%20Lancaster,%20PA"
        }
        print(profileView.paymentUrl)
        self.navigationController?.pushViewController(profileView, animated: true)
        LoadingView.hide()
        
       /* CXDataService.sharedInstance.synchDataToServerAndServerToMoblile("http://54.179.48.83:9000/CoupoconPG/payments?", parameters: ["name":userProfileData.firstName!,"email":userProfileData.emailId!,"amount":amount,"description":"","phone":"8096380038","macId":userProfileData.macId!,"mallId":CXAppConfig.sharedInstance.getAppMallID()]) { (responseDict) in            
            print(responseDict)
            print(responseDict.valueForKey("payment_url"))
            let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let profileView = storyBoard.instantiateViewControllerWithIdentifier("CXPayMentController") as! CXPayMentController
            profileView.paymentUrl = responseDict.valueForKey("payment_url")! as! String
            self.navigationController?.pushViewController(profileView, animated: true)
            LoadingView.hide()
        }*/
        
        
    }
    
    
    
    
}
