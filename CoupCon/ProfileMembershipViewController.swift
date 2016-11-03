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
        tableView.rowHeight = 80
        return 70
        
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false
        print(self.navigationController)
    }
    
}
