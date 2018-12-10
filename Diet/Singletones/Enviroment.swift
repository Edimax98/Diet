//
//  Enviroment.swift
//  Diet
//
//  Created by Даниил on 10/12/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import Foundation

enum EnviromentType {
    case development
    case production
}

class Enviroment {
    
    let shared = Enviroment()
    private let enviroment = EnviromentType.development
    
    private init() {}
}
