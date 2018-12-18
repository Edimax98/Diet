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

    lazy var blurEffectView: VisualEffectView = {
        let blur = VisualEffectView()
        blur.frame = self.bounds
        blur.colorTintAlpha = 1
        blur.colorTintAlpha = 0.1
        blur.blurRadius = 5
        blur.scale = 1
        blur.layer.masksToBounds = true
        blur.layer.cornerRadius = cellCornerRadius
        return blur
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
    
    func hide() {
        addSubview(blurEffectView)
        addSubview(lockImageView)
    }
    
    func open() {
        
        if lockImageView.superview != nil {
            lockImageView.removeFromSuperview()
        }
        
        if blurEffectView.superview != nil {
            blurEffectView.removeFromSuperview()
        }
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
