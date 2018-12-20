//
//  RecipeViewController.swift
//  Diet
//
//  Created by Даниил on 19/12/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import UIKit

protocol RecipeReciver: class {
    
    func recieve(recipe: [RecieptSteps], dishName: String)
}

class RecipeViewController: UIViewController {
    
    @IBOutlet weak var dishNameLabel: UILabel!
    @IBOutlet weak var recipeLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        closeButton.makeCornerRadius(closeButton.frame.height / 2)
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension RecipeViewController: RecipeReciver {
    
    func recieve(recipe: [RecieptSteps], dishName: String) {
        
        dishNameLabel.text = dishName
        let recipeDescription = recipe.reduce("") { str, step in  str + "\n\n" + step.name + "\n\n" + step.description }
        recipeLabel.text = recipeDescription
    }
}
