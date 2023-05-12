//
//  FirebasePostServices.swift
//  videojournal
//
//  Created by Tyler Thammavong on 5/11/23.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

protocol FirebasePostServicesProtocol {
    var listener: ListenerRegistration? { get }
    func fetch(completion: @escaping(Result<[Post], Error>) -> Void)
    func save(with data: Post) async throws
}

class PostServices: FirebasePostServicesProtocol {
    let firestoreRef = Firestore.firestore()
    var listener: ListenerRegistration?
    
    func fetch(completion: @escaping(Result<[Post], Error>) -> Void) {
        listener = firestoreRef.collection("posts")
            .addSnapshotListener({ querySnapshot, error in
                
                guard let snapshot = querySnapshot else {
                    print("Error fetching snapshots: \(error!)")
                    completion(.failure(error!))
                    return
                }
                
                if snapshot.isEmpty {
                    completion(.success([]))
                    return
                }
                
                let goals = snapshot.documents.compactMap({ try? $0.data(as: Post.self) })
                completion(.success(goals))
            })
    }
    
    func save(with data: Post) async throws {
        var postData = data
        let query = firestoreRef.collection("posts").document()
        postData.id = query.documentID
        
        try await query
            .setData(postData.dictionary ?? [:], merge: true)
    }
}
