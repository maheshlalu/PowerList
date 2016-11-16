//
//  ViewController.swift
//  CoupoCon2
//
//  Created by Rama kuppa on 15/11/16.
//  Copyright © 2016 Mahesh. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var cateGoryData = NSDictionary()
    var keysArr = NSArray()
    var selectedName: String!
    let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
    let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.width
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cateGoryData = NSDictionary(objects: ["09:00am-20:00pm","9063903903","    H-No: 3-6-698 \n Street No 11 \n Himayathnagar \n Hyderabad-500029","https://www.facebook.com/coupocon/?fref=ts,https://www.instagram.com/coupocon/"], forKeys: ["TIME" as NSCopying,"REACHUS" as NSCopying,"ADDRESS" as NSCopying,"LINKS" as NSCopying,])
        keysArr = ["TIME","REACH US","ADDRESS","LINKS"]
        setUpSideMenu()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return keysArr.count
        
    }
    
    func setUpSideMenu(){
        
        let menuItem = UIBarButtonItem(image: UIImage(named: "sidePanelMenu"), style: .Plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
        menuItem.tintColor = UIColor.blackColor()
        
        self.navigationItem.leftBarButtonItem = menuItem
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.title = self.selectedName
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        self.navigationItem.setHidesBackButton(false, animated:true);
        let navigation:UINavigationItem = navigationItem
        navigation.title  = "HELP"
        //self.sideMenuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), forControlEvents: .TouchUpOutside)
    }
    
    
    func facebookAction()
    {
        let facebooklink = NSURL(string : "https://www.facebook.com/coupocon/?fref=ts")
        UIApplication.sharedApplication().openURL(facebooklink!)
    }
    func InstagramAction()
    {
        let instagramlink = NSURL(string : "https://www.instagram.com/coupocon/")
        UIApplication.sharedApplication().openURL(instagramlink!)
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let name = "mycell"
        let cell = tableView.dequeueReusableCellWithIdentifier(name, forIndexPath: indexPath)
        
        tableView.allowsSelection = false
        tableView.separatorStyle = .None
        
        
        if indexPath.row == 0 || indexPath.row == 1 {
            let view = UIView()
            //view.frame = CGRect(x: width(30), y: height(430), width: width(115), height: width(30))
            view.frame = CGRect(x: 0, y: 0, width: (cell.contentView.frame.size.width), height:  (cell.contentView.frame.size.height))
            
            
            cell.contentView.addSubview(view)
            
            let label = UILabel()
            label.frame = CGRect(x: 10, y: 5, width: 200, height: 30)
            let keyvalue = keysArr[indexPath.row] as? String
            label.text = keyvalue
            label.textColor = UIColor.blackColor()
            //let fontname = "Roboto-Regular"
            label.font = UIFont(name: "Roboto-Regular", size: 18)
            view.addSubview(label)
            let label1 = UILabel()
            label1.frame = CGRect(x: 10, y: 20, width: 200, height: 30)
            label1.textColor = UIColor.blackColor()
            //label1.text = cateGoryData.value(forKey: keyvalue!) as! String?
            label1.text = cateGoryData.valueForKey(keyvalue!)as! String?
            //let fontname1 = "Roboto-Regular"
            label1.font = UIFont(name: "Roboto-Regular", size: 13)
            view.addSubview(label1)
        }
        else if indexPath.row == 2 {
            
            let view = UIView()
            //view.frame = CGRect(x: width(30), y: height(430), width: width(115), height: width(30))
            view.frame = CGRect(x: 0, y: 0, width: (cell.contentView.frame.size.width), height:  (cell.contentView.frame.size.height))
     
            cell.contentView.addSubview(view)
            
            //            timecell.layer.cornerRadius = 5
            //            timecell.layer.borderWidth = 1
            //            timecell.layer.borderColor = UIColor.white.cgColor
            //            timecell.clipsToBounds = true
            
            
            
            let label = UILabel()
            label.frame = CGRect(x: 10, y: 5, width: 200, height: 30)
            label.textColor = UIColor.blackColor()
            let keyvalue = keysArr[indexPath.row] as? String
            label.text = keyvalue
            //let fontname = "Roboto-Regular"
            label.font = UIFont(name: "Roboto-Regular", size: 18)
            view.addSubview(label)
            let label1 = UILabel()
            label1.frame = CGRect(x: 10, y: 10, width: 200, height: 100)
            label1.textColor = UIColor.blackColor()
            label1.text = cateGoryData.valueForKey(keyvalue!)as! String?
            label1.numberOfLines = 4
            //let fontname1 = "Roboto-Regular"
            label1.font = UIFont(name: "Roboto-Regular", size: 13)
            view.addSubview(label1)
        }
        else if indexPath.row == 3         {
            
            let view = UIView()
            view.frame = CGRect(x: 0, y: 0, width: (cell.contentView.frame.size.width), height:  (cell.contentView.frame.size.height))
            
  
            cell.contentView.addSubview(view)
 
            
            let label = UILabel()
            label.frame = CGRect(x: 10, y: 5, width: 200, height: 30)
            let keyvalue = keysArr[indexPath.row] as? String
            label.textColor = UIColor.blackColor()
            label.text = keyvalue
            // let fontname = "Roboto-Regular"
            label.font = UIFont(name: "Roboto-Regular", size: 15)
            view.addSubview(label)
            let button = UIButton()
            button.frame = CGRect(x: 10, y: 35, width: 35, height: 35)
            
            button.addTarget(self, action:  #selector(self.facebookAction), forControlEvents: .TouchUpInside)
            button.setImage(UIImage.init(named: "fb"), forState: .Normal)
            button.titleLabel?.font = UIFont.systemFontOfSize(15)
            //button.backgroundColor = UIColor.black
            view.addSubview(button)
            let button1 = UIButton()
            button1.frame = CGRect(x: 100, y: 35, width: 35, height: 35)
            button1.addTarget(self, action: #selector(self.InstagramAction), forControlEvents: .TouchUpInside)
            button1.setImage(UIImage.init(named: "insta"), forState: .Normal)
            button1.titleLabel?.font = UIFont.systemFontOfSize(14)
            //button1.backgroundColor = UIColor.black
            view.addSubview(button1)
        }
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row == 0 || indexPath.row == 1 {
            return 65
        }
        else if indexPath.row == 2{
            return 100
        }
        else if indexPath.row == 3 {
            
            return 80
        }
        else{
            
            return 44
        }
    }
    
    
    
    
}




