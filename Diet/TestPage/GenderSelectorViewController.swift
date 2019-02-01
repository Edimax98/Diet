//
//  GenderSelectorViewController.swift
//  Diet
//
//  Created by Даниил on 19/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import UIKit

enum Gender: String {
    case male
    case female
    case undefined
    
    var description: String {
        get {
            switch self {
            case .male:
                return "Male".localized
            case .female:
                return "Female".localized
            case .undefined:
                return "Undefined".localized
            }
        }
    }
}

class GenderSelectorViewController: UIViewController {

    @IBOutlet weak var genderStackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var femaleIconImageView: UIImageView!
    @IBOutlet weak var maleIconImageView: UIImageView!
    @IBOutlet weak var fruitImageView: UIImageView!
    @IBOutlet weak var stepsLabel: UILabel!
    
    private let topGradientColor = UIColor(red: 59 / 255, green: 184 / 255, blue: 72 / 255, alpha: 1)
    private let bottomGradientColor = UIColor(red: 0, green: 158 / 255, blue: 91 / 255, alpha: 1)
    
    var nextButtonPressed: (() -> Void)?
    var genderSelected: ((Gender) -> Void)?

    var leavesImages = [UIImageView]()
    var countOfLeavesImages = 5
    var genderStackViewStartPosition: CGFloat = 0
    var foodImageStartPosition: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        stepsLabel.alpha = 0
        
        UIView.animate(withDuration: 0.7, animations: { [weak self] in
            guard let self = self else { return }
            self.genderStackView.frame.origin.x = self.genderStackViewStartPosition
            self.fruitImageView.frame.origin.x = self.foodImageStartPosition
        }) { _ in
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.stepsLabel.alpha = 1
            }
        }
        
//        UIView.animateKeyframes(withDuration: 0.8, delay: 0, options: [.calculationModeCubic], animations: { [weak self] in
//            guard let self = self else { return }
//
//            var startTime = 0.0
//            let relativeDuration = 0.1 / 0.8
//
//            for leaf in self.leavesImages {
//                UIView.addKeyframe(withRelativeStartTime: startTime, relativeDuration: relativeDuration, animations: {
//
//                })
//                startTime += 0.1
//            }
//        }, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIView.animate(withDuration: 1) { [weak self] in
            guard let self = self else { return }
            self.genderStackView.frame.origin.x = -(self.genderStackView.frame.width)
            self.fruitImageView.frame.origin.x = -(self.fruitImageView.frame.width)
        }
        
        for leaf in leavesImages {
            leaf.frame.origin.x = -leaf.frame.width
        }
    }
    
    private func setupView() {

        genderStackViewStartPosition = genderStackView.frame.origin.x
        foodImageStartPosition = fruitImageView.frame.origin.x
        femaleButton.layer.cornerRadius = femaleButton.frame.height / 2
        maleButton.layer.cornerRadius = maleButton.frame.height / 2
        view.applyGradient(colours: [topGradientColor, bottomGradientColor])
    
//        for _ in 0...countOfLeavesImages {
//            guard let image = UIImage(named: "leaf") else { return }
//            leavesImages.append(UIImageView(image: image))
//        }
//
//        var yPosition: CGFloat = 0.0
//        for leaf in leavesImages {
//            let randomSize = CGFloat.random(in: (20..<40))
//            leaf.frame = CGRect(x: 0, y: yPosition, width: randomSize, height: randomSize)
//            leaf.contentMode = .scaleAspectFit
//            leaf.backgroundColor = .white
//            view.addSubview(leaf)
//            //yPosition += 100
//        }
    }
    
    @IBAction func maleButtonPressed(_ sender: Any) {
        genderSelected?(.male)
    }
    
    @IBAction func femaleButtonPressed(_ sender: Any) {
        genderSelected?(.female)
    }
}
