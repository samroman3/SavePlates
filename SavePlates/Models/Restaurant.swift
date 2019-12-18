//
//  Restaurant.swift
//  SavePlates
//
//  Created by Levi Davis on 12/18/19.
//  Copyright © 2019 Sam Roman. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Restaurant {
    let name: String
    let address: String
    let phone: String
    let websiteURL: String
    let restaurantID: String
    
    //    MARK: - Init
    init(name: String, address: String, phone: String, websiteURL: String, restaurantID: String){
        self.name = name
        self.address = address
        self.phone = phone
        self.websiteURL = websiteURL
        self.restaurantID = restaurantID
    }
    
    init?(from dict: [String: Any], id: String){
        guard let name = dict["name"] as? String,
            let address = dict["address"] as? String,
            let phone = dict["phone"] as? String,
            let websiteURL = dict["websiteURL"] as? String else {return nil}
        
        self.name = name
        self.address = address
        self.phone = phone
        self.websiteURL = websiteURL
        self.restaurantID = id
    }
    
    var fieldsDict: [String: Any] {
        return ["name": self.name, "address": self.address, "phone": self.phone, "websiteURL": self.websiteURL, "restaurantID": self.restaurantID]
    }
}
