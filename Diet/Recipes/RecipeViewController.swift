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
        recipeLabel.text = "..."
        closeButton.makeCornerRadius(closeButton.frame.height / 2)
    }
    
    fileprivate func setImagesForRecipe(_ recipe: [RecieptSteps], _ images: [String: Image]) -> [RecieptSteps] {
        
        let imagePaths = recipe.map { $0.imagePaths.first! }
        var resultRecipe = recipe
        
        var i = 0
        while imagePaths.count - 1 >= i {
            if images.keys.contains(where: { (url) -> Bool in imagePaths[i] == url }) {
                resultRecipe[i].images.append(images[imagePaths[i]]!)
            }
            i += 1
        }
        return resultRecipe
    }
    
    fileprivate func loadAndFillRecipe(with steps: [RecieptSteps]) {
        
        if steps.isEmpty {
            recipeLabel.text = "No recipe".localized
            return
        }
        let loadingVc = LoadingViewController()
        loadingVc.timeoutHandler = self
        add(loadingVc)
        
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
        
        let imagePaths = steps.filter { $0.imagePaths.first! != "" }.map { $0.imagePaths.first! }
        
        networkService.fetchImages(with: imagePaths) { [weak self] (response) in
            
            loadingVc.remove()
            var images = [String:Image]()
            
            guard let unwrappedSelf = self else { return }
            
            switch response {
            case .success(let result):
                images = result
                
                let recipeWithImages = unwrappedSelf.setImagesForRecipe(steps, images)
                
                for step in recipeWithImages {
                    
                    let stepNameAttributedString = NSAttributedString(string: step.name + "\n", attributes: [NSAttributedString.Key.paragraphStyle: stepNameParagraphStyle])
                    let stepDescrAttributedString = NSAttributedString(string: step.description + "\n", attributes: [NSAttributedString.Key.paragraphStyle: stepDescriptionParagraphStyle])
                    
                    recipeAttributedString.append(stepNameAttributedString)
                    recipeAttributedString.append(stepDescrAttributedString)
                    
                    if !step.images.isEmpty {
                        let textAttachmentWithImage = ImageAttachment()
                        textAttachmentWithImage.image = step.images[0]
                        let imageAttributedString = NSAttributedString(attachment: textAttachmentWithImage)
                        recipeAttributedString.append(imageAttributedString)
                    }
                    
                    recipeAttributedString.append(NSAttributedString(string: "\n", attributes: [NSAttributedString.Key.paragraphStyle: emptyParagraphStyle]))
                    unwrappedSelf.recipeLabel.attributedText = recipeAttributedString
                }
            case .failure(_):
                unwrappedSelf.recipeLabel.text = "An error occured".localized
            }
        }
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension RecipeViewController: RecipeReciver {
    
    func recieve(recipe: [RecieptSteps], dishName: String) {
        dishNameLabel.text = dishName
        loadAndFillRecipe(with: recipe)
    }
}

extension RecipeViewController: LoadingTimeoutHandler {
    
    func didTimeoutOccured() {
        
        let timeoutMessageParagraphStyle = NSMutableParagraphStyle()
        timeoutMessageParagraphStyle.alignment = .center
        timeoutMessageParagraphStyle.paragraphSpacingBefore = 100
        
        let timeoutHappendMessage = NSAttributedString(string: "Could not load data.".localized, attributes: [NSAttributedString.Key.paragraphStyle : timeoutMessageParagraphStyle])
        
        recipeLabel.attributedText = timeoutHappendMessage
    }
}
