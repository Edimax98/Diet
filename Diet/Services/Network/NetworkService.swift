//
//  NetworkService.swift
//  Diet
//
//  Created by Даниил on 12/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import Foundation

class NetworkService {
    
    weak var recipeServiceDelegate: RecipeNetworkServiceDelegate?
    
    init() {}
}

// MARK: - RecipeNetworkService
extension NetworkService: RecipeNetworkService {
    
    func getRecipe() {
        
    }
}
