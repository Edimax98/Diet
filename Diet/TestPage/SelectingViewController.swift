//
//  SelectingViewController.swift
//  Diet
//
//  Created by Даниил on 18/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import UIKit

protocol PageSelectionHandler: class {
    
    func pageSelected(with index: Float, with lastIndex: Int)
}

class SelectingViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var answersPickerView: UIPickerView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    private let topGradientColor = UIColor(red: 59 / 255, green: 184 / 255, blue: 72 / 255, alpha: 1)
    private let bottomGradientColor = UIColor(red: 0, green: 158 / 255, blue: 91 / 255, alpha: 1)
    
    var prevIndexForProgressView: Float = 0.0
    var indexForProgressView: Float = 0.0
    var nextButtonPressed: ((Int) -> Void)?
    var backButtonPressed: (() -> Void)?
    var startPosition: CGFloat = 0
    var isReversed = false
    var testViewData: TestViewData?
    var shouldHideBanner = false
    var stepNumber = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        answersPickerView.delegate = self
        answersPickerView.dataSource = self
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        startPosition = foodImageView.frame.origin.x
        foodImageView.frame.origin.x = self.view.frame.width
        stepLabel.alpha = 0
        titleLabel.alpha = 0
        nextButton.alpha = 0
        answersPickerView.alpha = 0
        backButton.alpha = 0
        if isReversed == false {
            UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseInOut], animations: { [weak self] in
                self?.answersPickerView.alpha = 1
                self?.stepLabel.alpha = 1
                self?.titleLabel.alpha = 1
                self?.nextButton.alpha = 1
                self?.backButton.alpha = 1
            }, completion: nil)
            
            UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: { [weak self] in
                self?.foodImageView.frame.origin.x = self?.startPosition ?? 0
            }, completion: nil)
        } else {
            self.foodImageView.frame.origin.x = -(self.foodImageView.frame.width)
            UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseInOut], animations: { [weak self] in
                self?.answersPickerView.alpha = 1
                self?.stepLabel.alpha = 1
                self?.titleLabel.alpha = 1
                self?.nextButton.alpha = 1
                self?.backButton.alpha = 1
                }, completion: nil)
            
            UIView.animate(withDuration: 1, delay: 0.2, options: [.curveEaseInOut], animations: { [weak self] in
                self?.foodImageView.frame.origin.x = self?.startPosition ?? 0
                }, completion: nil)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.foodImageView.frame.origin.x = startPosition
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if isReversed == false {
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut], animations: { [weak self] in
                self?.foodImageView.frame.origin.x = -(self?.foodImageView.frame.width ?? 0)
            }, completion: nil)
        }
    }
    
    fileprivate func applyShadow(on layer: CALayer) {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 1
        layer.masksToBounds = false
    }
    
    fileprivate func setupView() {
        
        guard let data = testViewData else { return }
    
        view.applyGradient(colours: [topGradientColor,bottomGradientColor])
        foodImageView.image = UIImage(named: data.iconName)
        titleLabel.text = data.title
        stepLabel.text = "Step ".localized + "\(stepNumber)" + " of 5".localized
        nextButton.layer.cornerRadius = 15
        applyShadow(on: nextButton.layer)
        nextButton.setTitle("Next".localized, for: .normal)
    }

    
    @IBAction func nextButtonPressed(_ sender: Any) {
        nextButtonPressed?(answersPickerView.selectedRow(inComponent: 0))
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        backButtonPressed?()
    
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut], animations: { [weak self] in
            guard let self = self else { return }
            self.foodImageView.frame.origin.x = self.view.frame.width
            self.titleLabel.alpha = 0
            self.stepLabel.alpha = 0
            self.nextButton.alpha = 0
            self.backButton.alpha = 0
        }, completion: nil)
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
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        guard let data = testViewData else { return nil }
        
        var title = "\(data.pickerData[row])"
        
        let attributedString = NSAttributedString(string: title, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                                              NSAttributedString.Key.font: UIFont(name: "AvenirNext-Medium", size: 20.0) ?? UIFont.systemFont(ofSize: 20)])
        
        if let unit = data.unit {
            title = "\(data.pickerData[row])" + " " + unit
            return NSAttributedString(string: title, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                                  NSAttributedString.Key.font: UIFont(name: "AvenirNext-Medium", size: 20.0) ?? UIFont.systemFont(ofSize: 20)])
        }
        return attributedString
    }
}

extension SelectingViewController: PageSelectionHandler {
    
    func pageSelected(with index: Float, with lastIndex: Int) {
    }
}

