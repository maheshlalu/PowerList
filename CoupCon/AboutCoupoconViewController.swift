//
//  AboutCoupoconViewController.swift
//  Coupocon
//
//  Created by apple on 24/11/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit
//H.No.3-6-698,\nStreet no.11,\nHimayathNagar, \nHyderabad-500029\n
class AboutCoupoconViewController: UIViewController {

    
    var KeyArray = NSArray()
    var cateGoryData = NSDictionary()
    
    @IBOutlet weak var aboutTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpSideMenu()
        aboutTableView.estimatedRowHeight = 58
        aboutTableView.rowHeight = UITableViewAutomaticDimension
        let nib = UINib(nibName: "AboutUsTableViewCell", bundle: nil)
        self.aboutTableView.registerNib(nib, forCellReuseIdentifier: "AboutUsTableViewCell")
       self.aboutTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        
        cateGoryData = NSDictionary(objects: [   "09:00-20:00","","Coupocon is a tailor made Mobile App which understands the need of a retail business module and need for an organisation to retain customer loyalty. Our aim is to provide our customers with the best deals and thereby bridge the gap between the vendors and customers. We have meticulously worked on a concept saving Mobile App which aims at getting best deals for our privilege customers at Area restaurants, attractions, shopping destinations, watch stores, spectacle stores and more!","tt"], forKeys: ["Timings" as NSCopying,"Reach Us At" as NSCopying,"About Us" as NSCopying,"Like Us At" as NSCopying])
        
        KeyArray = ["Timings","Reach Us At","About Us","Like Us At"]
        
        // Do any additional setup after loading the view.
    }
    
    
    func setUpSideMenu(){
        
        let menuItem = UIBarButtonItem(image: UIImage(named: "sidePanelMenu"), style: .Plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
        menuItem.tintColor = UIColor.whiteColor()
        self.navigationItem.leftBarButtonItem = menuItem
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        // navigationController?.setNavigationBarHidden(false, animated: true)
        let navigation:UINavigationItem = navigationItem
        navigation.title  = "ABOUT US"
        //self.sideMenuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), forControlEvents: .TouchUpOutside)
    }


}

extension AboutCoupoconViewController:UITableViewDelegate,UITableViewDataSource {
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return KeyArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        tableView.allowsSelection = false
        tableView.separatorStyle = .None
       
        let cell =  tableView.dequeueReusableCellWithIdentifier("AboutUsTableViewCell", forIndexPath: indexPath)as? AboutUsTableViewCell
        let keyvalue = KeyArray[indexPath.row]
        cell?.aboutNameLabel.text = keyvalue as? String
        cell?.descriptionLabel.text = cateGoryData.valueForKey((keyvalue as?String)!) as? String
        
        if indexPath.row == 1 {
            cell?.callStackView.hidden = false
        }
        else {
            
            cell?.callStackView.hidden = true
        }
        if indexPath.row == 3
        {
            cell?.buttonStackView.hidden = false
            cell?.descriptionLabel.hidden = true
            
        }
        else {
            cell?.buttonStackView.hidden = true
            cell?.descriptionLabel.hidden = false
        }
        return cell!

    }
}
