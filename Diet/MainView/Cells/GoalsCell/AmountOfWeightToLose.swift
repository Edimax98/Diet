//
//  AmountOfWeightToLose.swift
//  Diet
//
//  Created by Даниил on 09/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import UIKit

class AmountOfWeightToLose: UITableViewCell {

    fileprivate let kgs = ["10","5","15","20","25","30","35"]
    static var identifier = "AmountOfWeightToLose"
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var goalsQuestionTitle: UILabel!
    @IBOutlet weak var goalsSubquestionTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "WeightToLoseCell", bundle: nil), forCellWithReuseIdentifier: WeightToLoseCell.identifier)
        goalsQuestionTitle.text = "Сколько килограмм Вы хотите сбросить?".localized
        goalsSubquestionTitle.text = "Ответьте на пару вопросов и мы сформируем вашу персональную диету".localized
    }
}

extension AmountOfWeightToLose: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return kgs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeightToLoseCell.identifier, for: indexPath) as? WeightToLoseCell else {
            print("cant deque")
            return UICollectionViewCell()
        }
        cell.kgLabel.text = kgs[indexPath.row]
        return cell
    }
}
