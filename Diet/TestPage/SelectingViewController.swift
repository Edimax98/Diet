//
//  SelectingViewController.swift
//  Diet
//
//  Created by Даниил on 18/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import UIKit

class SelectingViewController: UIViewController {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var answersPickerView: UIPickerView!
    @IBOutlet weak var containerOfTitlesView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var triangleView: Triangle!
    @IBOutlet weak var backButton: UIButton!
    
    var nextButtonPressed: (() -> Void)?
    var backButtonPressed: (() -> Void)?
    
    var testViewData: TestViewData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        answersPickerView.delegate = self
        answersPickerView.dataSource = self

        setupView()
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        nextButtonPressed?()
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
        progressView.layer.cornerRadius = progressView.frame.height / 2
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
