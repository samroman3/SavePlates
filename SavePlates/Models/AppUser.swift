//
//  AppUser.swift
//  SavePlates
//
//  Created by Levi Davis on 12/18/19.
//  Copyright © 2019 Sam Roman. All rights reserved.
//


import Foundation
import FirebaseFirestore
import FirebaseAuth

struct AppUser {
    let email: String?
    let uid: String
    let userExperience: String?
    let dateCreated: Date?
    
//    MARK: - Init
    
    init(from user: User) {
        self.email = user.email
        self.uid = user.uid
        self.userExperience = user.displayName
        self.dateCreated = user.metadata.creationDate
    }
    
    init?(from dict: [String: Any], id: String) {
        guard let userExperience = dict["userExperience"] as? String,
        let email = dict["email"] as? String,
        let dateCreated = (dict["dateCreated"] as? Timestamp)?.dateValue() else {return nil}
        
        self.userExperience = userExperience
        self.email = email
        self.dateCreated = dateCreated
        self.uid = id
    }
    
    var fieldsDict: [String: Any] {
        return ["userExperience": self.userExperience ?? "", "email": self.email ?? ""]
    }
}
