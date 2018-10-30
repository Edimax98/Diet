//
//  SuggestedDietCell.swift
//  Diet
//
//  Created by Даниил on 30/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import UIKit

class SuggestedDietCell: UICollectionViewCell {

    static let identifier = "SuggestedDietCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 32
        self.clipsToBounds = true
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.layer.shadowRadius = 1
        self.layer.shadowOpacity = 0.4
        self.layer.masksToBounds = false
    }
}
