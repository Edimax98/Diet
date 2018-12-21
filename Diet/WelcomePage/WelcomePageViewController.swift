//
//  WelcomePageViewController.swift
//  Diet
//
//  Created by Даниил on 17/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import UIKit
import paper_onboarding

class WelcomePageViewController: UIViewController {
    
    @IBOutlet weak var paperOnboardingView: PaperOnboarding!
    @IBOutlet weak var skipButton: UIButton!
    
    fileprivate static let titleFont = UIFont(name: "Helvetica-Bold", size: 36.0) ?? UIFont.boldSystemFont(ofSize: 36.0)
    fileprivate static let descriptionFont = UIFont(name: "Helvetica-Regular", size: 25.0) ?? UIFont.systemFont(ofSize: 14.0)
    
    fileprivate let items = [
        OnboardingItemInfo(informationImage: UIImage(named: "slim")!,
                           title: "Индекс ожирения".localized,
                           description: "Узнайте ваш индекс ожирения. Наше приложение  точно вычислит индекс ожирения для вас".localized,
                           pageIcon: UIImage(named: "stretch")!,
                           color: UIColor(red: 0.40, green: 0.56, blue: 0.71, alpha: 1.00),
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: WelcomePageViewController.titleFont, descriptionFont: WelcomePageViewController.descriptionFont),
        
        OnboardingItemInfo(informationImage: UIImage(named: "recipe")!,
                           title: "Тест".localized,
                           description: "Пройдите простой тест и мы сделаем все необходимое, чтобы помочь вам в подборе диет".localized,
                           pageIcon: UIImage(named: "clipboard")!,
                           color: UIColor(red: 0.40, green: 0.69, blue: 0.71, alpha: 1.00),
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: WelcomePageViewController.titleFont, descriptionFont: WelcomePageViewController.descriptionFont),
        
        OnboardingItemInfo(informationImage: UIImage(named: "chat")!,
                           title: "Статистика".localized,
                           description: "Получите свои параметры после прохождения теста".localized,
                           pageIcon: UIImage(named: "chat_mini")!,
                           color: UIColor(red: 0.61, green: 0.56, blue: 0.74, alpha: 1.00),
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: WelcomePageViewController.titleFont, descriptionFont: WelcomePageViewController.descriptionFont),
        
        OnboardingItemInfo(informationImage: UIImage(named: "diet")!,
                           title: "Результат".localized,
                           description: "С нашей помощью вы можете быстро сбросить лишний вес. Начинайте прямо сейчас!".localized,
                           pageIcon: UIImage(named: "ruler")!,
                           color: UIColor(red: 1, green: 126 / 255, blue: 121/255, alpha: 1.00),
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: WelcomePageViewController.titleFont, descriptionFont: WelcomePageViewController.descriptionFont)
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPaperOnboardingView()
        view.bringSubviewToFront(skipButton)
    }
    
    private func setupPaperOnboardingView() {
        paperOnboardingView.dataSource = self
        for attribute: NSLayoutConstraint.Attribute in [.left, .right, .top, .bottom] {
            let constraint = NSLayoutConstraint(item: paperOnboardingView,
                                                attribute: attribute,
                                                relatedBy: .equal,
                                                toItem: view,
                                                attribute: attribute,
                                                multiplier: 1,
                                                constant: 0)
            view.addConstraint(constraint)
        }
    }

    @IBAction func skipButtonPressed(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "wereWelcomePagesShown")
    }
}

// MARK: PaperOnboardingDataSource
extension WelcomePageViewController: PaperOnboardingDataSource {
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        return items[index]
    }
    
    func onboardingItemsCount() -> Int {
        return items.count
    }
}

