//
//  AmountOfWeightToLose.swift
//  Diet
//
//  Created by Даниил on 09/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import UIKit

class AmountOfWeightToLose: UITableViewCell {

    static var identifier = "AmountOfWeightToLose"
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(UINib(nibName: "WeightToLoseCell", bundle: nil), forCellWithReuseIdentifier: WeightToLoseCell.identifier)
    }
}
