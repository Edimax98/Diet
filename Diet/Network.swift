//
//  Network.swift
//  Diet
//
//  Created by Даниил on 16/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import Foundation

class Network {

    var apiKey: String {
        get {
            return "9e2dd8117e27ec1da9c4017aeb2281b8"
        }
    }
    var appId: String {
        get {
            return "7b10ff83"
        }
    }
    
    private init() {}
    static let shared = Network()
}
