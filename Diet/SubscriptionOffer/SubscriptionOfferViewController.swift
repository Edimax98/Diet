//
//  SubscriptionOffer.swift
//  Diet
//
//  Created by Даниил on 13/12/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import UIKit
import SwiftyStoreKit
import SafariServices

class SubscriptionOfferViewController: UIViewController {
    
    @IBOutlet weak var arcView: UIView!
    @IBOutlet weak var restoreButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var offset: NSLayoutConstraint!
    @IBOutlet weak var offsetFromTop: NSLayoutConstraint!
    @IBOutlet weak var trialTermsLabel: UILabel!
    @IBOutlet weak var termsAndServiceButton: UIButton!
    @IBOutlet weak var privacyPolicyButton: UIButton!
    @IBOutlet weak var cheapPlanContainerView: UIView!
    @IBOutlet weak var popularPlanPriceLabel: UILabel!
    @IBOutlet weak var cheapPlanLabel: UILabel!
    @IBOutlet weak var pupularPlanButton: UIButton!
    @IBOutlet weak var cheapPlanButton: UIButton!
    @IBOutlet weak var discountLabel: TestResultLabel!
    @IBOutlet weak var purchaseButton: UIButton!
    
    @IBOutlet weak var popularPlanContainerView: UIView!
    fileprivate let trialExpiredMessage = "Your trial period has expired.".localized
    fileprivate let trialAvailableMessage = "Free period available".localized
    fileprivate let disclaimerMessage = "Payment will be charged to your iTunes Account at confirmation of purchase. Subscriptions will automatically renew unless canceled within 24-hours before the end of the current period. Subscription auto-renewal may be turned off by going to the Account Settings after purchase. Any unused portion of a free trial will be forfeited when you purchase a subscription.".localized
    fileprivate let allAccessMessage = "All access".localized
    fileprivate let freeTrialMessage = "3 days for FREE".localized
    fileprivate let subscriptionDuration = " per week".localized
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addObservers()
        EventManager.sendCustomEvent(with: "Subscription offer was opened")
        let loadingVc = LoadingViewController()
        add(loadingVc
        )
        SwiftyStoreKit.retrieveProductsInfo([ProductId.popular.rawValue, ProductId.cheap.rawValue]) { result in
            loadingVc.remove()
            guard let popularProduct = result.retrievedProducts.filter({ product in product.productIdentifier == ProductId.popular.rawValue }).first else { return }
            
            if #available(iOS 11.2, *), let period = popularProduct.subscriptionPeriod, let trial = popularProduct.introductoryPrice?.subscriptionPeriod {
                let subscriptionPeriodText = period.unit.description(capitalizeFirstLetter: false, numberOfUnits: period.numberOfUnits)
                let trialPeriodText = trial.unit.description(capitalizeFirstLetter: false, numberOfUnits: period.numberOfUnits)
                self.popularPlanPriceLabel.text = popularProduct.localizedPrice! + " per ".localized + subscriptionPeriodText + " after " + "3 days".localized
            } else {
                self.popularPlanPriceLabel.text =  popularProduct.localizedPrice! + " per ".localized + "7 days".localized + " after " + "3 days".localized
            }
            
            let priceString = popularProduct.localizedPrice!
            print("Product: \(popularProduct.localizedDescription), price: \(priceString)")
            if let invalidProductId = result.invalidProductIDs.first {
                print("Invalid product identifier: \(invalidProductId)")
            }
            else {
                print("Error: \(result.error)")
            }
            
            guard let cheapProduct = result.retrievedProducts.filter({ product in product.productIdentifier == ProductId.cheap.rawValue }).first else { return }
            
