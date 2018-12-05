//
//  GenderSelectorViewController.swift
//  Diet
//
//  Created by Даниил on 19/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import UIKit
import FBAudienceNetwork

enum Gender: String {
    case male = "Male"
    case female = "Female"
    case undefined = "Undefined"
}

class GenderSelectorViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var containerTitleView: UIView!
    @IBOutlet weak var triangleView: Triangle!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var maleGenderView: UIView!
    @IBOutlet weak var femaleGenderView: UIView!
    @IBOutlet weak var maleButtonSelectionIndicator: UIView!
    @IBOutlet weak var femaleButtonSelectionIndicator: UIView!
    @IBOutlet weak var adBannerView: UIView!
    var adView: FBAdView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    var indexForProgressView: Float = 0.2
    
    var nextButtonPressed: (() -> Void)?
    var genderSelected: ((Gender) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        progressView.layer.cornerRadius = 9
        progressView.clipsToBounds = true
        progressView.layer.sublayers![1].cornerRadius = 9
        progressView.subviews[1].clipsToBounds = true
        
        maleButtonSelectionIndicator.layer.cornerRadius = maleButtonSelectionIndicator.frame.height / 2
        femaleButtonSelectionIndicator.layer.cornerRadius = femaleButtonSelectionIndicator.frame.height / 2
        femaleButtonSelectionIndicator.isHidden = true
        maleButtonSelectionIndicator.isHidden = true
        
        maleGenderView.layer.cornerRadius = maleGenderView.frame.height / 2
        femaleGenderView.layer.cornerRadius = femaleGenderView.frame.height / 2
        
        adView = FBAdView(placementID: "317759862160517_317760728827097", adSize: kFBAdSizeHeight50Banner, rootViewController: self)
        adView.delegate = self
        adView.loadAd()
        
        applyShadow(on: containerTitleView.layer)
        applyShadow(on: triangleView.layer)
        applyShadow(on: maleGenderView.layer)
        applyShadow(on: femaleGenderView.layer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        progressView.setProgress(indexForProgressView, animated: true)
    }
    
    fileprivate func applyShadow(on layer: CALayer) {
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 1
        layer.masksToBounds = false
    }
    
    @IBAction func maleButtonPressed(_ sender: Any) {
        genderSelected?(.male)
        maleButton.isSelected = !maleButton.isSelected
        if maleButton.isSelected {
            femaleButton.isSelected = false
            femaleButtonSelectionIndicator.isHidden = true
            maleButtonSelectionIndicator.isHidden = false
        }
    }
    
    @IBAction func femaleButtonPressed(_ sender: Any) {
        genderSelected?(.female)
        femaleButton.isSelected = !femaleButton.isSelected
        if femaleButton.isSelected {
            maleButton.isSelected = false
            maleButtonSelectionIndicator.isHidden = true
            femaleButtonSelectionIndicator.isHidden = false
        }
    }
}

extension GenderSelectorViewController: FBAdViewDelegate {
    
    func adViewDidLoad(_ adView: FBAdView) {
        if adBannerView != nil {
            adView.frame = adBannerView.bounds
            adBannerView.addSubview(adView)
        } else if adBannerView != nil {
            adView.removeFromSuperview()
            topConstraint.constant = 0.0
            self.view.layoutIfNeeded()
        }
    }
    
    func adView(_ adView: FBAdView, didFailWithError error: Error) {
        print(error)
        self.adView.removeFromSuperview()
        topConstraint.constant = 0.0
        self.view.layoutIfNeeded()
    }
}
