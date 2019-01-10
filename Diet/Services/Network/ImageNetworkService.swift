//
//  ImageNetworkService.swift
//  Diet
//
//  Created by Даниил on 10/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation
import AlamofireImage

protocol ImageNetworkService {
    func fetchImages(with paths: [String], completion: @escaping ([String: Image]) -> ())
}
