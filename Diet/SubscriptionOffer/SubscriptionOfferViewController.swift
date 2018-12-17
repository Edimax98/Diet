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

    @IBOutlet weak var arcView: UIView!
    @IBOutlet weak var restoreButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var startSubscriptionButton: UIButton!
    @IBOutlet weak var startButtonContainerView: UIView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var offset: NSLayoutConstraint!
    @IBOutlet weak var offsetFromTop: NSLayoutConstraint!
    @IBOutlet weak var trialLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var trialTermsLabel: UILabel!
    @IBOutlet weak var termsAndServiceButton: UIButton!
    @IBOutlet weak var privacyPolicyButton: UIButton!
    
    
    fileprivate let trialExpiredMessage = "Your trial period has expired. Subscription price - ".localized
    fileprivate let trialAvailableMessage = "3 days trial. Subscription price - ".localized
    fileprivate let disclaimerMessage = "Payment will be charged to your iTunes Account at confirmation of purchase. Subscriptions will automatically renew unless canceled within 24-hours before the end of the current period. Subscription auto-renewal may be turned off by going to the Account Settings after purchase. Any unused portion of a free trial will be forfeited when you purchase a subscription.".localized
    fileprivate let allAccessMessage = "All access".localized
    fileprivate let freeTrialMessage = "3 days FREE".localized
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addObservers()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let path = UIBezierPath(arcCenter: CGPoint(x: arcView.frame.width / 2, y: 37), radius: 39, startAngle: CGFloat.pi, endAngle: 0, clockwise: true)
        
        arcView.layer.masksToBounds = false
        arcView.layer.shadowColor = UIColor.lightGray.cgColor
        arcView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        arcView.layer.shadowOpacity = 0.5
        arcView.layer.shadowPath = path.cgPath
    }
    
    private func setupView() {
        
        arcView.makeCornerRadius(arcView.frame.height / 2)
        restoreButton.makeCornerRadius(restoreButton.frame.height / 2)
        skipButton.makeCornerRadius(restoreButton.frame.height / 2)
        startSubscriptionButton.makeCornerRadius(startSubscriptionButton.frame.height / 2)
        startButtonContainerView.makeCornerRadius(startButtonContainerView.frame.height / 2)
        termsAndServiceButton.makeCornerRadius(termsAndServiceButton.frame.height / 2)
        privacyPolicyButton.makeCornerRadius(privacyPolicyButton.frame.height / 2)
        
        cardView.makeCornerRadius(32)
        cardView.dropShadow(opacity: 0.3, offSet: CGSize(width: 1, height: 1), radius: 16)

        arcView.dropShadow(opacity: 0.3, offSet: CGSize(width: 1, height: 1), radius: 16)
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

    @IBAction func skipButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func restoreButtonPressed(_ sender: Any) {
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
        
        if SubscriptionService.shared.currentSubscription != nil {
            let alert = UIAlertController(title: "Successfull".localized, message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                self.performSegue(withIdentifier: "unwindToMain", sender: self)
            }
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            //status = .available
        } else {
            showErrorAlert(for: .noActiveSubscription)
        }
    }
    
    @objc func handlePurchaseSuccessfull(notification: Notification) {
        
        guard let subscription = SubscriptionService.shared.options?.first else { return }
        
        if let _ = SubscriptionService.shared.currentSubscription {
            if !SubscriptionService.shared.isEligibleForTrial {
                //self.trialLabel.text = allAccessMessage
                //self.priceLabel.text = trialExpiredMessage + subscription.formattedPrice + " per week"
            } else {
                //self.trialLabel.text = allAccessMessage
                //self.priceLabel.text = trialAvailableMessage + subscription.formattedPrice + " per week"
            }
            //status = .available
            
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handleOptionsLoaded(notification: Notification) {
        
        guard let _ = SubscriptionService.shared.options?.first else {
            showErrorAlert(for: .internalError)
            return
        }
        
        //self.subscription = sub
        
        if UserDefaults.standard.bool(forKey: "isTrialExpired") {
            self.trialLabel.text = allAccessMessage
            guard let price = SubscriptionService.shared.options?.first?.formattedPrice else { return }
            self.priceLabel.text = trialExpiredMessage + price + " per week"
        } else {
            self.trialLabel.text = freeTrialMessage
            guard let price = SubscriptionService.shared.options?.first?.formattedPrice else { return }
            self.priceLabel.text = trialAvailableMessage + price + " per week"
        }
        
        self.trialTermsLabel.text = disclaimerMessage
    }
    
    @objc func handlePurchaseFailed() {
        showErrorAlert(for: .purchaseFailed)
    }
}
