//
//  FirebaseAuthService.swift
//  SavePlates
//
//  Created by Sam Roman on 12/18/19.
//  Copyright © 2019 Sam Roman. All rights reserved.
//

import Foundation
import FirebaseAuth

class FirebaseAuthService {
    
    static let manager = FirebaseAuthService()
    
    private let auth = Auth.auth()
    
    var currentUser: User? {
        return auth.currentUser
    }
    
    func createNewUser(email: String, password: String, completion: @escaping (Result<User, Error>) -> ()) {
        auth.createUser(withEmail: email, password: password) { (result, error) in
            if let createdUser = result?.user {
                completion(.success(createdUser))
            } else {
                if let error = error {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func updateUserFields(experience: String? = nil, completion: @escaping (Result<(), Error>) -> ()) {
        let changeRequest = auth.currentUser?.createProfileChangeRequest()
        if let experience = experience {
            changeRequest?.displayName = experience
        }
        
        changeRequest?.commitChanges(completion: { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        })
    }
    
    func loginUser(email: String, password: String, completion: @escaping(Result<(), Error>) -> ()) {
        auth.signIn(withEmail: email, password: password) { (result, error) in
            
            if result?.user != nil {
                completion(.success(()))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    
    func logoutUser() {
        do {
            try auth.signOut()
            print("logging out")
        } catch {
            print(error)
        }
        
    }
    
    private init() {}
    
}
