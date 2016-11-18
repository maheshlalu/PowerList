//
//  HelpTableViewCell.swift
//  CoupoCon_HelpScreen
//
//  Created by apple on 17/11/16.
//  Copyright © 2016 ongo. All rights reserved.
//

import UIKit

class HelpTableViewCell: UITableViewCell {

    @IBAction func instagramBtnAction(sender: UIButton) {
        
        let instagramlink = NSURL(string : "https://www.instagram.com/coupocon/")
        UIApplication.sharedApplication().openURL(instagramlink!)
    }
    @IBAction func facebookBtnAction(sender: UIButton) {
        
        let facebooklink = NSURL(string : "https://www.facebook.com/coupocon/?fref=ts")
        UIApplication.sharedApplication().openURL(facebooklink!)
    }
    
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    
}
