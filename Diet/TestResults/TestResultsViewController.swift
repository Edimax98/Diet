//
//  TestResultsViewController.swift
//  Diet
//
//  Created by Даниил on 22/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import UIKit

class TestResultsViewController: UIViewController {

    @IBOutlet weak var genderIconImageView: UIImageView!
    @IBOutlet weak var genderTitleLabel: UILabel!
    @IBOutlet weak var currentWeightTitleLable: UILabel!
    @IBOutlet weak var ageTitleLabel: UILabel!
    @IBOutlet weak var goalWeightTitleLabel: UILabel!
    @IBOutlet weak var timeTitleLabel: UILabel!
    @IBOutlet weak var agreedWithTestButton: UIButton!
    @IBOutlet weak var takeTestAgainButton: UIButton!
    
    var repeatTest: (() -> Void)?
    var results: TestResult?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        takeTestAgainButton.layer.borderWidth = 1
        takeTestAgainButton.layer.borderColor = UIColor(red: 227 / 255, green: 227 / 255, blue: 227 / 255, alpha: 1).cgColor
        takeTestAgainButton.layer.cornerRadius = takeTestAgainButton.frame.height / 2
        agreedWithTestButton.layer.cornerRadius = agreedWithTestButton.frame.height / 2
        applyShadow(on: takeTestAgainButton.layer)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toObesityIndex" {
            
            if let destinationVc = segue.destination as? FatnessIndexViewContoller {
                guard var testResults = self.results else { return }
                
                let fatnessIndex = calculateFatIndex(currentWeight: testResults.currentWeight, height: testResults.height)
                
                switch(testResults.age) {
                case (0...25):
                    testResults.fatnessCategory = getFatnessCategoryNameForTeens(index: fatnessIndex)
                case (26...100):
                    testResults.fatnessCategory = getFatnessCategoryForAdults(index: fatnessIndex)
                default:
                    testResults.fatnessCategory = CategoryName.undefined
                }
                
                destinationVc.testResults = testResults
                destinationVc.fatnessIndex = fatnessIndex
            }
        }
    }
    
    fileprivate func getFatnessCategoryNameForTeens(index: Double) -> CategoryName {
        
        switch (index) {
        case(0...18.5):
            return CategoryName.underweight
        case(19.5...22.9):
            return CategoryName.normal
        case(23.0...27.4):
            return CategoryName.excessObesity
        case(27.5...29.9):
            return CategoryName.obesity
        case(30.0...100):
            return CategoryName.severeObesity
        default:
            return CategoryName.undefined
        }
    }
    
    fileprivate func getFatnessCategoryForAdults(index: Double) -> CategoryName {
        
        switch(index) {
        case (0...19.9):
            return CategoryName.underweight
        case (20.0...25.9):
            return CategoryName.normal
        case (26.0...27.9):
            return CategoryName.excessObesity
        case(28.0...30.9):
            return CategoryName.obesity
        case(31...100.0):
            return CategoryName.severeObesity
        default:
            return CategoryName.undefined
        }
    }
    
    fileprivate func applyShadow(on layer: CALayer) {
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 1
        layer.masksToBounds = false
    }
    
    fileprivate func calculateFatIndex(currentWeight: Int, height: Int) -> Double {
        
        var index = 0.0
        let heightFraction = Double(height) / 100.0
        let unroundedIndex = Double(currentWeight) / (heightFraction * heightFraction)
        index = unroundedIndex.rounded(toPlaces: 1)
        return index
    }
    
    @IBAction func agreedWithTestButtonPressed(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "hasUserPassedTest")
    }
    
    @IBAction func takeTestAgainButtonPressed(_ sender: Any) {
        self.dismiss(animated: true) {
            self.repeatTest?()
        }
    }
}

extension TestResultsViewController: TestResultOutput {
    
    func testCompleted(with result: TestResult) {
        self.results = result
        goalWeightTitleLabel.text = "\(result.goalWeight) " + "kg".localized
        currentWeightTitleLable.text = "\(result.currentWeight) " + "kg".localized
        timeTitleLabel.text = "\(result.height) " + "cm.".localized
        ageTitleLabel.text = "\(result.age)"
        genderTitleLabel.text = result.gender.description
    }
}
