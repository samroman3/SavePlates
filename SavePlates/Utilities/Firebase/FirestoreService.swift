//
//  FirestoreService.swift
//  SavePlates
//
//  Created by Levi Davis on 12/18/19.
//  Copyright © 2019 Sam Roman. All rights reserved.
//

import Foundation
import FirebaseFirestore

fileprivate enum FireStoreCollections: String {
    case users
    case plates
    case userplates
    
}

enum SortingCriteria: String {
    case fromNewestToOldest = "dateCreated"
    var shouldSortDescending: Bool {
        switch self {
        case .fromNewestToOldest:
            return true
        }
    }
}

class FirestoreService {
    
    static let manager = FirestoreService()
    
    private let db = Firestore.firestore()
    
    //        MARK: - AppUsers
    
    func createAppUser(user: AppUser, completion: @escaping (Result<(), Error>) -> ()) {
        var fields: [String : Any] = user.fieldsDict
        fields["dateCreated"] = Date()
        db.collection(FireStoreCollections.users.rawValue).document(user.uid).setData(fields) { (error) in
            if let error = error {
                completion(.failure(error))
            }
            completion(.success(()))
        }
    }
    
    func updatePlateStatus(newStatus: Bool?, plateID: String, completion: @escaping (Result <(), Error>) -> ()) {
        guard let userID = FirebaseAuthService.manager.currentUser?.uid else {
            return
        }
        var updateFields = [String : Any]()
        if let status = newStatus {
            updateFields["claimStatus"] = status
            updateFields["userID"] = userID
        }

        
        let plate = db.collection("plates").document(plateID)

        plate.updateData(updateFields) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
        
            
        }

    
    
    func getAllPlates(completion: @escaping (Result<[Plate], Error>) -> ()) {
        db.collection(FireStoreCollections.plates.rawValue).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                let plates = snapshot?.documents.compactMap({ (snapshot) -> Plate? in
                    let plateID = snapshot.documentID
                    let plate = Plate(from: snapshot.data(), id: plateID)
                    
                    return plate
                })
                completion(.success(plates ?? []))
            }
        }
    }
    //    MARK: - Events
//    func saveEvent(event: FavoriteEvent, completion: @escaping (Result <(), Error>) -> ()){
//        var fields = event.fieldsDict
//        fields["dateCreated"] = Date()
//        db.collection(FireStoreCollections.events.rawValue).addDocument(data: fields) { (error) in
//            if let error = error {
//                completion(.failure(error))
//            } else {
//                completion(.success(()))
//            }
//        }
//    }
//
//    func getAllPlates(sortingCriteria: SortingCriteria? = nil, completion: @escaping (Result <[Plate], Error>) -> ()) {
//        let completionHandler: FIRQuerySnapshotBlock = {(snapshot, error) in
//            if let error = error {
//                completion(.failure(error))
//            } else {
//                let plates = snapshot?.documents.compactMap({ (snapshot) -> Plate? in
//                    let plateID = snapshot.documentID
//                    let plate = Plate(from: snapshot.data(), id: plateID)
//                    return plate
//                })
//                completion(.success(plates ?? []))
//            }
//        }
//    }
//
//        let collection = db.collection(FireStoreCollections.events.rawValue)
//        if let sortingCriteria = sortingCriteria {
//            let query = collection.order(by: sortingCriteria.rawValue, descending: sortingCriteria.shouldSortDescending)
//            query.getDocuments(completion: completionHandler)
//        } else {
//            collection.getDocuments(completion: completionHandler)
//        }
//    }
//
    func getAvailablePlates(claimStatus: Bool, completion: @escaping (Result <[Plate], Error>) -> ()) {


        db.collection(FireStoreCollections.plates.rawValue).whereField("claimStatus", isEqualTo: claimStatus).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                let events = snapshot?.documents.compactMap({ (snapshot) -> Plate? in
                    let documentID = snapshot.documentID
                    let event = Plate(from: snapshot.data(), id: documentID)
                    return event
                })
                completion(.success(events ?? []))
            }
        }
    }
//
//    func deleteFavoriteEvent(forUserID: String, eventID: String, completion: @escaping (Result <(), Error>) -> ()) {
//
//        db.collection(FireStoreCollections.events.rawValue).whereField("creatorID", isEqualTo: forUserID).whereField("id", isEqualTo: eventID).getDocuments { (snapshot, error) in
//            if let error = error {
//                print("Error getting documents \(error)")
//                completion(.failure(error))
//            } else {
//                for document in snapshot!.documents {
//                    document.reference.delete()
//                    completion(.success(()))
//                }
//            }
//        }
//
//    }
//
////    MARK: - Art collection
//
//    func savePlate(plate: Plate, completion: @escaping (Result <(), Error>) -> ()){
//        var fields = plate.fieldsDict
//        fields["dateCreated"] = Date()
//        db.collection(FireStoreCollections.userplates.rawValue).addDocument(data: fields) { (error) in
//            if let error = error {
//                completion(.failure(error))
//            } else {
//                completion(.success(()))
//            }
//        }
//    }
//
//    func getAllArts(sortingCriteria: SortingCriteria? = nil, completion: @escaping (Result <[FavoriteArt], Error>) -> ()) {
//        let completionHandler: FIRQuerySnapshotBlock = {(snapshot, error) in
//            if let error = error {
//                completion(.failure(error))
//            } else {
//                let arts = snapshot?.documents.compactMap({ (snapshot) -> FavoriteArt? in
//                    let artID = snapshot.documentID
//                    let art = FavoriteArt(from: snapshot.data(), id: artID)
//                    return art
//                })
//                completion(.success(arts ?? []))
//            }
//        }
//
//        let collection = db.collection(FireStoreCollections.arts.rawValue)
//        if let sortingCriteria = sortingCriteria {
//            let query = collection.order(by: sortingCriteria.rawValue, descending: sortingCriteria.shouldSortDescending)
//            query.getDocuments(completion: completionHandler)
//        } else {
//            collection.getDocuments(completion: completionHandler)
//        }
//    }
//
//    func getArts(forUserID: String, completion: @escaping (Result <[FavoriteArt], Error>) -> ()) {
//
//
//        db.collection(FireStoreCollections.arts.rawValue).whereField("creatorID", isEqualTo: forUserID).getDocuments { (snapshot, error) in
//            if let error = error {
//                completion(.failure(error))
//            } else {
//                let arts = snapshot?.documents.compactMap({ (snapshot) -> FavoriteArt? in
//                    let artID = snapshot.documentID
//                    let art = FavoriteArt(from: snapshot.data(), id: artID)
//                    return art
//                })
//                completion(.success(arts ?? []))
//            }
//        }
//    }
//
//     func deleteFavoriteArt(forUserID: String, artID: String, completion: @escaping (Result <(), Error>) -> ()) {
//
//           db.collection(FireStoreCollections.arts.rawValue).whereField("creatorID", isEqualTo: forUserID).whereField("id", isEqualTo: artID).getDocuments { (snapshot, error) in
//               if let error = error {
//                   print("Error getting arts \(error)")
//                   completion(.failure(error))
//               } else {
//                   for document in snapshot!.documents {
//                       document.reference.delete()
//                       completion(.success(()))
//                   }
//               }
//           }
//    }
//
    private init() {}
}
