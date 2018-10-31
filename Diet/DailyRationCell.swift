//
//  DailyRationCell.swift
//  Diet
//
//  Created by Даниил on 31/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import UIKit

class DailyRationCell: UICollectionViewCell {

    @IBOutlet weak var dishPictureImageView: UIImageView!
    @IBOutlet weak var dishNameLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nextButton.layer.cornerRadius = nextButton.frame.height / 2
        nextButton.layer.masksToBounds = true
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        
    }
}
