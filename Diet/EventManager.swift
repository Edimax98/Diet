//
//  EventManager.swift
//  Diet
//
//  Created by Даниил on 14/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

class EventManager {
    
    static func sendCustomEvent(with name: String) {
        //Amplitude.instance().log
        //AppsFlyerTracker.shared()?.trackEvent(name, withValues: [:])
    }
    
    static func subscriptionExpired(with reason: String) {
        //AppsFlyerTracker.shared()?.trackEvent("Subscription expired with reason: " + reason, withValues: [:])
    }
}

