//
//  TestPageViewController.swift
//  Diet
//
//  Created by Даниил on 18/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import UIKit

class TestPageViewController: UIPageViewController {

    var testPages = [UIViewController]()
    var testViewData = [TestViewData]()
    
    let ageSelectionPage = SelectingViewController.controllerInStoryboard(UIStoryboard(name: "SelectingViewController", bundle: nil))
    let currentWeightSelectionPage = SelectingViewController.controllerInStoryboard(UIStoryboard(name: "SelectingViewController", bundle: nil))
    let goalWeightSelectionPage = SelectingViewController.controllerInStoryboard(UIStoryboard(name: "SelectingViewController", bundle: nil))
    let timeSelectionPage = SelectingViewController.controllerInStoryboard(UIStoryboard(name: "SelectingViewController", bundle: nil))
    
    let ageSelectionPageData = TestViewData(title: "Select your age".localized,
                                            iconName: "heart-beat", pickerData: (10,99))
    let currentWeightSelectionPageData = TestViewData(title: "Select your weight".localized,
                                                      iconName: "weight-scale", pickerData: (50,99), unit: "kg".localized)
    let goalWeightSelectionPageData = TestViewData(title: "How much do you want to lose in weight".localized,
                                                   iconName: "diet", pickerData: (1,99), unit: "kg".localized)
    let timeSelectionPageData = TestViewData(title: "How fast do you want to lose in weight".localized,
                                         iconName: "timer", pickerData: (1,30), unit: "weeks".localized)
    
    required init?(coder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        self.view.backgroundColor = UIColor(red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 1)
        fillPages()
        fillViewData()
        setupSelectionTestPages()
        setViewControllers([testPages.first!], direction: .forward, animated: true, completion: nil)
    }
    
    fileprivate func fillViewData() {
    
        testViewData.append(ageSelectionPageData)
        testViewData.append(currentWeightSelectionPageData)
        testViewData.append(goalWeightSelectionPageData)
        testViewData.append(timeSelectionPageData)
    }
    
    fileprivate func fillPages() {
        
        testPages.append(ageSelectionPage)
        testPages.append(currentWeightSelectionPage)
        testPages.append(goalWeightSelectionPage)
        testPages.append(timeSelectionPage)
    }
    
    fileprivate func setupSelectionTestPages() {
        
        ageSelectionPage.testViewData = ageSelectionPageData
        currentWeightSelectionPage.testViewData = currentWeightSelectionPageData
        goalWeightSelectionPage.testViewData = goalWeightSelectionPageData
        timeSelectionPage.testViewData = timeSelectionPageData
        let _ = timeSelectionPage.view
        timeSelectionPage.nextButton.setTitle("Finish".localized, for: .normal)
    }
    
    fileprivate func setupGenderSelectionPage(_ page: UIViewController) {
        
    }
}

// MARK: - UIPageViewControllerDataSource
extension TestPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        guard let viewControllerIndex = testPages.index(of: viewController ) else { return nil }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else { return nil }
        guard testPages.count > previousIndex else { return nil }
        let previousTestPage = testPages[previousIndex]

        return previousTestPage
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = testPages.index(of: viewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < testPages.count else { return nil }
        guard testPages.count > nextIndex else { return nil }
        let nextTestPage = testPages[nextIndex]

        return nextTestPage
    }
}
