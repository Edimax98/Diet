//
//  RecipeViewController.swift
//  Diet
//
//  Created by Даниил on 19/12/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

protocol RecipeReciver: class {
    
    func recieve(recipe: [RecieptSteps], dishName: String)
}

class RecipeViewController: UIViewController {
    
    @IBOutlet weak var dishNameLabel: UILabel!
    @IBOutlet weak var recipeLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    let networkService = NetworkService()
    
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
        let stepNameParagraphStyle = NSMutableParagraphStyle()
        stepNameParagraphStyle.alignment = .center
        stepNameParagraphStyle.paragraphSpacing = 10
        stepNameParagraphStyle.paragraphSpacingBefore = 25
        
        let emptyParagraphStyle = NSMutableParagraphStyle()
        emptyParagraphStyle.paragraphSpacing = 10.0
        
        let stepDescriptionParagraphStyle = NSMutableParagraphStyle()
        stepDescriptionParagraphStyle.alignment = .left
        stepDescriptionParagraphStyle.paragraphSpacing = 10
        
        let recipeAttributedString = NSMutableAttributedString()
        
        for step in recipe {
            
            let stepNameAttributedString = NSAttributedString(string: step.name + "\n", attributes: [NSAttributedString.Key.paragraphStyle: stepNameParagraphStyle])
            let stepDescrAttributedString = NSAttributedString(string: step.description + "\n", attributes: [NSAttributedString.Key.paragraphStyle: stepDescriptionParagraphStyle])

            recipeAttributedString.append(stepNameAttributedString)
            recipeAttributedString.append(stepDescrAttributedString)
            let textAttachmentWithImage = ImageAttachment()

            networkService.fetchImages(with: step.imagePaths) { (images) in
                guard let image = images[step.imagePaths.first ?? ""] else { return }
                textAttachmentWithImage.image = image
                let imageAttributedString = NSAttributedString(attachment: textAttachmentWithImage)
                recipeAttributedString.append(imageAttributedString)
                recipeAttributedString.append(NSAttributedString(string: "\n", attributes: [NSAttributedString.Key.paragraphStyle: emptyParagraphStyle]))
            }
        }
        
        self.recipeLabel.attributedText = recipeAttributedString

        //let recipeDescription = recipe.reduce("") { str, step in  str + step.name + step.description }
        //recipeLabel.text = recipeDescription
    }
}
