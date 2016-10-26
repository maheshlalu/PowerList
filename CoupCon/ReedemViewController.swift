//
//  ReedemViewController.swift
//  CoupoConLoginScreen
//
//  Created by Rama kuppa on 20/10/16.
//  Copyright © 2016 Mahesh. All rights reserved.
//

import UIKit

class ReedemViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var RedeemTableView: UITableView!
    @IBOutlet weak var textField6: UITextField!
    @IBOutlet weak var textField5: UITextField!

    @IBOutlet weak var textField4: UITextField!
    @IBOutlet weak var textF3: UITextField!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var textField1: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let nib = UINib(nibName: "RedeemTableViewCell", bundle: nil)
        self.RedeemTableView.registerNib(nib, forCellReuseIdentifier: "RedeemTableViewCell")
        self.setUPTheNavigationProperty()
        // Do any additional setup after loading the view.
        self.setUpSideMenu()
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
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
         return 1
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("RedeemTableViewCell", forIndexPath: indexPath)

        RedeemTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        return cell
        
        
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        tableView.rowHeight = 100
            return 100
        
    }
    
}
