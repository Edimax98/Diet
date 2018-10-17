//
//  WelcomeViewController.swift
//  Diet
//
//  Created by Даниил on 17/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import UIKit

class WelcomeViewController: UIPageViewController {
    
    fileprivate let countOfPages = 4
    var pageControl: UIPageControl!
    fileprivate var pages = [UIViewController]()
    
    required init?(coder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        
        fillPages()
    }
    
    

    private func fillPages() {
        
        let firstPage = WelcomePageViewController.controllerInStoryboard(UIStoryboard(name: "WelcomePageViewController", bundle: nil))
        let secondPage = WelcomePageViewController.controllerInStoryboard(UIStoryboard(name: "WelcomePageViewController", bundle: nil))
        let thirdPage = WelcomePageViewController.controllerInStoryboard(UIStoryboard(name: "WelcomePageViewController", bundle: nil))
        let fourthPage = WelcomePageViewController.controllerInStoryboard(UIStoryboard(name: "WelcomePageViewController", bundle: nil))
        let _ = firstPage.view
        let _ = secondPage.view
        let _ = thirdPage.view
        let _ = fourthPage.view
        firstPage.iconPageImageView.image = UIImage(named: "slim")
        secondPage.iconPageImageView.image = UIImage(named: "recipe")
        thirdPage.iconPageImageView.image = UIImage(named: "chat")
        fourthPage.iconPageImageView.image = UIImage(named: "checkup")
        
        pages.append(firstPage)
        pages.append(secondPage)
        pages.append(thirdPage)
        pages.append(fourthPage)
        
        setViewControllers([pages.first!], direction: .forward, animated: true, completion: nil)
    }
}

// MARK: - UIPageViewControllerDataSource
extension WelcomeViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else { return nil }
        guard pages.count > previousIndex else { return nil }
        return pages[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < pages.count else { return nil }
        guard pages.count > nextIndex else { return nil }
        guard let nextPage = pages[nextIndex] as? WelcomePageViewController else { return nil }
        
        if nextPage === pages.last! {
            nextPage.nextButton.isHidden = false
            nextPage.nextButton.layer.cornerRadius = 8
        }
        
        return nextPage
    }
}
