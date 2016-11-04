//
//  OfferTableViewCell.swift
//  MembershipScreen
//
//  Created by Rama kuppa on 19/10/16.
//  Copyright © 2016 Mahesh. All rights reserved.
//

import UIKit

class OfferTableViewCell: UITableViewCell {

    @IBOutlet weak var offersLblText: UILabel!
    @IBOutlet weak var redeemBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
      redeemBtn.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
