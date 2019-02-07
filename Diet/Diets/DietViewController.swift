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
    @IBOutlet weak var dietDescriptionView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var rationsTableView: UITableView!
    
    fileprivate let viewCornerRadius: CGFloat = 32.0
    var accessStatus = AccessStatus.available
    fileprivate let daysOfWeek = ["Monday".localized,"Tuesday".localized,
                                     "Wednesday".localized,"Thursday".localized,
                                     "Friday".localized,"Saturday".localized,
                                     "Sunday".localized]
    
    let gramMeasure = "g.".localized
    let caloriesMesure = "kCal.".localized
    weak var recipeSender: RecipeReciver?
    let dropDownMenu = DropDown()
    private var previousStatusBarHidden = false
    fileprivate var diet: Diet!
    fileprivate var dishes = [Dish]()
    fileprivate let fetchingQueue = DispatchQueue.global(qos: .utility)
    fileprivate let cashedImage = NSCache<AnyObject, AnyObject>()
    let networkService = NetworkService()
    let loadingVc = LoadingViewController()

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        networkService.dietServiceDelegate = self
        networkService.getDiet()
        add(loadingVc)
    }
    
    fileprivate func showContent() {

    }
    
    fileprivate func setupView() {
        
        dietDescriptionLabel.text = "..."
        dietNameLabel.text = "..."
        
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        dietBackImageView.contentMode = .scaleAspectFill
        dietBackImageView.clipsToBounds = true
        
        rationsTableView.separatorStyle = .none
        rationsTableView.dataSource = self
        rationsTableView.delegate = self
        rationsTableView.register(UINib(nibName: "WeekRationCell", bundle: nil), forCellReuseIdentifier: WeekRationCell.identifier)
        
        dietDescriptionView.layer.cornerRadius = viewCornerRadius
        dietDescriptionView.layer.masksToBounds = true
    }
    
    override func viewDidLayoutSubviews() {
        dietDescriptionView.dropShadow(offSet: CGSize(width: 1, height: 1), radius: 16)
    }
}

extension DietViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return daysOfWeek.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return daysOfWeek[section]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeekRationCell.identifier, for: indexPath) as? WeekRationCell else {
            print("Could not deque cell")
            return UITableViewCell()
        }
        
//        if dishes.isEmpty {
//            return cell
//        }
        
        if let unwrppedDiet = diet, let week = unwrppedDiet.weeks.first {
            dishes = week.days[indexPath.section].dishes
            cell.weekDishes = dishes
        }
        return cell
    }
}

extension DietViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        let label = UILabel(frame: CGRect(x: 20, y: view.frame.midY - 15, width: view.frame.width - 40, height: 30))
        view.addSubview(label)
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 20)!
        label.text = daysOfWeek[section]
        view.backgroundColor = .white
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
}

extension DietViewController: DietNetworkServiceDelegate {
    
    func dietNetworkServiceDidGet(_ diet: Diet) {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self else { return }
            
            self.loadingVc.remove()
            self.dietNameLabel.text = diet.name
            self.dietDescriptionLabel.text = diet.description
            self.diet = diet
            if let dishes = diet.weeks.first?.days.first?.dishes {
                self.dishes = dishes
                self.rationsTableView.reloadData()
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
