//
//  NetworkService.swift
//  Diet
//
//  Created by Даниил on 12/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class NetworkService {
    
    weak var dietServiceDelegate: DietNetworkServiceDelegate?
    
    init() {}
}

// MARK: - DietNetworkService
extension NetworkService: DietNetworkService {
    
    func parseDiet() {
        
        guard let path = Bundle.main.path(forResource: "diet", ofType: "json") else { print("Cant do path"); return }
        let url = URL(fileURLWithPath: path)
        var jsonData = Data()
        
        do {
            jsonData = try Data(contentsOf: url, options: .mappedIfSafe)
        } catch let error {
            print(error.localizedDescription)
        }
        
        let json = JSON(jsonData)["Diet"]
        
        let days = json["weeks"][0]["days"].array?.map { jsonDays -> DietWeek.Day in DietWeek.Day(name: "", dishes: jsonDays.array?.map { jsonDish -> Dish in
                                                                                                    Dish.init(name: jsonDish["name"].stringValue, imagePath: jsonDish["image"].stringValue,
                                                                                                              nutritionValue: NutritionalValue.init(
                                                                                                                calories: jsonDish["calories"].doubleValue, protein: jsonDish["protein"].doubleValue,
                                                                                                                carbs: jsonDish["carbs"].doubleValue, fats: jsonDish["fats"].doubleValue),
                                                                                                                recipe: jsonDish["reciept"].array?.map { jsonRecipe -> RecieptSteps in
                                                                                                                RecieptSteps.init(name: jsonDish["name"].stringValue,
                                                                                                                                  description: jsonRecipe["description"].stringValue,
                                                                                                                                  imagePaths: [jsonRecipe["images"].first?.0 ?? ""]) } ?? [])
            } ?? [])}

        guard let unwrappedDays = days else { print("days are nil after being parsed"); return }
        
        let jsonWeek = json["weeks"][0]
        let weekNutritionValue = NutritionalValue.init(calories: jsonWeek["totalCalories"].doubleValue, protein: jsonWeek["totalProtein"].doubleValue, carbs: jsonWeek["totalCarbs"].doubleValue, fats: jsonWeek["totalFats"].doubleValue)
        
        let diet = Diet.init(type: json["type"].stringValue, weeks: [DietWeek.init(nutritionalValue: weekNutritionValue, days: unwrappedDays)])
        
        dietServiceDelegate?.dietNetworkServiceDidGet(diet)
    }
    
    func getDiet() {
        parseDiet()
        //        let queue = DispatchQueue.global(qos: .utility)
        //
        //        request("http://dietsforbuddies.com/api/getDiets.php", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
        //        .response(queue: queue, responseSerializer: DataRequest.jsonResponseSerializer()) { (response) in
        //
        //            guard let responseValue = response.result.value else {
        //                print("Diet raw json is nil")
        //                return
        //            }
        //
        //            let json = JSON(responseValue)["Diet"]
        //            let days = json["weeks"]["days"].array?.map { jsonDays -> DietWeek.Day in DietWeek.Day(name: "",
        //                                                                                                   dishes: (jsonDays[0].array?.map { jsonDishes -> Dish in
        //                                                                                                    Dish(name: jsonDishes["name"].stringValue, imagePath: jsonDishes["image"].stringValue,
        //                                                                                                         nutritionValue: NutritionalValue(calories: Double(jsonDishes["calories"].intValue),
        //                                                                                                                                          protein: Double(jsonDishes["protein"].intValue),
        //                                                                                                                                          carbs: Double(jsonDishes["carbs"].intValue),
        //                                                                                                                                          fats: Double(jsonDishes["fats"].intValue)))})!)}
        //
        //            print(json["weeks"]["days"])
        //            print(days ?? "DAYS NIL")
        //
        //            let weeks = json["weeks"].array?.map { jsonWeeks -> DietWeek in
        //                DietWeek(nutritionalValue: NutritionalValue(calories: jsonWeeks["totalCalories"].doubleValue, protein: jsonWeeks["totalProtein"].doubleValue, carbs: jsonWeeks["totalCarbs"].doubleValue, fats: jsonWeeks["totalFats"].doubleValue),
        //                         days: [])
        //            }
        //            print(weeks ?? "NIL")
        //        }
    }
}
