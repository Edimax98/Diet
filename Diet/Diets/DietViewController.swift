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
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    
    let screenHeight = UIScreen.main.bounds.height
    let scrollViewContentHeight: CGFloat = 1200
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
    let networkService = NetworkService()
    let loadingVc = LoadingViewController()

    private var visibleRect: CGRect {
        get {
            return CGRect(x: 0.0,
                          y: scrollView!.contentOffset.y,
                          width: scrollView!.frame.size.width,
                          height: scrollView!.frame.size.height)
        }
    }
    
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
        tableHeightConstraint.constant = self.view.frame.height
        rationsTableView.isScrollEnabled = false
        dietDescriptionView.makeCornerRadius(15)
        scrollView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {

        dietDescriptionView.layer.shadowColor = UIColor.black.cgColor
        dietDescriptionView.layer.shadowOpacity = 1
        dietDescriptionView.layer.shadowOffset = CGSize(width: 1, height: 1)
        dietDescriptionView.layer.shadowRadius = 7
        dietDescriptionView.layer.shadowPath = UIBezierPath(rect: dietDescriptionView.bounds).cgPath
       // dietDescriptionView.layer.shouldRasterize = false
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
        
        if let unwrppedDiet = diet, let week = unwrppedDiet.weeks.first {
            dishes = week.days[indexPath.section].dishes
            cell.weekDishes = dishes
            cell.cellTapped = { [weak self] (dish) in
                guard let self = self else { return }
                self.performSegue(withIdentifier: "showRecipe", sender: self)
                self.recipeSender?.recieve(dish: dish)
            }
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
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 22)!
        label.text = daysOfWeek[section]
        view.backgroundColor = .white
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
}

extension DietViewController: UIScrollViewDelegate {
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//
//        let contentOffset = scrollView.contentOffset
//
//        // This is the visible rect of the parent scroll view
//        let visibleRect = self.visibleRect
//        // This is the current offset into parent scroll view
//        let mainOffsetY = contentOffset.y
//
//        let w = scrollView.frame.size.width
//
//        rationsTableView.isScrollEnabled = false // disable scrolling so it does not interfere with the parent scroll
//        let tableRect = rationsTableView.frame // get the ideal rect (occupied space)
//        // evaluate the visible region in parent
//        let itemVisibleRect = visibleRect.intersection(tableRect)
//
//        if itemVisibleRect.height == 0.0 {
//            // If not visible the frame of the inner's scroll is canceled
//            // No cells are rendered until the item became partially visible
//            rationsTableView.frame = CGRect.zero
//        } else {
//            // The item is partially visible
//            if mainOffsetY > tableRect.minY {
//                // If during scrolling the inner table/collection has reached the top
//                // of the parent scrollview it will be pinned on top
//
//                // This calculate the offset reached while scrolling the inner scroll
//                // It's used to adjust the inner table/collection offset in order to
//                // simulate continous scrolling
////                scrollView.bounces = false
//                let innerScrollOffsetY = mainOffsetY - tableRect.minY
//                // This is the height of the visible region of the inner table/collection
//                let visibleInnerHeight = rationsTableView.contentSize.height
//
//                var innerScrollRect = CGRect.zero
//                innerScrollRect.origin = CGPoint(x: 0, y: innerScrollOffsetY)
//                if visibleInnerHeight < visibleRect.size.height {
//                    // partially visible when pinned on top
//                    innerScrollRect.size = CGSize(width: w, height: min(visibleInnerHeight,itemVisibleRect.height))
//                } else {
//                    // the inner scroll occupy the entire parent scroll's height
//                    innerScrollRect.size = itemVisibleRect.size
//                }
//                rationsTableView.frame = innerScrollRect
//                // adjust the offset to simulate the scroll
//                rationsTableView.isScrollEnabled = true
//                scrollView.bounces = false
//                rationsTableView.contentOffset = CGPoint(x: 0, y: innerScrollOffsetY + 100)
//            } else {
//                // The inner scroll view is partially visible
//                // Adjust the frame as it needs (at its max it reaches the height of the parent)
////                /scrollView.bounces = true
//                let offsetOfInnerY = tableRect.minY - mainOffsetY
//                let visibileHeight = visibleRect.size.height - offsetOfInnerY
//
//                rationsTableView.frame = CGRect(x: 0, y: 0, width: w, height: visibileHeight)
//                rationsTableView.contentOffset = CGPoint.zero
//            }
//        }
//
//    }
//
//    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
//
//        if scrollView === rationsTableView, scrollView.contentOffset.y <= 20 {
//            let offset = scrollView.frame.height - tableHeightConstraint.constant - 10
//
//            self.scrollView.contentOffset.y = offset
//        }
//
//    }
    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        if scrollView === rationsTableView, scrollView.contentOffset.y <= 20 {
//            let offset = scrollView.frame.height - tableHeightConstraint.constant - 10
//
//            self.scrollView.contentOffset.y = offset
//        }
//    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if scrollView === self.scrollView {
            self.scrollView.bounces = (scrollView.contentOffset.y <= rationsTableView.frame.minY)
            rationsTableView.isScrollEnabled = (scrollView.contentOffset.y >= rationsTableView.frame.minY)
        }

        if scrollView === rationsTableView {
            rationsTableView.isScrollEnabled = (scrollView.contentOffset.y > 0)
            rationsTableView.bounces = (scrollView.contentOffset.y != 0)
        }
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
