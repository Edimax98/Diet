//
//  SelectingViewController.swift
//  Diet
//
//  Created by Даниил on 18/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import UIKit
import FBAudienceNetwork

protocol PageSelectionHandler: class {
    
    func pageSelected(with index: Float, with lastIndex: Int)
}

class SelectingViewController: UIViewController {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var answersPickerView: UIPickerView!
    @IBOutlet weak var containerOfTitlesView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var triangleView: Triangle!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
  //  @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var adHeight: NSLayoutConstraint!
    
    @IBOutlet weak var adBannerView: UIView!
    @IBOutlet weak var nextButtonWidthConstraint: NSLayoutConstraint!
    
    var prevIndexForProgressView: Float = 0.0
    var indexForProgressView: Float = 0.0
    var nextButtonPressed: ((Int) -> Void)?
    var backButtonPressed: (() -> Void)?
    
    var testViewData: TestViewData?
    var adView: FBAdView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        answersPickerView.delegate = self
        answersPickerView.dataSource = self
        
        progressView.layer.cornerRadius = 9
        progressView.clipsToBounds = true
        progressView.layer.sublayers![1].cornerRadius = 9
        progressView.subviews[1].clipsToBounds = true
        
        adView = FBAdView(placementID: "VID_HD_16_9_46S_APP_INSTALL#317759862160517_317760728827097", adSize: kFBAdSizeHeight50Banner, rootViewController: self)
        adView.delegate = self
        adView.loadAd()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        nextButton.isHidden = false
        nextButton.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        
        UIView.animate(withDuration: 0.3) {
            self.nextButton.transform = CGAffineTransform.identity
        }
        
        progressView.setProgress(indexForProgressView, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let buttonBounds = nextButton.bounds
        
        UIView.animate(withDuration: 0.2, animations: {
            self.nextButton.bounds = CGRect(x: buttonBounds.minX, y: buttonBounds.maxY, width: buttonBounds.width - buttonBounds.width, height: buttonBounds.height - buttonBounds.height)
        }) { (flag) in
            self.nextButton.isHidden = true
        }
        progressView.setProgress(prevIndexForProgressView, animated: true)
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        nextButtonPressed?(answersPickerView.selectedRow(inComponent: 0))
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        backButtonPressed?()
    }
    
    fileprivate func setupView() {
        
        guard let data = testViewData else { return }
        
        nextButton.setTitle("Next".localized, for: .normal)
        nextButton.layer.cornerRadius = nextButton.frame.height / 2
        iconImageView.image = UIImage(named: data.iconName)
        titleLabel.text = data.title
        containerOfTitlesView.layer.shadowColor = UIColor.lightGray.cgColor
        containerOfTitlesView.layer.shadowOffset = CGSize(width: 0, height: 5)
        containerOfTitlesView.layer.shadowOpacity = 0.25
        containerOfTitlesView.layer.shadowRadius = 1
        containerOfTitlesView.layer.masksToBounds = false
    }
}

extension SelectingViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let data = testViewData else { return 0 }
        return data.pickerData.count
    }
}

extension SelectingViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let data = testViewData else { return nil }
        
        if let unit = data.unit {
            return "\(data.pickerData[row])" + " " + unit
        }
        return "\(data.pickerData[row])"
    }
}

extension SelectingViewController: FBAdViewDelegate {
    
    func adViewDidLoad(_ adView: FBAdView) {
        if adBannerView != nil {
            adView.frame = CGRect(x: 0, y: 20, width: adBannerView.frame.width, height: adBannerView.frame.height - 20)
            adBannerView.addSubview(adView)
        } else if adBannerView != nil {
            adView.removeFromSuperview()
            adHeight.constant = 0.0
            self.view.layoutIfNeeded()
        }
    }
    
    func adView(_ adView: FBAdView, didFailWithError error: Error) {
        print(error)
        self.adView.removeFromSuperview()
        adHeight.constant = 0.0
        self.view.layoutIfNeeded()
    }
}

extension SelectingViewController: PageSelectionHandler {
    
    func pageSelected(with index: Float, with lastIndex: Int) {
    }
}

