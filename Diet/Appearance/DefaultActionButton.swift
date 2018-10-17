//
//  DefaultActionButton.swift
//  Diet
//
//  Created by Даниил on 17/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import UIKit

class DefaultActionButton: UIButton {
    
    private let cornerRadius: CGFloat = 8.0
    private let shadowOpacity: Float = 0.8
    private let shadowRadius: CGFloat = 12.0
    private let shadowOffset = CGSize(width: 12, height: 12)
    
    private func setupButton() {
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = false
        
//        self.layer.shadowColor = UIColor.gray.cgColor
//        self.layer.shadowOpacity = shadowOpacity
//        self.layer.shadowRadius = shadowRadius
//        self.layer.shadowOffset = shadowOffset
    }
}
