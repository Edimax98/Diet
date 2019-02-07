//
//  WeekRationCell.swift
//  Diet
//
//  Created by Даниил on 07/02/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import UIKit

class WeekRationCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    static var identifier = "WeekRationCell"
    
    var weekDishes = [Dish]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "DishCell", bundle: nil), forCellWithReuseIdentifier: DishCell.identifier)
    }
}

extension WeekRationCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 250)
    }

}

extension WeekRationCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DishCell.identifier, for: indexPath) as? DishCell else {
            print("Could not deque dish cell")
            return UICollectionViewCell()
        }
        //        let dish = weekDishes[indexPath.row]
        //
        //        cell.dishNameLabel.text = dish.name
        //        cell.dishCaloriesLabel.text = "\(dish.nutritionValue.calories)"
        
        return cell
    }
}
