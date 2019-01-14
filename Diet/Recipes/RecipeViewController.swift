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
    fileprivate var recipe = [RecieptSteps]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(userTapped))
        view.addGestureRecognizer(tapGesture)
        recipeLabel.text = "..."
        closeButton.makeCornerRadius(closeButton.frame.height / 2)
    }
    
    fileprivate func loadAndFillRecipe(with steps: [RecieptSteps]) {
        
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
        let gr = DispatchGroup()
        
        for step in steps {
            
            let stepNameAttributedString = NSAttributedString(string: step.name + "\n", attributes: [NSAttributedString.Key.paragraphStyle: stepNameParagraphStyle])
            let stepDescrAttributedString = NSAttributedString(string: step.description + "\n", attributes: [NSAttributedString.Key.paragraphStyle: stepDescriptionParagraphStyle])
            gr.enter()
            networkService.fetchImages(with: step.imagePaths) { (images) in
                
                guard let image = images[step.imagePaths.first ?? ""] else {
                    loadingVc.remove()
                    gr.leave()
                    return
                }
                recipeAttributedString.append(stepNameAttributedString)
                recipeAttributedString.append(stepDescrAttributedString)
                let textAttachmentWithImage = ImageAttachment()
                textAttachmentWithImage.image = image
                let imageAttributedString = NSAttributedString(attachment: textAttachmentWithImage)
                recipeAttributedString.append(imageAttributedString)
                recipeAttributedString.append(NSAttributedString(string: "\n", attributes: [NSAttributedString.Key.paragraphStyle: emptyParagraphStyle]))
                gr.leave()
            }
        }
        
        gr.notify(queue: .main) {
            loadingVc.remove()
            self.recipeLabel.attributedText = recipeAttributedString
        }
    }
    
    
    @objc func userTapped() {
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
