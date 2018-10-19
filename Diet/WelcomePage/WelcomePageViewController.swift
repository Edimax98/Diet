//
//  WelcomePageViewController.swift
//  Diet
//
//  Created by Даниил on 17/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import UIKit

class WelcomePageViewController: UIViewController {
    
    @IBOutlet weak var iconPageImageView: UIImageView!
    @IBOutlet weak var pageTitleLable: UILabel!
    @IBOutlet weak var pageDescriptionLable: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        pageControl.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.layer.cornerRadius = nextButton.frame.height / 2
    }

    @IBAction func nextButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "segueToTestView", sender: nil)
    }
}

