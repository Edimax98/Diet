//
//  HumanСharacteristic.swift
//  Diet
//
//  Created by Даниил on 09/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import UIKit

class HumanCharacteristic: UITableViewCell {

    fileprivate let ages = ["25-30","30-35","35-40","40-45"]
    fileprivate let weights = ["50-60","60-70","70-80","80-90","90-100"]
    fileprivate let heights = ["145-150", "150-155","155-160","160-165","165-170"]
    
    @IBOutlet weak var ageSelectorCollectionView: UICollectionView!
    @IBOutlet weak var weightSelectorCollectionView: UICollectionView!
    @IBOutlet weak var heightSelectorCollectionView: UICollectionView!
    
    @IBOutlet weak var genderSelectorTitle: UILabel!
    @IBOutlet weak var ageSelectorTitle: UILabel!
    @IBOutlet weak var weightSelectorTitle: UILabel!
    @IBOutlet weak var heightSelectorTitle: UILabel!
    
    static var identifier = "HumanCharacteristicCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        registerCells()
        setLabels()
        setDataSoursecAndDelegates()
    }
    
    private func setDataSoursecAndDelegates() {
        ageSelectorCollectionView.dataSource = self
        heightSelectorCollectionView.dataSource = self
        weightSelectorCollectionView.dataSource = self
        ageSelectorCollectionView.delegate = self
        heightSelectorCollectionView.delegate = self
        weightSelectorCollectionView.delegate = self
    }
    
    private func registerCells() {
        ageSelectorCollectionView.register(UINib(nibName: "CharacteristicCell", bundle: nil), forCellWithReuseIdentifier: CharacteristicCell.identifier)
        weightSelectorCollectionView.register(UINib(nibName: "CharacteristicCell", bundle: nil), forCellWithReuseIdentifier: CharacteristicCell.identifier)
        heightSelectorCollectionView.register(UINib(nibName: "CharacteristicCell", bundle: nil), forCellWithReuseIdentifier: CharacteristicCell.identifier)
    }
    
    private func setLabels() {
        genderSelectorTitle.text = "Укажите ваш пол".localized
        ageSelectorTitle.text = "Укажите ваш возраст".localized
        heightSelectorTitle.text = "Укажите ваш рост (см)".localized
        weightSelectorTitle.text = "Укажите ваш вес (кг)".localized
    }
}

extension HumanCharacteristic: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView === ageSelectorCollectionView {
            return ages.count
        }
        
        if collectionView === weightSelectorCollectionView {
            return weights.count
        }
        
        if collectionView === heightSelectorCollectionView {
            return heights.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacteristicCell.identifier, for: indexPath) as? CharacteristicCell else {
            print("cant deque")
            return UICollectionViewCell()
        }
        
        if collectionView === ageSelectorCollectionView {
            cell.characteristicLabel.text = ages[indexPath.row]
            return cell
        }
        
        if collectionView === weightSelectorCollectionView {
            cell.characteristicLabel.text = weights[indexPath.row]
            return cell
        }
        
        if collectionView === heightSelectorCollectionView {
            cell.characteristicLabel.text = heights[indexPath.row]
            return cell
        }

        return cell
    }
}

extension HumanCharacteristic: UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        let marginsAndInsets = inset * 2.0 + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
//        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
//        return CGSize(width: itemWidth, height: cellHeight)
//    }
}
