//
//  WeightToLoseCell.swift
//  Diet
//
//  Created by Даниил on 09/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import UIKit

class WeightToLoseCell: UICollectionViewCell {
    
    static var identifier = "WeightToLoseCell"

    @IBOutlet weak var kgLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        kgLabel.text = "килограмм".localized
    }
}