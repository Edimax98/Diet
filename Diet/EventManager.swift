//
//  EventManager.swift
//  Diet
//
//  Created by Даниил on 14/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation
import AppsFlyerLib

class EventManager {
    static func sendCustomEvent(with name: String) {
        AppsFlyerTracker.shared()?.trackEvent(name, withValues: [:])
    }
}

