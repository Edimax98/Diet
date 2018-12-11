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
    @IBOutlet weak var buttonArrowImageView: UIImageView!
    @IBOutlet weak var dishesCollectionView: UICollectionView!
    @IBOutlet weak var weekDaySelectionView: UIView!
    @IBOutlet weak var dietDescriptionView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    fileprivate let viewCornerRadius: CGFloat = 32.0
    
    let dropDownMenu = DropDown()
    private var previousStatusBarHidden = false
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionViewFlowLayout()
        setupView()
        setupDropDownMenu()
    }
    
    fileprivate func setupView() {
        
        dietDescriptionLabel.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur."
        dietNameLabel.text = "Diet name"
        
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        dietBackImageView.contentMode = .scaleAspectFill
        dietBackImageView.clipsToBounds = true
        
        dishesCollectionView.dataSource = self
        dishesCollectionView.register(UINib(nibName: "DishCell", bundle: nil), forCellWithReuseIdentifier: DishCell.identifier)
        
        weekDaySelectionView.layer.cornerRadius = viewCornerRadius
        weekDaySelectionView.layer.masksToBounds = true
        dietDescriptionView.layer.cornerRadius = viewCornerRadius
        dietDescriptionView.layer.masksToBounds = true
    }
    
    fileprivate func setupCollectionViewFlowLayout() {
        let layout = dishesCollectionView.collectionViewLayout as! UPCarouselFlowLayout
        layout.spacingMode = UPCarouselFlowLayoutSpacingMode.fixed(spacing: 10)
        layout.sideItemScale = 0.9
    }
    
    override func viewDidLayoutSubviews() {
        dietDescriptionView.dropShadow(offSet: CGSize(width: 1, height: 1), radius: 16)
        weekDaySelectionView.dropShadow(offSet: CGSize(width: 1, height: 1), radius: 16)
    }
    
    fileprivate func animateButtonArrowRotation(rotationAngle: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.buttonArrowImageView.transform = CGAffineTransform(rotationAngle: rotationAngle)
        }
    }
    
    fileprivate func setupDropDownMenu() {
        
        dropDownButtonContainerView.layer.cornerRadius = dropDownButtonContainerView.frame.height / 2
        dropDownButtonContainerView.layer.masksToBounds = true
        
        dropDownMenu.dataSource = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
        dropDownMenu.cornerRadius = dropDownButtonContainerView.frame.height / 2
        dropDownMenu.anchorView = dropDownButtonContainerView
        dropDownMenu.direction = .bottom
        dropDownMenu.bottomOffset = CGPoint(x: 0.0, y: dropDownButtonContainerView.frame.height + 5)
        
        dropDownMenu.cancelAction = { [weak self] in
            guard let unwrappedSelf = self else { print("Could not animate. Self is nil."); return }
            unwrappedSelf.animateButtonArrowRotation(rotationAngle: CGFloat(Double.pi * 2))
        }
        
        dropDownMenu.selectionAction = { [weak self] (index,item) in
            guard let unwrappedSelf = self else { print("Could not set button title. Self is nil."); return }
            unwrappedSelf.animateButtonArrowRotation(rotationAngle: CGFloat(Double.pi * 2))
            unwrappedSelf.weekdaysDropDownButton.setTitle(item, for: .normal)
        }
    }
    
    @IBAction func showWeekdaysButtonPressed(_ sender: Any) {
        
        animateButtonArrowRotation(rotationAngle:  CGFloat(Double.pi))
        dropDownMenu.show()
    }
}

extension DietViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DishCell.identifier, for: indexPath) as? DishCell else {
            print("Could not deque cell")
            return UICollectionViewCell()
        }
        return cell
    }
}
