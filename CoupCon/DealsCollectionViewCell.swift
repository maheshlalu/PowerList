//
//  DealsCollectionViewCell.swift
//  CoupCon
//
//  Created by Manishi on 10/27/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit

class DealsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var layerView: UIView!
    @IBOutlet weak var dealsImageView: UIImageView!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var dealName: UILabel!
    @IBOutlet weak var dealArea: UILabel!
    @IBOutlet weak var callBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        layerView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
    }

}
