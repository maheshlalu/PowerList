//
//  HowToUseViewController.swift
//  CoupCon
//
//  Created by Manishi on 10/26/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit

class HowToUseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSideMenu()
        self.setUPTheNavigationProperty()
    }
    
    func setUpSideMenu(){
        
        let menuItem = UIBarButtonItem(image: UIImage(named: "sidePanelMenu"), style: .Plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
        menuItem.tintColor = UIColor.whiteColor()
        
        self.navigationItem.leftBarButtonItem = menuItem
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
       // navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.setHidesBackButton(false, animated:true);
        let navigation:UINavigationItem = navigationItem
        navigation.title  = "HOW TO USE"
        //self.sideMenuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), forControlEvents: .TouchUpOutside)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUPTheNavigationProperty(){

        
    }


}



