//
//  ProductDatabase.swift
//  Diet
//
//  Created by Даниил on 25/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation
import MerchantKit

enum ProductDatabase {
    static let identifier = "com.sfbtech.diets.sub.week.allaccess"
    static let weeklySubscription = Product(identifier: identifier, kind: .subscription(automaticallyRenews: true))
}
