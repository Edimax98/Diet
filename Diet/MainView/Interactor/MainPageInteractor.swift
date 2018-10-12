//
//  MainPageInteractor.swift
//  Diet
//
//  Created by Даниил on 12/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import Foundation

class MainPageInteractor {
    
    weak var output: MainPageInteractorOutput?
    fileprivate var networkService: NetworkService
    fileprivate var recipeNetworkService: RecipeNetworkService
    
    init(_ networkService: NetworkService) {
        self.networkService = networkService
        self.recipeNetworkService = networkService
        self.recipeNetworkService.recipeServiceDelegate = self
    }
    
    func getRecipe() {}
}

extension MainPageInteractor: RecipeNetworkServiceDelegate {
    
    func recipeNetworkServiceDidGet() {
        
    }
    
    func fetchingEndedWithError(_ error: Error) {
        
    }
}
