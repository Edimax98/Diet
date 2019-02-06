//
//  AppDelegate.swift
//  Diet
//
//  Created by Даниил on 09/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import UIKit
import SwiftyStoreKit
import FBSDKCoreKit
import FacebookCore
import AppsFlyerLib
import UserNotifications
import CoreData

enum ProductId: String {
    
    case popular = "com.sfbtech.diets.sub.week.allaccess"
    case cheap = "com.sfbtech.diets.sub.month.allaccess"
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var launchManager: LaunchManager?
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
        let request = UNNotificationRequest(identifier: "NEW_DIET", content: notificationContent, trigger: trigger)
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
            if error != nil {
                
            }
        }
    }
    
    func verifyReceipt() {
        
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: "41b8fe92dbd9448ab3e06f3507b01371")
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { (result) in
            
            switch result {
            case .success(let receipt):
                
                let verificationResult = SwiftyStoreKit.verifySubscriptions(productIds: [ProductId.popular.rawValue, ProductId.cheap.rawValue], inReceipt: receipt)
                
                switch verificationResult {
                case .purchased(let items):
                    let dietVc = DietViewController.controllerInStoryboard(UIStoryboard(name: "Main", bundle: nil))
                    dietVc.accessStatus = .available
                    self.window?.rootViewController = dietVc
                case .expired(let items):
                    break
                case .notPurchased:
                    break
                }
                
                print(receipt)
            case .error(let error):
                print("Error during reciipt validation ", error)
            }
        }
    }
    
    func setupIAP() {
        
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    
                    if purchase.needsFinishTransaction {
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    print("\(purchase.transaction.transactionState.debugDescription): \(purchase.productId)")
                case .failed, .purchasing, .deferred:
                    break
                }
            }
        }
    }
    
    // MARK: App life cycle
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        print(paths[0])
        
        setupIAP()
        verifyReceipt()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge,.sound,.alert]) { (isAllowed, error) in
            if isAllowed {
                self.setupLocalNotifications()
            } else {
                print("Permission has not been granted")
            }
        }
        
        //let subOfferVc = SubscriptionOfferViewController.controllerInStoryboard(UIStoryboard(name: "SubscriptionOffer", bundle: nil))
        //window = UIWindow(frame: UIScreen.main.bounds)
        //window?.makeKeyAndVisible()
        //window?.rootViewController = subOfferVc
        //
        //        subOfferVc.products.append(ProductDatabase.weeklySubscription)
        //        subOfferVc.merchant = merchant
        //        window?.rootViewController = subOfferVc
        
        //FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        AppsFlyerTracker.shared().appsFlyerDevKey = "RB7d2qzpNfUwBdq4saReqk"
        AppsFlyerTracker.shared().appleAppID = "1445711141"
        
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
    
    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Test")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
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
    
}

