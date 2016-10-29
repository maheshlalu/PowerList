//
//  RedeemTableViewCell.swift
//  CoupoConLoginScreen
//
//  Created by Rama kuppa on 20/10/16.
//  Copyright © 2016 Mahesh. All rights reserved.
//

import UIKit

class RedeemTableViewCell: UITableViewCell {

    @IBOutlet weak var redeemImageView: UIImageView!
    @IBOutlet weak var redeemLogo: UIImageView!
    @IBOutlet weak var redeemLbl: UILabel!
    @IBOutlet weak var redeemPercentLbl: UILabel!
    @IBOutlet weak var dealsUsedDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
