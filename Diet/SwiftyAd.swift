//
//  SwiftyAd.swift
//  Diet
//
//  Created by Даниил on 12/12/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import FBAudienceNetwork


/// SwiftyAdsDelegate
protocol SwiftyAdDelegate: class {
    /// SwiftyAd did open
    func swiftyAdDidFailedToLoad(_ swiftyAd: SwiftyAd)
}

/**
 SwiftyAd
 
 A helper class to manage adverts from AdMob.
 */
final class SwiftyAd: NSObject {
    
    // MARK: - Static Properties
    
    /// Shared instance
    static let shared = SwiftyAd()
    
    // MARK: - Properties
    
    /// Delegates
    weak var delegate: SwiftyAdDelegate?
    
    /// Remove ads
    var isRemoved = false {
        didSet {
            guard isRemoved else { return }
            removeBanner()
        }
    }
    
    /// Ads
    var bannerViewAd: FBAdView?
    
    /// Test Ad Unit IDs. Will get set to real ID in setup method
    fileprivate var bannerViewAdUnitID = "317759862160517_317760728827097"
    
    /// Interval counter
    private var intervalCounter = 0
    
    /// Init
    private override init() { }
    
    // MARK: - Show Banner
    
    /// Show banner ad
    ///
    /// - parameter viewController: The view controller that will present the ad.
    /// - parameter position: The position of the banner. Defaults to bottom.
    func showBanner(from viewController: UIViewController) {
        guard !isRemoved else { return }
        loadBannerAd()
    }
    
    // MARK: - Remove Banner
    
    /// Remove banner ads
    func removeBanner() {
        print("Removed banner ad")
        
        bannerViewAd?.delegate = nil
        bannerViewAd?.removeFromSuperview()
        bannerViewAd = nil
    }
}

// MARK: - Requesting Ad
private extension SwiftyAd {
    
    /// Load banner ad
    func loadBannerAd() {
        
        bannerViewAd = FBAdView(placementID: bannerViewAdUnitID, adSize: kFBAdSizeHeight50Banner, rootViewController: nil)
        
        guard let bannerViewAd = bannerViewAd else { return }
        bannerViewAd.delegate = self
        bannerViewAd.loadAd()
    }
}

extension SwiftyAd: FBAdViewDelegate {
    
    func adViewDidLoad(_ adView: FBAdView) {
        guard let bannerViewAd = bannerViewAd else { return }
    }
    
    func adView(_ adView: FBAdView, didFailWithError error: Error) {
        print(error)
        removeBanner()
        delegate?.swiftyAdDidFailedToLoad(self)
    }
}
