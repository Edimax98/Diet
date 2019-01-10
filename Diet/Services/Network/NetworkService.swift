//
//  NetworkService.swift
//  Diet
//
//  Created by Даниил on 12/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import SwiftyJSON

class NetworkService {
    
    weak var dietServiceDelegate: DietNetworkServiceDelegate?
    
    init() {}
}

// MARK: - DietNetworkService
extension NetworkService: DietNetworkService {
    
    func getDiet() {
        
        let queue = DispatchQueue.global(qos: .utility)
        let parameters = DietApi.allDiets.parameters
        
        request(DietApi.baseUrl, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .response(queue: queue, responseSerializer: DataRequest.jsonResponseSerializer()) { [weak self] response in
            
                guard let unwrappedSelf = self else { print("self is nil"); return }
            
                guard let responseValue = response.result.value else {
                    print("Diet raw json is nil")
                    return
                }
                
                let json = JSON(responseValue)["diet"]
                
                let days = json["weeks"][0]["days"].array?.map { jsonDays -> DietWeek.Day in DietWeek.Day(name: "", dishes: jsonDays.array?.map { jsonDish -> Dish in
                    Dish.init(name: jsonDish["name"].stringValue, imagePath: jsonDish["image"].stringValue,
                              nutritionValue: NutritionalValue.init(
                                calories: jsonDish["calories"].doubleValue, protein: jsonDish["protein"].doubleValue,
                                carbs: jsonDish["carbs"].doubleValue, fats: jsonDish["fats"].doubleValue),
                              recipe: jsonDish["reciept"].array?.map { jsonRecipe -> RecieptSteps in
                                RecieptSteps.init(name: jsonRecipe["name"].stringValue,
                                                  description: jsonRecipe["description"].stringValue,
                                                  imagePaths: [jsonRecipe["images"].stringValue]) } ?? [])
                    } ?? [])}
                
                guard let unwrappedDays = days else { print("days are nil after being parsed"); return }
                
                let jsonWeek = json["weeks"][0]
                let weekNutritionValue = NutritionalValue.init(calories: jsonWeek["totalCalories"].doubleValue, protein: jsonWeek["totalProtein"].doubleValue, carbs: jsonWeek["totalCarbs"].doubleValue, fats: jsonWeek["totalFats"].doubleValue)
                
                let diet = Diet.init(name: json["title"].stringValue, description: json["description"].stringValue, type: json["type"].stringValue, weeks: [DietWeek.init(nutritionalValue: weekNutritionValue, days: unwrappedDays)])
                
                unwrappedSelf.dietServiceDelegate?.dietNetworkServiceDidGet(diet)
        }
    }
}

extension NetworkService: ImageNetworkService {
    
    func fetchImages(with paths: [String], completion: @escaping ([String : Image]) -> ()) {
        
        var images = [String:Image]()
        let group = DispatchGroup()
        
        for path in paths {
            group.enter()
            request(path, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
                .responseImage { (response) in
                    guard let image = response.result.value else {
                        print("Image is NIL")
                        return
                    }
                images[path] = image
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion(images)
        }
    }
}
