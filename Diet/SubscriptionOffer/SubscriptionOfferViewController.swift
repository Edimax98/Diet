//
//  SubscriptionOffer.swift
//  Diet
//
//  Created by Даниил on 13/12/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import UIKit
import SafariServices

class SubscriptionOfferViewController: UIViewController {

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceContainerView: UIView!
    @IBOutlet weak var arcView: UIView!
    @IBOutlet weak var restoreButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var offset: NSLayoutConstraint!
    @IBOutlet weak var offsetFromTop: NSLayoutConstraint!
    @IBOutlet weak var trialStatusLabel: UILabel!
    @IBOutlet weak var trialTermsLabel: UILabel!
    @IBOutlet weak var termsAndServiceButton: UIButton!
    @IBOutlet weak var privacyPolicyButton: UIButton!
    
    fileprivate let trialExpiredMessage = "Your trial period has expired.".localized
    fileprivate let trialAvailableMessage = "Free period available".localized
    fileprivate let disclaimerMessage = "Payment will be charged to your iTunes Account at confirmation of purchase. Subscriptions will automatically renew unless canceled within 24-hours before the end of the current period. Subscription auto-renewal may be turned off by going to the Account Settings after purchase. Any unused portion of a free trial will be forfeited when you purchase a subscription.".localized
    fileprivate let allAccessMessage = "All access".localized
    fileprivate let freeTrialMessage = "3 days for FREE".localized
    fileprivate let subscriptionDuration = " per week".localized
    
    var loadingVc = LoadingViewController()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addObservers()

        
        if SubscriptionService.shared.options == nil {
            add(loadingVc)
            loadingVc.timeoutHandler = self
        }
        EventManager.sendCustomEvent(with: "Subscription offer was opened")
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
            if let destinationVc = segue.destination as? DietViewController, SubscriptionService.shared.currentSubscription != nil {
                destinationVc.accessStatus = .available
            }
        }
    }
    
    private func fillLables() {
        
        guard let option = SubscriptionService.shared.options?.first else { print("Cant fill labels, options are nil"); return }
    
        priceLabel.text = option.formattedPrice + subscriptionDuration + " after 3 days".localized
        
        if UserDefaults.standard.bool(forKey: "isTrialExpired") {
            self.trialStatusLabel.text = trialExpiredMessage
        } else {
            self.trialStatusLabel.text = trialAvailableMessage
        }
    }
    
    private func setupView() {
    
        arcView.makeCornerRadius(arcView.frame.height / 2)
        restoreButton.makeCornerRadius(restoreButton.frame.height / 2)
        skipButton.makeCornerRadius(restoreButton.frame.height / 2)
        priceContainerView.makeCornerRadius(priceContainerView.frame.height / 2)
        termsAndServiceButton.makeCornerRadius(termsAndServiceButton.frame.height / 2)
        privacyPolicyButton.makeCornerRadius(privacyPolicyButton.frame.height / 2)
        cardView.makeCornerRadius(32)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(purchaseButtonPressed(_:)))
        priceContainerView.addGestureRecognizer(tapGesture)
        fillLables()
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
    
    @objc func purchaseButtonPressed(_ sender: Any) {
        
        guard let option = SubscriptionService.shared.options?.first else {
            showErrorAlert(for: .purchaseFailed)
            return
        }
        add(loadingVc)
        SubscriptionService.shared.purchase(subscription: option)
    }
    
    @IBAction func skipButtonPressed(_ sender: Any) {
        EventManager.sendCustomEvent(with: "Subscription offer was skiped")
        performSegue(withIdentifier: "showDiets", sender: self)
    }
    
    @IBAction func restoreButtonPressed(_ sender: Any) {
        EventManager.sendCustomEvent(with: "User tried to restore subscription")
        add(loadingVc)
        SubscriptionService.shared.restorePurchases()
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
        
        loadingVc.remove()
        
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

        loadingVc.remove()
        
        guard let _ = SubscriptionService.shared.options?.first else {
            showErrorAlert(for: .internalError)
            return
        }
        fillLables()
    }
    
    @objc func handlePurchaseFailed() {
        showErrorAlert(for: .purchaseFailed)
    }
}

extension SubscriptionOfferViewController: LoadingTimeoutHandler {
    
    func didTimeoutOccured() {

        if SubscriptionService.shared.options == nil {
            let alert = UIAlertController(title: "Could not load data".localized, message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
}
