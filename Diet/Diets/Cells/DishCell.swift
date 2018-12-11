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
    
    fileprivate let cellCornerRadius: CGFloat = 32
    
    lazy var lockImageView: UIImageView = {
        let img = UIImageView(image: UIImage(named: "lock"))
        return img
    }()
    
    static var identifier = "DishCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        showRecipeButton.layer.cornerRadius = showRecipeButton.frame.height / 2
        showRecipeButton.layer.masksToBounds = true
        dishImageView.layer.cornerRadius = 18
        dishImageView.layer.masksToBounds = true
        layer.cornerRadius = cellCornerRadius
        layer.masksToBounds = true
        lockImageView.frame.size = CGSize(width: 75, height: 75)
        lockImageView.center = center
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupCellShadow()
    }
    
    func lockDish() {
        applyBlur()
        addSubview(lockImageView)
    }
    
    fileprivate func applyBlur() {
        let blurEffectView = VisualEffectView()
        blurEffectView.frame = self.bounds
        blurEffectView.colorTintAlpha = 1
        blurEffectView.colorTintAlpha = 0.1
        blurEffectView.blurRadius = 5
        blurEffectView.scale = 1
        blurEffectView.layer.masksToBounds = true
        blurEffectView.layer.cornerRadius = cellCornerRadius
        self.addSubview(blurEffectView)
    }
    
    fileprivate func setupCellShadow() {
        
        layer.masksToBounds = false
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 1, height: 0.0)
        layer.shadowRadius = 16
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    }
    
    @IBAction func showRecipeButtonPressed(_ sender: Any) {
        
    }
}
