//
//  AppDelegate.swift
//  Diet
//
//  Created by Даниил on 09/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import UIKit
import StoreKit
import FBSDKCoreKit
import FacebookCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var launchManager: LaunchManager?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        SKPaymentQueue.default().add(self)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        launchManager = LaunchManager(window: window!)
        launchManager?.launchWithSubscriptionValidation()
        launchManager?.prepareForLaunch()
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
        return handled
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        AppEventsLogger.activate(application)
    }
}

extension AppDelegate: SKPaymentTransactionObserver {
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        
        if queue.transactions.isEmpty {
            NotificationCenter.default.post(name: SubscriptionService.nothingToRestoreNotification, object: nil)
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing:
                handlePurchasingState(for: transaction, in: queue)
            case .purchased:
                handlePurchasedState(for: transaction, in: queue)
            case .restored:
                handleRestoredState(for: transaction, in: queue)
            case .failed:
                print(transaction.error?.localizedDescription ?? "")
                handleFailedState(for: transaction, in: queue)
            case .deferred:
                handleDeferredState(for: transaction, in: queue)
            }
        }
    }
    
    func handlePurchasingState(for transaction: SKPaymentTransaction, in queue: SKPaymentQueue) {
        print("User is attempting to purchase product id: \(transaction.payment.productIdentifier)")
    }
    
    fileprivate func logEvents() {
        
        SubscriptionService.shared.loadSubscriptionOptions()
        SubscriptionService.shared.optionsLoaded = { option in
            if SubscriptionService.shared.isEligibleForTrial && SubscriptionService.shared.currentSubscription != nil {
                FBSDKAppEvents.logEvent(FBSDKAppEventNameInitiatedCheckout,
                                        parameters: [FBSDKAppEventParameterNameContentType: "3 days trial",
                                                     FBSDKAppEventParameterNameContentID: option.product.productIdentifier,
                                                     FBSDKAppEventParameterNameDescription: FacebookEventsEviroment.shared.enviroment.rawValue])
                
            }
            if SubscriptionService.shared.isEligibleForTrial == false {
                FBSDKAppEvents.logPurchase(option.priceWithoutCurrency, currency: option.currencyCode,
                                           parameters: [FBSDKAppEventParameterNameContentType: "Weekly subscription",
                                                        FBSDKAppEventParameterNameContentID: option.product.productIdentifier,
                                                        FBSDKAppEventParameterNameDescription: FacebookEventsEviroment.shared.enviroment.rawValue])
            }
        }
    }
    
    func handlePurchasedState(for transaction: SKPaymentTransaction, in queue: SKPaymentQueue) {
        print("User purchased product id: \(transaction.payment.productIdentifier)")
        queue.finishTransaction(transaction)
        SubscriptionService.shared.uploadReceipt { (success, shouldRetry) in
            if success {
                self.logEvents()
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: SubscriptionService.purchaseSuccessfulNotification, object: nil)
                }
            } else if shouldRetry {
                SubscriptionService.shared.uploadReceipt { (success, _) in
                    guard success else { return }
                    self.logEvents()
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: SubscriptionService.purchaseSuccessfulNotification, object: nil)
                    }
                }
            }
        }
    }
    
    func handleRestoredState(for transaction: SKPaymentTransaction, in queue: SKPaymentQueue) {
        print("Purchase restored for product id: \(transaction.payment.productIdentifier)")
        queue.finishTransaction(transaction)
        SubscriptionService.shared.uploadReceipt { (success, shouldRetry) in
            if success {
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: SubscriptionService.restoreSuccessfulNotification, object: nil)
                }
            } else if shouldRetry {
                SubscriptionService.shared.uploadReceipt { (success, _) in
                    guard success else { return }
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: SubscriptionService.restoreSuccessfulNotification, object: nil)
                    }
                }
            }
        }
    }
    
    func handleFailedState(for transaction: SKPaymentTransaction, in queue: SKPaymentQueue) {
        print("Purchase failed for product id: \(transaction.payment.productIdentifier)")
        queue.finishTransaction(transaction)
        NotificationCenter.default.post(name: SubscriptionService.purchaseFailedNotification, object: nil)
    }
    
    func handleDeferredState(for transaction: SKPaymentTransaction, in queue: SKPaymentQueue) {
        print("Purchase deferred for product id: \(transaction.payment.productIdentifier)")
        queue.finishTransaction(transaction)
    }
}

