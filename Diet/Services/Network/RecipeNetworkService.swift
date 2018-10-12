//
//  RecipeNetworkService.swift
//  Diet
//
//  Created by Даниил on 12/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import Foundation

protocol RecipeNetworkServiceDelegate: FetchincErrorHandler {
 
    func recipeNetworkServiceDidGet()
}

protocol RecipeNetworkService {
    
    var recipeServiceDelegate: RecipeNetworkServiceDelegate? { get set }

    func getRecipe()
}
