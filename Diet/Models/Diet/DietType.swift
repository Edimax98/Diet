//
//  DietType.swift
//  Diet
//
//  Created by Даниил on 11/02/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

enum DietType {
    case daily
    case power
    case superFit
    case fit
    case balance
    
    var description: String {
        switch self {
        case .daily:
            return "daily"
        case .power:
            return "power"
        case .superFit:
            return "superfit"
        case .fit:
            return "fit"
        case .balance:
            return "balance"
        }
    }
}
