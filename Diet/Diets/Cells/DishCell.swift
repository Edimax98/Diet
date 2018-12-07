//
//  DishCell.swift
//  Diet
//
//  Created by Даниил on 07/12/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import UIKit

class DishCell: UICollectionViewCell {
    
    @IBOutlet weak var proteinsAmountLabel: UILabel!
    @IBOutlet weak var dishNameLabel: UILabel!
    @IBOutlet weak var dishImageView: UIImageView!
    @IBOutlet weak var showRecipeButton: UIButton!
    
    static var identifier = "DishCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        showRecipeButton.layer.cornerRadius = showRecipeButton.frame.height / 2
        showRecipeButton.layer.masksToBounds = true
        dishImageView.layer.cornerRadius = 18
        dishImageView.layer.masksToBounds = true
        layer.cornerRadius = 32
        layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupCellShadow()
    }
    
    fileprivate func setupCellShadow() {
        
        layer.masksToBounds = false
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowRadius = 16
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    }
    
    @IBAction func showRecipeButtonPressed(_ sender: Any) {
    }
}
