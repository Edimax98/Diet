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
    
    let genderSelectionPage = GenderSelectorViewController.controllerInStoryboard(UIStoryboard(name: "GenderSelectorViewController", bundle: nil))
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
        self.view.backgroundColor = UIColor(red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 1)
        fillPages()
        fillViewData()
        setViewControllers([testPages.first!], direction: .forward, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupSelectionTestPages()
    }
    
    fileprivate func fillViewData() {
    
        testViewData.append(ageSelectionPageData)
        testViewData.append(currentWeightSelectionPageData)
        testViewData.append(goalWeightSelectionPageData)
        testViewData.append(timeSelectionPageData)
    }
    
    fileprivate func fillPages() {
        
        testPages.append(genderSelectionPage)
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
        
        let _ = ageSelectionPage.view
        let _ = timeSelectionPage.view
        let _ = goalWeightSelectionPage.view
        let _ = currentWeightSelectionPage.view
        
        ageSelectionPage.progressView.progress = 0.4
        currentWeightSelectionPage.progressView.progress = 0.6
        goalWeightSelectionPage.progressView.progress = 0.8
        timeSelectionPage.progressView.progress = 1.0
        handleBackButtonPressing()
        handleNextButtonPressing()
        timeSelectionPage.nextButton.setTitle("Finish".localized, for: .normal)
    }
    
    fileprivate func handleNextButtonPressing() {
        
        genderSelectionPage.nextButtonPressed = {
            self.scrollToNextViewController()
        }
        
        ageSelectionPage.nextButtonPressed = {
            self.scrollToNextViewController()
        }
        
        currentWeightSelectionPage.nextButtonPressed = {
            self.scrollToNextViewController()
        }
        
        goalWeightSelectionPage.nextButtonPressed = {
            self.scrollToNextViewController()
        }
        
        timeSelectionPage.nextButtonPressed = {
            let testResultsVC = TestResultsViewController.controllerInStoryboard(UIStoryboard(name: "Main", bundle: nil))
            self.present(TestResultsViewController(), animated: true, completion: nil)
        }
    }
    
    fileprivate func handleBackButtonPressing() {

        ageSelectionPage.backButtonPressed = {
            self.scrollToPreviousViewController()
        }
        
        currentWeightSelectionPage.backButtonPressed = {
            self.scrollToPreviousViewController()
        }
        
        goalWeightSelectionPage.backButtonPressed = {
            self.scrollToPreviousViewController()
        }
        
        timeSelectionPage.backButtonPressed = {
            self.scrollToPreviousViewController()
        }
    }
    
    fileprivate func setupGenderSelectionPage(_ page: UIViewController) {
        
    }
    
    private func scrollToViewController(viewController: UIViewController,
                                        direction: UIPageViewController.NavigationDirection = .forward) {
        setViewControllers([viewController], direction: direction, animated: true, completion: nil)
    }
    
    func scrollToViewController(index newIndex: Int) {
        if let firstViewController = viewControllers?.first,
            let currentIndex = testPages.firstIndex(of: firstViewController) {
            let direction: UIPageViewController.NavigationDirection = newIndex >= currentIndex ? .forward : .reverse
            let nextViewController = testPages[newIndex]
            scrollToViewController(viewController: nextViewController, direction: direction)
        }
    }
    
    func scrollToNextViewController() {
        if let visibleViewController = viewControllers?.first,
            let nextViewController = pageViewController(self, viewControllerAfter: visibleViewController) {
            scrollToViewController(viewController: nextViewController)
        }
    }
    
    func scrollToPreviousViewController() {
        if let visibleViewController = viewControllers?.last,
            let previousViewContoller = pageViewController(self, viewControllerBefore: visibleViewController) {
            scrollToViewController(viewController: previousViewContoller, direction: .reverse)
        }
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