            if #available(iOS 11.2, *), let period = cheapProduct.subscriptionPeriod, let trial = cheapProduct.introductoryPrice?.subscriptionPeriod {
                let subscriptionPeriodText = period.unit.description(capitalizeFirstLetter: false, numberOfUnits: period.numberOfUnits)
                let trialPeriodText = trial.unit.description(capitalizeFirstLetter: false, numberOfUnits: period.numberOfUnits)
                self.cheapPlanLabel.text = cheapProduct.localizedPrice! + " per ".localized + subscriptionPeriodText + " after " + trialPeriodText
            } else {
                self.cheapPlanLabel.text = cheapProduct.localizedPrice! + " per ".localized + "7 days".localized + " after " + "1 week".localized
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let path = UIBezierPath(arcCenter: CGPoint(x: arcView.frame.width / 2, y: 37), radius: 39, startAngle: CGFloat.pi, endAngle: 0, clockwise: true)
        
        arcView.layer.masksToBounds = false
        arcView.layer.shadowColor = UIColor.lightGray.cgColor
        arcView.layer.shadowOffset = CGSize(width: 1, height: 1)
        arcView.layer.shadowOpacity = 0.5
        arcView.layer.shadowRadius = 16
        arcView.layer.shadowPath = path.cgPath
        cardView.dropShadow(opacity: 0.3, offSet: CGSize(width: 1, height: 1), radius: 16)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showDiets" {
            if let destinationVc = segue.destination as? DietViewController {
                destinationVc.accessStatus = .available
            }
        }
    }
    
    private func setupView() {
        
        arcView.makeCornerRadius(arcView.frame.height / 2)
        restoreButton.makeCornerRadius(5)
        purchaseButton.makeCornerRadius(5)
        skipButton.makeCornerRadius(5)
        termsAndServiceButton.makeCornerRadius(5)
        privacyPolicyButton.makeCornerRadius(5)
        cardView.makeCornerRadius(5)
        popularPlanContainerView.makeCornerRadius(5)
        popularPlanContainerView.layer.borderWidth = 1
        popularPlanContainerView.layer.borderColor = UIColor(red: 0, green: 234 / 255, blue: 134 / 255, alpha: 1).cgColor
        cheapPlanContainerView.makeCornerRadius(5)
        cheapPlanContainerView.layer.borderWidth = 1
        cheapPlanContainerView.layer.borderColor = UIColor(red: 0, green: 234 / 255, blue: 134 / 255, alpha: 1).cgColor
        discountLabel.makeCornerRadius(5)
        discountLabel.layer.borderWidth = 1
        discountLabel.layer.borderColor = UIColor(red: 0, green: 169 / 255, blue: 97 / 255, alpha: 1).cgColor
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleRestoreSuccessfull(notification:)),
                                               name: SubscriptionService.restoreSuccessfulNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handlePurchaseSuccessfull(notification:)),
                                               name: SubscriptionService.purchaseSuccessfulNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleOptionsLoaded(notification:)),
                                               name: SubscriptionService.optionsLoadedNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handlePurchaseFailed),
                                               name: SubscriptionService.purchaseFailedNotification,
                                               object: nil)
    }
    
    private func showErrorAlert(for error: SubscriptionServiceError) {
        let title: String
        let message: String
        
        switch error {
        case .missingAccountSecret, .invalidSession, .internalError:
            title = "Internal error".localized
            message = "Please try again.".localized
        case .noActiveSubscription:
            title = "No Active Subscription".localized
            message = "Please verify that you have an active subscription".localized
        case .other(let otherError):
            title = "Unexpected Error".localized
            message = otherError.localizedDescription
        case .wrongEnviroment: return
        case .purchaseFailed:
            title = "Purchase failed".localized
            message = "Purchase transaction failed. Try again"
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let backAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(backAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func purchaseButtonPressed(_ sender: Any) {
        
        let loadingVc = LoadingViewController()
        var productId = ""
        
        add(loadingVc)
        if pupularPlanButton.isSelected {
           productId = "com.sfbtech.diets.sub.week.allaccess"
        } else {
            productId = "com.sfbtech.diets.sub.month.allaccess"
        }

        SwiftyStoreKit.purchaseProduct(productId, atomically: true) { result in
            
            if case .success(let purchase) = result {
                // Deliver content from server, then:
                if purchase.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                }
                
                let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: "41b8fe92dbd9448ab3e06f3507b01371")
                SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
                    
                    if case .success(let receipt) = result {
                        let purchaseResult = SwiftyStoreKit.verifySubscription(
                            ofType: .autoRenewable,
                            productId: productId,
                            inReceipt: receipt)
                        
                        switch purchaseResult {
                        case .purchased(let expiryDate, let receiptItems):
                            let filtred = receiptItems.sorted { $0.purchaseDate < $1.purchaseDate }
                            if let lastPurchase = filtred.last, lastPurchase.isTrialPeriod == true {
                                print("THIS IS TRIAL")
                            }
                            print("Product is valid until \(expiryDate)")
                        case .expired(let expiryDate, let receiptItems):
                            print("Product is expired since \(expiryDate)")
                        case .notPurchased:
                            print("This product has never been purchased")
                        }
                        
                    } else {
                        self.showErrorAlert(for: .internalError)
                    }
                }
            } else {
                self.showErrorAlert(for: .purchaseFailed)
            }
        }
    }
    
    @IBAction func selectCheapPlanButtonPressed(_ sender: Any) {
        cheapPlanButton.isSelected = !cheapPlanButton.isSelected
        pupularPlanButton.isSelected = !pupularPlanButton.isSelected
    }
    
    @IBAction func selectPopularPlanButtonPressed(_ sender: Any) {
        cheapPlanButton.isSelected = !cheapPlanButton.isSelected
        pupularPlanButton.isSelected = !pupularPlanButton.isSelected
    }
    
    @IBAction func skipButtonPressed(_ sender: Any) {
        //EventManager.sendCustomEvent(with: "Subscription offer was skiped")
        performSegue(withIdentifier: "showTestResult", sender: self)
    }
    
    @IBAction func restoreButtonPressed(_ sender: Any) {
        //productInterfaceController.restorePurchases()
        //EventManager.sendCustomEvent(with: "User tried to restore subscription")
        //add(loadingVc)
        //SubscriptionService.shared.restorePurchases()
    }
    
    @IBAction func termsAndServiceButtonPressed(_ sender: Any) {
        guard let url = URL(string: "https://sfbtech.org/terms") else { return }
        let webView = SFSafariViewController(url: url)
        present(webView, animated: true, completion: nil)
    }
    
    @IBAction func privacyPolicyButtonPressed(_ sender: Any) {
        guard let url = URL(string: "https://sfbtech.org/policy") else { return }
        let webView = SFSafariViewController(url: url)
        present(webView, animated: true, completion: nil)
    }
    
    @objc func handleRestoreSuccessfull(notification: Notification) {
        
        //loadingVc.remove()
        
        if SubscriptionService.shared.currentSubscription != nil {
            performSegue(withIdentifier: "showDiets", sender: self)
        }
        else {
            showErrorAlert(for: .noActiveSubscription)
        }
    }
    
    @objc func handlePurchaseSuccessfull(notification: Notification) {
        
        if let _ = SubscriptionService.shared.currentSubscription {
            performSegue(withIdentifier: "showDiets", sender: self)
        }
    }
    
    @objc func handleOptionsLoaded(notification: Notification) {
        
        guard let _ = SubscriptionService.shared.options?.first else {
            showErrorAlert(for: .internalError)
            return
        }
    }
    
    @objc func handlePurchaseFailed() {
        showErrorAlert(for: .purchaseFailed)
    }
}
