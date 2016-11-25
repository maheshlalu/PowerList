//
//  AboutUsTableViewCell.swift
//  Autolayouts_CoupoCon
//
//  Created by Rama kuppa on 22/11/16.
//  Copyright © 2016 Mahesh. All rights reserved.
//

import UIKit

class AboutUsTableViewCell: UITableViewCell {

    @IBOutlet weak var buttonStackView: UIStackView!
    
    
    @IBOutlet weak var callStackView: UIStackView!
   
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var aboutNameLabel: UILabel!
    
    @IBAction func callBtnAction(sender: UIButton) {
        
        UIApplication.sharedApplication().openURL(NSURL(string: "tel://\("9063903903")")!)

    }
    
    @IBAction func instagramBtnAction(sender: UIButton) {
        
        let instagramlink = NSURL(string : "https://www.instagram.com/coupocon/")
        UIApplication.sharedApplication().openURL(instagramlink!)
    }
    @IBAction func facebookBtnAction(sender: UIButton) {
        
        let facebooklink = NSURL(string : "https://www.facebook.com/coupocon/?fref=ts")
        UIApplication.sharedApplication().openURL(facebooklink!)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
