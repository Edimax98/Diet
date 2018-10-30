//
//  GenderSelectorViewController.swift
//  Diet
//
//  Created by Даниил on 19/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import UIKit

class GenderSelectorViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var containerTitleView: UIView!
    @IBOutlet weak var triangleView: Triangle!
    @IBOutlet weak var progressView: UIProgressView!
    
    var nextButtonPressed: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        progressView.progress = 0.2
        
        progressView.layer.cornerRadius = 9
        progressView.clipsToBounds = true
        progressView.layer.sublayers![1].cornerRadius = 9
        progressView.subviews[1].clipsToBounds = true
        
        maleButton.layer.cornerRadius = maleButton.frame.height / 2
        femaleButton.layer.cornerRadius = femaleButton.frame.height / 2
        nextButton.layer.cornerRadius = nextButton.frame.height / 2
        applyShadow(on: maleButton.layer)
        applyShadow(on: containerTitleView.layer)
        applyShadow(on: triangleView.layer)
        applyShadow(on: femaleButton.layer)
    }
    
    fileprivate func applyShadow(on layer: CALayer) {
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 1
        layer.masksToBounds = false
    }
    
    @IBAction func maleButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func femaleButtonPressed(_ sender: Any) {
    
    }

    @IBAction func nextButtonPressed(_ sender: Any) {
        nextButtonPressed?()
    }
}
