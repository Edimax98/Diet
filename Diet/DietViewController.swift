//
//  DietViewController.swift
//  Diet
//
//  Created by Даниил on 06/12/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import UIKit
import DropDown

class DietViewController: UIViewController {
    
    @IBOutlet weak var dietBackImageView: UIImageView!
    @IBOutlet weak var dietNameLabel: UILabel!
    @IBOutlet weak var dietDescriptionLabel: UILabel!
    @IBOutlet weak var weekdaysDropDownButton: UIButton!
    @IBOutlet weak var dropDownButtonContainerView: UIView!
    
    let dropDownMenu = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dietDescriptionLabel.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur."
        dietNameLabel.text = "Diet name"
        dropDownMenu.dataSource = ["Monday","Tuesday","Friday"]
        
        dropDownButtonContainerView.layer.cornerRadius = dropDownButtonContainerView.frame.height / 2
        dropDownButtonContainerView.layer.masksToBounds = true
    }
    
    @IBAction func showWeekdaysButtonPressed(_ sender: Any) {
        dropDownMenu.cornerRadius = dropDownButtonContainerView.frame.height / 2
        dropDownMenu.anchorView = dropDownButtonContainerView
        dropDownMenu.direction = .bottom
        dropDownMenu.bottomOffset = CGPoint(x: 0.0, y: dropDownButtonContainerView.frame.height + 5)
        dropDownMenu.show()
    }
}
