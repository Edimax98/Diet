//
//  UpperCell.swift
//  Diet
//
//  Created by Даниил on 09/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import UIKit

class UpperCell: UITableViewCell {

    static var identifier = "UpperCell"
    
    @IBOutlet weak var upperCellTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        upperCellTitle.text = "Более 80 диет, отобранных профессиональными диетологами".localized
    }
}
