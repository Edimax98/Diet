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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    class func instance() -> WelcomePageViewController {
        
        let storyboard = UIStoryboard(name: "WelcomePageViewController", bundle: nil)
        return storyboard.instantiateInitialViewController() as! WelcomePageViewController
    }

    
    @IBAction func nextButtonPressed(_ sender: Any) {
    }
}
