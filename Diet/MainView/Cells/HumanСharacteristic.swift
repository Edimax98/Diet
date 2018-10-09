//
//  HumanСharacteristic.swift
//  Diet
//
//  Created by Даниил on 09/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import UIKit

class HumanCharacteristic: UITableViewCell {

    @IBOutlet weak var genderSelectorCollectionView: UICollectionView!
    @IBOutlet weak var ageSelectorCollectionView: UICollectionView!
    @IBOutlet weak var weightSelectorCollectionView: UICollectionView!
    @IBOutlet weak var heightSelectorCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
