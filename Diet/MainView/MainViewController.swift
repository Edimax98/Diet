//
//  ViewController.swift
//  Diet
//
//  Created by Даниил on 09/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    fileprivate let amountOfSection = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        registerCells(for: tableView)
    }
    
    private func registerCells(for tableView: UITableView) {
        tableView.register(UINib(nibName: "UpperCell", bundle: nil), forCellReuseIdentifier: UpperCell.identifier)
        tableView.register(UINib(nibName: "AmountOfWeightToLose", bundle: nil), forCellReuseIdentifier: AmountOfWeightToLose.identifier)
        tableView.register(UINib(nibName: "HumanСharacteristic", bundle: nil), forCellReuseIdentifier: HumanCharacteristic.identifier)
    }
}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return amountOfSection
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: UpperCell.identifier, for: indexPath) as? UpperCell else {
                return UITableViewCell()
            }
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AmountOfWeightToLose.identifier, for: indexPath) as? AmountOfWeightToLose else {
                return UITableViewCell()
            }
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HumanCharacteristic.identifier, for: indexPath) as? HumanCharacteristic else {
                return UITableViewCell()
            }
            return cell
        default:
            break
        }
        return UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            return 250
        case 1:
            return 290
        case 2:
            return 450
        default:
            return 250
        }
    }
}

extension MainViewController: MainPageInteractorOutput {
    
    func sendRecipe(_ recipe: Recipe) {
        
    }
}
