//
//  LeftViewController.swift
//  CoupCon
//
//  Created by apple on 13/10/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit

class LeftViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var leftTableview: UITableView!
    var previousSelectedIndex  : NSIndexPath = NSIndexPath()
    var nameArray = ["HOME","PROFILE & MEMBERSHIP","REDEEM & HISTORY","HOW TO USE","HELP","SIGN OUT"]
    var imageArray = ["HomeImage","Profile & membershipImage","Profile & membershipImage","HowtoUseImage","Helpimage",""]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.userImage.layer.borderColor = UIColor.whiteColor().CGColor
        
        self.userImage.layer.cornerRadius = 45 //self.userImage.bounds.size.width/2
        self.userImage.clipsToBounds = true
        
        
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        self.leftTableview.registerNib(nib, forCellReuseIdentifier: "TableViewCell")

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true

    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        
        return nameArray.count
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TableViewCell", forIndexPath: indexPath)
        cell.textLabel?.text = nameArray[indexPath.row]
        cell.textLabel?.font = CXAppConfig.sharedInstance.appMediumFont()
        cell.imageView?.image = UIImage(named: imageArray[indexPath.row])
        
        leftTableview.allowsSelection = true
        
        //[cell setBackgroundColor:[UIColor clearColor]];
        cell .backgroundColor = UIColor.clearColor()
        cell.textLabel?.textColor = UIColor.whiteColor()
        leftTableview.separatorStyle = .None
        return cell
        
        
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        
        leftTableview.rowHeight = 50
        return 50
        
    }
    /* if NSUserDefaults.standardUserDefaults().valueForKey("USER_ID") != nil{
     let orders = storyBoard.instantiateViewControllerWithIdentifier("ORDERS") as! OrdersViewController
     self.navigationController!.pushViewController(orders, animated: true)
     }else{
     let signInViewCnt : CXSignInSignUpViewController = CXSignInSignUpViewController()
     self.navigationController!.pushViewController(signInViewCnt, animated: true)
     }*/
    
    
    
  
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        let revealController : SWRevealViewController  = self.revealViewController()
        
        if indexPath == previousSelectedIndex {
            revealController.revealToggleAnimated(true)
            return
        }
        previousSelectedIndex = indexPath
        //self.navController.drawerToggle()
        let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let itemName : String =  nameArray[indexPath.row]
        if itemName == "HOME"{
            let homeView = storyBoard.instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
            let navCntl = UINavigationController(rootViewController: homeView)
            revealController.pushFrontViewController(navCntl, animated: true)

        }else if itemName == "PROFILE & MEMBERSHIP"{
            let aboutUs = storyBoard.instantiateViewControllerWithIdentifier("PROFILE_MEMBERSHIP") as! ProfileMembershipViewController
            let navCntl = UINavigationController(rootViewController: aboutUs)
            revealController.pushFrontViewController(navCntl, animated: true)
            
        }else if itemName == "REDEEM & HISTORY"{
            let redeem = storyBoard.instantiateViewControllerWithIdentifier("REDEEM_HISTORY") as! ReedemViewController
            let navCntl = UINavigationController(rootViewController: redeem)
            revealController.pushFrontViewController(navCntl, animated: true)
        }else if itemName == "HOW TO USE"{
//            let orders = storyBoard.instantiateViewControllerWithIdentifier("ORDERS") as! OrdersViewController
//            self.navigationController!.pushViewController(orders, animated: true)
            
        }else if itemName == "HELP" {
//            let wishlist = storyBoard.instantiateViewControllerWithIdentifier("WISHLIST") as! NowfloatWishlistViewController
//            self.navController.pushViewController(wishlist, animated: true)
        }
        
    }


}


extension LeftViewController{
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return.LightContent
    }
    
    func drawerControllerWillOpen(drawerController: ICSDrawerController!) {
        self.view.userInteractionEnabled = false;
    }
    
    func drawerControllerDidClose(drawerController: ICSDrawerController!) {
        self.view.userInteractionEnabled = true;
        
    }
}
