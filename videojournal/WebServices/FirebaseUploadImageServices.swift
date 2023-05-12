//
//  FirebaseUploadImageServices.swift
//  videojournal
//
//  Created by Tyler Thammavong on 5/06/23.
//

import FirebaseStorage
import FirebaseFirestoreSwift
import UIKit

protocol StorageServicesProtocol {
    func uploadPhoto(with data: Data) async throws -> URL
}

class FirebaseUploadImageServices: StorageServicesProtocol {
    let storageRef = Storage.storage().reference()
    
    func uploadPhoto(with data: Data) async throws -> URL {
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        let ref = storageRef.child("\(UUID().uuidString).jpeg")
        _ = try await ref.putDataAsync(data)
        let downloadURL = try await ref.downloadURL()
        return downloadURL
    }
}
