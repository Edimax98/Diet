//
//  DishCell.swift
//  Diet
//
//  Created by Даниил on 07/02/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import UIKit

class DishCell: UICollectionViewCell {

    @IBOutlet weak var dishCaloriesLabel: UILabel!
    @IBOutlet weak var dishNameLabel: UILabel!
    @IBOutlet weak var dishImageView: UIImageView!
    static var identifier = "DishCell"
    
    fileprivate let cellCornerRadius: CGFloat = 15
    
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = cellCornerRadius
        dishImageView.clipsToBounds = true 
        self.contentView.layer.cornerRadius = cellCornerRadius
        self.contentView.layer.masksToBounds = true
        
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
}
