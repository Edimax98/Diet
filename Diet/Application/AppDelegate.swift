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
import AppsFlyerLib
import UserNotifications
import MerchantKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
        
    var window: UIWindow?
    var launchManager: LaunchManager?
    var merchant: Merchant!
    private let itcAccountSecret = "41b8fe92dbd9448ab3e06f3507b01371"
    
    // MARK: Notifications
    
    private func setupLocalNotifications() {
        
        var dateComponents = DateComponents()
        
        // monday
        dateComponents.weekday = 2
        dateComponents.hour = 12
        dateComponents.minute = 0
        dateComponents.timeZone = TimeZone.current
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "New recipes!".localized
        notificationContent.body = "Check out new recipes".localized
        notificationContent.badge = 1
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "NEW_DIET",
                                            content: notificationContent, trigger: trigger)
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
            if error != nil {
                
            }
        }
    }
    
    // MARK: App life cycle
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        merchant = Merchant(storage: KeychainPurchaseStorage(serviceName: "Diet"), delegate: self)
        merchant.register([ProductDatabase.weeklySubscription])
        merchant.setup()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge,.sound,.alert]) { (isAllowed, error) in
            if isAllowed {
                self.setupLocalNotifications()
            } else {
                print("Permission has not been granted")
            }
        }
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let subOfferVc = SubscriptionOfferViewController.controllerInStoryboard(UIStoryboard(name: "SubscriptionOffer", bundle: nil))
        subOfferVc.products.append(ProductDatabase.weeklySubscription)
        subOfferVc.merchant = merchant
        window?.rootViewController = subOfferVc
    
        //FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        AppsFlyerTracker.shared().appsFlyerDevKey = "RB7d2qzpNfUwBdq4saReqk"
        AppsFlyerTracker.shared().appleAppID = "1445711141"
        AppsFlyerTracker.shared().isDebug = true
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
        return handled
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        AppEventsLogger.activate(application)
        AppsFlyerTracker.shared()?.trackAppLaunch()
    }
}

extension AppDelegate: MerchantDelegate {
    
    func merchant(_ merchant: Merchant, validate request: ReceiptValidationRequest, completion: @escaping (Result<Receipt>) -> Void) {
        
        let validator = ServerReceiptValidator(request: request, sharedSecret: itcAccountSecret)
        
        validator.onCompletion = { result in
            
            switch result {
            case .succeeded(let reciept):
                print(reciept.debugDescription)
                
                for entry in reciept.entries(forProductIdentifier: ProductDatabase.weeklySubscription.identifier) {
                    
                }
            case .failed(_):
                return
            }
            
            completion(result)
        }
        
        validator.start()
    }
    
    func merchant(_ merchant: Merchant, didChangeStatesFor products: Set<Product>) {
        
        guard let subscription = products.first else { return }
        
        switch merchant.state(for: subscription) {
        case .unknown:
            break
        case .notPurchased:
            break
        case .isPurchased(_):
            break
        }
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
        UIViewController.removeTopPresented()
        print("User is attempting to purchase product id: \(transaction.payment.productIdentifier)")
    }

    fileprivate func logEvents() {

//        SubscriptionService.shared.loadSubscriptionOptions()
//        SubscriptionService.shared.optionsLoaded = { option in
//            if SubscriptionService.shared.isEligibleForTrial && SubscriptionService.shared.currentSubscription != nil {
//                AppsFlyerTracker.shared()?.trackEvent(AFEventStartTrial, withValues: ["trial_method": "3 days trial"])
//            }
//            if SubscriptionService.shared.isEligibleForTrial == false {
//                AppsFlyerTracker.shared().trackEvent(AFEventSubscribe, withValues: [AFEventParamRevenue: option.priceWithoutCurrency, AFEventParamCurrency: option.currencyCode])
//            }
//        }
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
                    if SubscriptionService.shared.currentSubscription != nil {
                        NotificationCenter.default.post(name: SubscriptionService.restoreSuccessfulNotification, object: nil)
                    }
                }
            } else if shouldRetry {
                SubscriptionService.shared.uploadReceipt { (success, _) in
                    guard success else { return }
                    DispatchQueue.main.async {
                        if SubscriptionService.shared.currentSubscription != nil {
                            NotificationCenter.default.post(name: SubscriptionService.restoreSuccessfulNotification, object: nil)
                        }
                    }
                }
            }
        }
    }

    func handleFailedState(for transaction: SKPaymentTransaction, in queue: SKPaymentQueue) {
        UIViewController.removeTopPresented()
        print("Purchase failed for product id: \(transaction.payment.productIdentifier)")
        queue.finishTransaction(transaction)
        NotificationCenter.default.post(name: SubscriptionService.purchaseFailedNotification, object: nil)
    }

    func handleDeferredState(for transaction: SKPaymentTransaction, in queue: SKPaymentQueue) {
        UIViewController.removeTopPresented()
        print("Purchase deferred for product id: \(transaction.payment.productIdentifier)")
        queue.finishTransaction(transaction)
    }
}

