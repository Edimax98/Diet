//
//  TriangleView.swift
//  Diet
//
//  Created by Даниил on 18/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import UIKit

class Triangle: UIView {
    
    override func draw(_ rect: CGRect) {
        let mask = CAShapeLayer()
        
        let width = self.layer.frame.size.width
        let height = self.layer.frame.size.height
        
        let path = CGMutablePath()
        
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: width, y: 0))
        path.addLine(to: CGPoint(x: width / 2, y: height))
        path.addLine(to: CGPoint(x: 0, y: 0))
        
        let triangleShadow = CGMutablePath()
        
        triangleShadow.move(to: CGPoint(x: 0, y: 5))
        triangleShadow.addLine(to: CGPoint(x: width - 5, y: 5))
        triangleShadow.addLine(to: CGPoint(x: width / 2 - 5, y: height + 5))
        triangleShadow.addLine(to: CGPoint(x: 0, y: 5))
        
//        mask.shadowColor = UIColor.lightGray.cgColor
//        mask.shadowOffset = CGSize(width: 5, height: 4)
//        mask.shadowOpacity = 0.25
//        mask.shadowRadius = 1
//        mask.masksToBounds = false
        mask.shadowPath = triangleShadow
        mask.path = path
        self.layer.mask = mask
//        self.layer.shadowColor = UIColor.black.cgColor
//        self.layer.shadowOffset = CGSize(width: 5, height: 4)
//        self.layer.shadowPath = triangleShadow
//        self.layer.masksToBounds = false

    }
}
