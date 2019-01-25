//
//  LaunchManager.swift
//  Diet
//
//  Created by Даниил on 11/12/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import UIKit
protocol ContentAccessHandler: class {

    func accessIsDenied()
    func accessIsAvailable()
}

enum AccessStatus {
    case available
    case denied
}

class LaunchManager {
    
    private let mainWindow: UIWindow
    weak var handler: ContentAccessHandler?
    
    init(window: UIWindow) {
        self.mainWindow = window
    }
    
    private func uploadRecieptSucceeded() {
        
        guard SubscriptionService.shared.currentSubscription != nil else {
            handler?.accessIsDenied()
            return
        }
        handler?.accessIsAvailable()
    }
    
    private func reuploadReciept() {
        
        SubscriptionService.shared.uploadReceipt { [weak self] (success, _) in
    
            guard let unwrappedSelf = self else { return }
            if success {
                unwrappedSelf.uploadRecieptSucceeded()
            } else {
                unwrappedSelf.handler?.accessIsDenied()
            }
        }
    }

    func showSubscriptionOffer() {
        
    }
    
    func prepareForLaunch() {
        
        guard UserDefaults.standard.bool(forKey: "wereWelcomePagesShown") == false else {
            let dietVc = DietViewController.controllerInStoryboard(UIStoryboard(name: "Main", bundle: nil))
            handler = dietVc
            mainWindow.rootViewController = dietVc
            return
        }
        mainWindow.rootViewController = WelcomePageViewController.controllerInStoryboard(UIStoryboard(name: "Main", bundle: nil))
    }
    
    func launchWithSubscriptionValidation() {
        
        prepareForLaunch()
        SubscriptionService.shared.loadSubscriptionOptions()
        
        guard SubscriptionService.shared.hasReceiptData else {
            handler?.accessIsDenied()
            return
        }
        
        SubscriptionService.shared.uploadReceipt { [weak self]  (success,shouldRetry) in
            
            guard let unwrappedSelf = self else { return }
            
            if success {
                unwrappedSelf.uploadRecieptSucceeded()
            } else if shouldRetry {
                unwrappedSelf.reuploadReciept()
            } else if !shouldRetry {
                unwrappedSelf.handler?.accessIsDenied()
            }
        }
    }
}
