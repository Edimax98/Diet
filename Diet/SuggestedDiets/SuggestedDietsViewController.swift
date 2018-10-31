//
//  SuggestedDietsViewController.swift
//  Diet
//
//  Created by Даниил on 30/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import UIKit

class SuggestedDietsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "SuggestedDietCell", bundle: nil), forCellWithReuseIdentifier: SuggestedDietCell.identifier)
    }
}

extension SuggestedDietsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SuggestedDietCell.identifier, for: indexPath) as? SuggestedDietCell else {
            return UICollectionViewCell()
        }
        return cell
    }
}

extension SuggestedDietsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width - 30, height: 270)
    }
}
