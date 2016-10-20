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
        
        
        
    }
    
//    
//  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
//    {
//        return 1
//        
//        
//    }
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//    
//        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "RedeemTableViewCell", for: indexPath)
//        
//        RedeemTableView.separatorStyle = .none
//        return cell
//    }
//
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        tableView.rowHeight = 100
//        return 100
//        
//    }
}
