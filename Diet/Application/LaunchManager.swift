//
//  LaunchManager.swift
//  Diet
//
//  Created by Даниил on 11/12/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import UIKit
import Purchases

protocol ContentAccessHandler: class {

    func accessIsDenied()
    func accessIsAvailable()
}

enum AccessStatus {
    case available
    case denied
}

class LaunchManager: NSObject {
    
    private let mainWindow: UIWindow
    weak var handler: ContentAccessHandler?
    
    init(window: UIWindow) {
        self.mainWindow = window
    }
    
    func verifyReceipt() {

        let loadingVC = LoadingViewController()
        loadingVC.view.backgroundColor = .lightGray
        mainWindow.rootViewController = loadingVC
        Purchases.shared.delegate = self
    
        Purchases.shared.purchaserInfo { [weak self] (info, error) in
            
            guard let self = self else { return }
            
            guard error != nil else {
                print("Error during sub check - ",error.debugDescription)
                self.mainWindow.rootViewController = SubscriptionOfferViewController.controllerInStoryboard(UIStoryboard(name: "SubscriptionOffer", bundle: nil))
                return
            }
            
            if let unwrappedInfo = info {
                if unwrappedInfo.activeSubscriptions.contains(ProductId.cheap.rawValue) ||
                    unwrappedInfo.activeSubscriptions.contains(ProductId.popular.rawValue) {
                    self.mainWindow.rootViewController = DietViewController.controllerInStoryboard(UIStoryboard(name: "Main", bundle: nil))
                } else {
                    self.mainWindow.rootViewController = SubscriptionOfferViewController.controllerInStoryboard(UIStoryboard(name: "SubscriptionOffer", bundle: nil))
                }
            }
        }
    }
    
    func prepareForLaunch() {
        if UserDefaults.standard.bool(forKey: "wereWelcomePagesShown") {
            verifyReceipt()
        } else {
            let welcomeVc = WelcomePageViewController.controllerInStoryboard(UIStoryboard(name: "Main", bundle: nil))
            mainWindow.rootViewController = welcomeVc
        }
    }
}

extension LaunchManager: PurchasesDelegate {

    func purchases(_ purchases: Purchases, didReceiveUpdated purchaserInfo: PurchaserInfo) {
        
    }
}
