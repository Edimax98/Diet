//
//  CharacteristicCell.swift
//  Diet
//
//  Created by Даниил on 11/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import UIKit

class CharacteristicCell: UICollectionViewCell {

    @IBOutlet weak var backGroundImage: UIImageView!
    @IBOutlet weak var characteristicLabel: UILabel!
    
    static var identifier = "CharacteristicCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = self.frame.height / 2
    }
}
