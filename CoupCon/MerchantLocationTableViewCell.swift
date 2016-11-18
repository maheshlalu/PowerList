//
//  MerchantLocationTableViewCell.swift
//  AboutScreen
//
//  Created by Rama kuppa on 18/11/16.
//  Copyright © 2016 Mahesh. All rights reserved.
//

import UIKit

class MerchantLocationTableViewCell: UITableViewCell {

 
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var locationTextView: UITextView!
    @IBOutlet weak var aboutWebView: UIWebView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
