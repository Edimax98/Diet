//
//  LaunchManager.swift
//  Diet
//
//  Created by Даниил on 11/12/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import UIKit

class LaunchManager {
    
    private let mainWindow: UIWindow
    
    init(window: UIWindow) {
        self.mainWindow = window
    }
    
    func launch() {
        
        guard UserDefaults.standard.bool(forKey: "wereWelcomePagesShown") == false else {
            mainWindow.rootViewController = DietViewController.controllerInStoryboard(UIStoryboard(name: "Main" , bundle: nil))
            return
        }
        mainWindow.rootViewController = WelcomePageViewController.controllerInStoryboard(UIStoryboard(name: "Main", bundle: nil))
    }
}
