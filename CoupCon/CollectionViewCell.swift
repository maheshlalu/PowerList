//
//  CollectionViewCell.swift
//  Samole collection view
//
//  Created by Manishi on 10/17/16.
//  Copyright © 2016 CX_On. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var dealsImgView: UIImageView!
    @IBOutlet weak var likeBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
