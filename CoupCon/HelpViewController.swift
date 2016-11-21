//
//  ViewController.swift
//  CoupoCon_HelpScreen
//
//  Created by apple on 17/11/16.
//  Copyright © 2016 ongo. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var cateGoryData = NSDictionary()
    var keysArr = NSArray()
    
    
    @IBOutlet weak var helpTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        helpTableView.backgroundColor = UIColor.clearColor()
        cateGoryData = NSDictionary(objects: ["09:00am-20:00pm","9063903903","H-No: 3-6-698 \n Street No 11 \n Himayathnagar \n Hyderabad-500029",""], forKeys: ["TIME" as NSCopying,"REACH US" as NSCopying,"ADDRESS" as NSCopying,"LINKS" as NSCopying,])
        keysArr = ["TIME","REACH US","ADDRESS","LINKS"]
        
        helpTableView.estimatedRowHeight = 71.0
        helpTableView.rowHeight = UITableViewAutomaticDimension
        
        
        let nib = UINib(nibName: "HelpTableViewCell", bundle: nil)
        self.helpTableView.registerNib(nib, forCellReuseIdentifier: "HelpTableViewCell")
        
        
        setUpSideMenu()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func setUpSideMenu(){
        
        let menuItem = UIBarButtonItem(image: UIImage(named: "sidePanelMenu"), style: .Plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
        menuItem.tintColor = UIColor.whiteColor()
        self.navigationItem.leftBarButtonItem = menuItem
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        // navigationController?.setNavigationBarHidden(false, animated: true)
        let navigation:UINavigationItem = navigationItem
        navigation.title  = "Help"
        //self.sideMenuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), forControlEvents: .TouchUpOutside)
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return keysArr.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        tableView.separatorStyle = .None
        tableView.allowsSelection = false
        
        let cell = tableView.dequeueReusableCellWithIdentifier("HelpTableViewCell", forIndexPath: indexPath)as?HelpTableViewCell

        let keyValue = keysArr[indexPath.row]
        cell?.nameLabel.text = keyValue as? String
        cell?.nameLabel.textColor = CXAppConfig.sharedInstance.getAppTheamColor()
        cell?.descriptionLabel.text = cateGoryData.valueForKey(keyValue as! String)as! String?
        
        if indexPath.row == 3
        {
            cell?.buttonStackView.hidden = false
            
        }
        else
        {
            cell?.buttonStackView.hidden = true
        }
        
        return cell!
        
    }
    
    
}

