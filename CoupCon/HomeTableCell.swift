//
//  HomeTableCell.swift
//  CoupCon
//
//  Created by apple on 14/10/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit

class HomeTableCell: UITableViewCell {

    @IBOutlet weak var categoryImgView: UIImageView!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var totalSubCategoryLbl: UILabel!
    @IBOutlet weak var viewAllDealsBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
