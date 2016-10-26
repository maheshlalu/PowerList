//
//  membershipTableViewCell.swift
//  MembershipScreen
//
//  Created by Rama kuppa on 18/10/16.
//  Copyright © 2016 Mahesh. All rights reserved.
//

import UIKit

class membershipTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var imageLbl: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
