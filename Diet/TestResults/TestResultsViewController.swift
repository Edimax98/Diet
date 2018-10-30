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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
            takeTestAgainButton.layer.borderWidth = 1
            takeTestAgainButton.layer.borderColor = UIColor(red: 227 / 255, green: 227 / 255, blue: 227 / 255, alpha: 1).cgColor
            takeTestAgainButton.layer.cornerRadius = takeTestAgainButton.frame.height / 2
            agreedWithTestButton.layer.cornerRadius = agreedWithTestButton.frame.height / 2
            applyShadow(on: takeTestAgainButton.layer)
    }
    
    fileprivate func applyShadow(on layer: CALayer) {
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 1
        layer.masksToBounds = false
    }
    
    @IBAction func agreedWithTestButtonPressed(_ sender: Any) {
    
    }
    
    @IBAction func takeTestAgainButtonPressed(_ sender: Any) {
    
    }
}
