//
//  MerchantDetailsTableViewCell.swift
//  AboutScreen
//
//  Created by Rama kuppa on 18/11/16.
//  Copyright © 2016 Mahesh. All rights reserved.
//

import UIKit

class MerchantDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImgView: UIImageView!
    @IBOutlet weak var categoryTypeLbl: UILabel!
    @IBOutlet weak var timingsLbl: UILabel!
    @IBOutlet weak var categoryTitleLbl: UILabel!
    @IBOutlet weak var timingsTitleLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.categoryTitleLbl.textColor = CXAppConfig.sharedInstance.getAppTheamColor()
         self.timingsTitleLbl.textColor = CXAppConfig.sharedInstance.getAppTheamColor()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
