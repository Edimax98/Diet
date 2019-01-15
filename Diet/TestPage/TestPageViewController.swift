//
//  TestPageViewController.swift
//  Diet
//
//  Created by Даниил on 18/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import UIKit

protocol TestResultOutput: class {
    
    func testCompleted(with result: TestResult)
}

class TestPageViewController: UIPageViewController {

    var testPages = [UIViewController]()
    var testViewData = [TestViewData]()
    var testResult = TestResult()
    weak var testOutput: TestResultOutput?

    let genderSelectionPage = GenderSelectorViewController.controllerInStoryboard(UIStoryboard(name: "GenderSelectorViewController", bundle: nil))
    let ageSelectionPage = SelectingViewController.controllerInStoryboard(UIStoryboard(name: "SelectingViewController", bundle: nil))
    let currentWeightSelectionPage = SelectingViewController.controllerInStoryboard(UIStoryboard(name: "SelectingViewController", bundle: nil))
    let goalWeightSelectionPage = SelectingViewController.controllerInStoryboard(UIStoryboard(name: "SelectingViewController", bundle: nil))
    let heightSelectionPage = SelectingViewController.controllerInStoryboard(UIStoryboard(name: "SelectingViewController", bundle: nil))
    
    let ageSelectionPageData = TestViewData(title: "Select your age".localized,
                                            iconName: "heart-beat", pickerData: (10,99))
    let currentWeightSelectionPageData = TestViewData(title: "Select your weight".localized,
                                                      iconName: "weight-scale", pickerData: (50,150), unit: "kg".localized)
    let goalWeightSelectionPageData = TestViewData(title: "How much do you want to lose in weight".localized,
                                                   iconName: "diet", pickerData: (1,100), unit: "kg".localized)
    let heigthSelectionPageData = TestViewData(title: "Select your height".localized,
                                         iconName: "timer", pickerData: (140,200), unit: "cm.".localized)
    
    let resultsVc = TestResultsViewController.controllerInStoryboard(UIStoryboard(name: "Main", bundle: nil), identifier: "TestResultsViewController")
    
    required init?(coder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 1)
        fillPages()
        fillViewData()
        setViewControllers([testPages.first!], direction: .forward, animated: true, completion: nil)
        
        resultsVc.repeatTest = {
            self.scrollToViewController(index: 0)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupSelectionTestPages()
    }
    
    fileprivate func fillViewData() {
    
        testViewData.append(ageSelectionPageData)
        testViewData.append(currentWeightSelectionPageData)
        testViewData.append(goalWeightSelectionPageData)
        testViewData.append(heigthSelectionPageData)
    }
    
    fileprivate func fillPages() {
        
        testPages.append(genderSelectionPage)
        testPages.append(ageSelectionPage)
        testPages.append(currentWeightSelectionPage)
        testPages.append(goalWeightSelectionPage)
        testPages.append(heightSelectionPage)
    }
    
    fileprivate func setupSelectionTestPages() {

        ageSelectionPage.testViewData = ageSelectionPageData
        currentWeightSelectionPage.testViewData = currentWeightSelectionPageData
        goalWeightSelectionPage.testViewData = goalWeightSelectionPageData
        heightSelectionPage.testViewData = heigthSelectionPageData
        
        let _ = ageSelectionPage.view
        let _ = heightSelectionPage.view
        let _ = goalWeightSelectionPage.view
        let _ = currentWeightSelectionPage.view
        
        handleBackButtonPressing()
        handleNextButtonPressing()
        heightSelectionPage.nextButton.setTitle("Finish".localized, for: .normal)
    }

    fileprivate func handleNextButtonPressing() {
        
        genderSelectionPage.genderSelected = { [unowned self] gender in
            self.testResult.gender = gender
            self.scrollToNextViewController()
        }
        
        ageSelectionPage.nextButtonPressed = { [unowned self] index in
            self.scrollToNextViewController()
            self.testResult.age = self.ageSelectionPageData.pickerData[index]
        }
        
        currentWeightSelectionPage.nextButtonPressed = { [unowned self] index in
            self.scrollToNextViewController()
            self.testResult.currentWeight = self.currentWeightSelectionPageData.pickerData[index]
        }
        
        goalWeightSelectionPage.nextButtonPressed = { [unowned self] index in
            
            if self.testResult.currentWeight <= self.goalWeightSelectionPageData.pickerData[index] {
                let alert = UIAlertController(title: "Error".localized, message: "You cant set goal bigger then your current weight".localized, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            } else {
                self.scrollToNextViewController()
                self.testResult.goalWeight = self.goalWeightSelectionPageData.pickerData[index]
            }
        }
        
        heightSelectionPage.nextButtonPressed = { [unowned self] index in
            self.testResult.height = self.heigthSelectionPageData.pickerData[index]
            self.testOutput = self.resultsVc
            let _ = self.resultsVc.view
            self.testOutput?.testCompleted(with: self.testResult)
            self.present(self.resultsVc, animated: true)
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
        
        heightSelectionPage.backButtonPressed = {
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

        guard let viewControllerIndex = testPages.index(of: viewController) else { return nil }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else { return nil }
        guard testPages.count > previousIndex else { return nil }
        
        if let previousTestPage = testPages[previousIndex] as? SelectingViewController {
            let progress = Float(((previousIndex + 1) * 100 / testPages.count)) / 100
            let prevProgress = Float(((previousIndex) * 100 / testPages.count)) / 100
            previousTestPage.progressView.progress = prevProgress
            previousTestPage.indexForProgressView = progress
            return previousTestPage
        }
        
        if let previousTestPage = testPages[previousIndex] as? GenderSelectorViewController {
            let progress = Float(((previousIndex + 1) * 100 / testPages.count)) / 100
            previousTestPage.indexForProgressView = progress
            return previousTestPage
        }
        return UIViewController()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = testPages.index(of: viewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < testPages.count else { return nil }
        guard testPages.count > nextIndex else { return nil }
        
        if let nextTestPage = testPages[nextIndex] as? SelectingViewController {
            let progress = Float(((nextIndex + 1) * 100 / testPages.count)) / 100
            let prevProgress = Float(((nextIndex) * 100 / testPages.count)) / 100
            nextTestPage.progressView.progress = prevProgress
            nextTestPage.indexForProgressView = progress
            return nextTestPage
        }
        
        if let nextTestPage = testPages[nextIndex] as? GenderSelectorViewController {
            let progress = Float(((nextIndex + 1) * 100 / testPages.count)) / 100
            nextTestPage.indexForProgressView = progress
            return nextTestPage
        }
        return UIViewController()
    }
}
