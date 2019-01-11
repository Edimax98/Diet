//
//  DietViewController.swift
//  Diet
//
//  Created by Даниил on 06/12/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import UIKit
import DropDown
import Alamofire
import AlamofireImage

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
    var accessStatus = AccessStatus.denied
    fileprivate let dropMenuItems = ["Monday".localized,"Tuesday".localized,
                                     "Wednesday".localized,"Thursday".localized,
                                     "Friday".localized,"Saturday".localized,
                                     "Sunday".localized]
    
    let gramMeasure = "g.".localized
    let caloriesMesure = "kCal".localized
    weak var recipeSender: RecipeReciver?
    let dropDownMenu = DropDown()
    private var previousStatusBarHidden = false
    fileprivate var diet: Diet!
    fileprivate var dishes = [Dish]()
    fileprivate let fetchingQueue = DispatchQueue.global(qos: .utility)
    fileprivate let cashedImage = NSCache<AnyObject, AnyObject>()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showRecipe" {
            if let destinationVc = segue.destination as? RecipeViewController {
                recipeSender = destinationVc
            }
        }
    }
    
    let networkService = NetworkService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionViewFlowLayout()
        setupView()
        setupDropDownMenu()
        
        networkService.dietServiceDelegate = self
        networkService.getDiet()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if accessStatus == .denied {
            weekdaysDropDownButton.isEnabled = false
        }
    }
    
    fileprivate func showContent() {
        weekdaysDropDownButton.isEnabled = true
        dishesCollectionView.reloadData()
    }
    
    fileprivate func setupView() {
        
        dietDescriptionLabel.text = "..."
        dietNameLabel.text = "..."
        
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        dietBackImageView.contentMode = .scaleAspectFill
        dietBackImageView.clipsToBounds = true
        
        dishesCollectionView.dataSource = self
        dishesCollectionView.delegate = self
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
        
        dropDownMenu.dataSource = dropMenuItems
        dropDownMenu.cornerRadius = dropDownButtonContainerView.frame.height / 2
        dropDownMenu.anchorView = dropDownButtonContainerView
        dropDownMenu.direction = .any
        dropDownMenu.bottomOffset = CGPoint(x: 0.0, y: dropDownButtonContainerView.frame.height + 5)
        
        dropDownMenu.cancelAction = { [weak self] in
            guard let unwrappedSelf = self else { print("Could not animate. Self is nil."); return }
            unwrappedSelf.animateButtonArrowRotation(rotationAngle: CGFloat(Double.pi * 2))
        }
        
        dropDownMenu.selectionAction = { [weak self] (index,item) in
            guard let unwrappedSelf = self else { print("Could not set button title. Self is nil."); return }
            if let unwrppedDiet = unwrappedSelf.diet, let week = unwrppedDiet.weeks.first {
                unwrappedSelf.dishes = week.days[index].dishes
                unwrappedSelf.dishesCollectionView.reloadData()
            }
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
        return dishes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DishCell.identifier, for: indexPath) as? DishCell else {
            print("Could not deque cell")
            return UICollectionViewCell()
        }
        
        if accessStatus == .denied {
            cell.hide()
            return cell
        }
        cell.open()
        
        if dishes.isEmpty {
            return cell
        }
        
        let dish = dishes[indexPath.row]
        
        cell.showRecipeButtonPressed = { [weak self] in
            guard let unwrappedSelf = self else { return }
            unwrappedSelf.performSegue(withIdentifier: "showRecipe", sender: cell)
            unwrappedSelf.recipeSender?.recieve(recipe: dish.recipe, dishName: dish.name)
        }
        
        cell.dishNameLabel.text = dish.name
        cell.proteinsAmountLabel.text = "\(dish.nutritionValue.protein)" + gramMeasure
        cell.carbsAmountLabel.text = "\(dish.nutritionValue.carbs)" + gramMeasure
        cell.fatsAmountLabel.text = "\(dish.nutritionValue.fats)" + gramMeasure
        cell.caloriesAmountLabel.text = "\(dish.nutritionValue.calories)" + caloriesMesure
        
        
        cell.dishImageView.image = nil
        if let imageFromCache = cashedImage.object(forKey: dish.imagePath as AnyObject) as? UIImage {
            cell.dishImageView.image = imageFromCache
            return cell
        }
        
        fetchingQueue.async {
            request(dish.imagePath, method: .get).responseImage { (response) in
                guard let image = response.result.value else {
                    DispatchQueue.main.async {
                        cell.dishImageView.image = UIImage(named: "no_food")
                    }
                    print("Image for dish  - \(dish.name) is NIL")
                    return
                }
                DispatchQueue.main.async {
                    cell.dishImageView.image = image
                    self.cashedImage.setObject(image, forKey: dish.imagePath as AnyObject)
                }
            }
        }

        return cell
    }
}

extension DietViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if accessStatus == .denied {
            performSegue(withIdentifier: "showSubOffer", sender: self)
        }
    }
}

extension DietViewController: DietNetworkServiceDelegate {
    
    func dietNetworkServiceDidGet(_ diet: Diet) {
        
        DispatchQueue.main.async {
            self.dietNameLabel.text = diet.name
            self.dietDescriptionLabel.text = diet.description
            self.diet = diet
            if let dishes = diet.weeks.first?.days.first?.dishes {
                self.dishes = dishes
                self.dishesCollectionView.reloadData()
            }
        }
    }
    
    func fetchingEndedWithError(_ error: Error) {
        
    }
}

extension DietViewController: ContentAccessHandler {
    
    func accessIsDenied() {
        accessStatus = .denied
        let subscriptionOfferVc = SubscriptionOfferViewController.controllerInStoryboard(UIStoryboard(name: "SubscriptionOffer", bundle: nil))
        present(subscriptionOfferVc, animated: true, completion: nil)
    }
    
    func accessIsAvailable() {
        accessStatus = .available
        showContent()
    }
}
