//
//  SubscriptionOffer.swift
//  Diet
//
//  Created by Даниил on 13/12/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import UIKit

class SubscriptionOfferViewController: UIViewController {

    @IBOutlet weak var arcView: UIView!
    @IBOutlet weak var restoreButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var startSubscriptionButton: UIButton!
    @IBOutlet weak var startButtonContainerView: UIView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var offset: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
 
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    
        print("!!!!!! ", self.arcView.frame.height / 2 + offset.constant)
        let path = UIBezierPath(arcCenter: CGPoint(x: arcView.frame.width / 2, y: arcView.bounds.origin.y + 23), radius: arcView.frame.height / 2, startAngle: CGFloat.pi, endAngle: 0, clockwise: true)
        
        arcView.layer.masksToBounds = false
        //arcView.layer.shadowRadius = arcView.frame.width / 2
        arcView.layer.shadowColor = UIColor.lightGray.cgColor
        arcView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        arcView.layer.shadowOpacity = 1
        arcView.layer.shadowPath = path.cgPath
    }
    
    fileprivate func setupView() {
        
        arcView.makeCornerRadius(arcView.frame.height / 2)
        restoreButton.makeCornerRadius(restoreButton.frame.height / 2)
        skipButton.makeCornerRadius(restoreButton.frame.height / 2)
        startSubscriptionButton.makeCornerRadius(startSubscriptionButton.frame.height / 2)
        startButtonContainerView.makeCornerRadius(startButtonContainerView.frame.height / 2)
        cardView.makeCornerRadius(32)
        cardView.dropShadow(opacity: 0.3, offSet: CGSize(width: 1, height: 1), radius: 16)

        arcView.dropShadow(opacity: 0.3, offSet: CGSize(width: 1, height: 1), radius: 16)
    }
}
