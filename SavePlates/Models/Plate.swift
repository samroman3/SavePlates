//
//  Plate.swift
//  SavePlates
//
//  Created by Levi Davis on 12/18/19.
//  Copyright © 2019 Sam Roman. All rights reserved.
//

import Foundation

struct Plate {
    let imageUrl: String
    let restaurantID: String
    let userID: String
    let claimStatus: Bool
    let dateCreated: Date
    let originalPrice: Double
    let discount: Double
    let tags: [String]
}
