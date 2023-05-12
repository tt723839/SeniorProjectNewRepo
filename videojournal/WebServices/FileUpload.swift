//
//  FileUpload.swift
//  videojournal
//
//  Created by Tyler Thammavong on 5/09/23.
//

import FirebaseStorage
import FirebaseFirestoreSwift
import Filestack

...

// Get a reference to the Firebase Storage root
let storageRef = Storage.storage().reference()

// Define a path for the uploaded image
let imagePath = "images/\(UUID().uuidString).jpg"

// Use the Filepicker SDK to pick an image and upload it to Firebase Storage
FilestackPicker().pick(
    from: self,
    storeOptions: [.location(.s3)],
    uploadOptions: [.storeAccess(.public)],
    completionHandler: { (response) in
        guard let fileUrl = response?.contents?.first?.url else { return }
        
        // Upload the image to Firebase Storage
        let imageRef = storageRef.child(imagePath)
        imageRef.putFile(from: fileUrl, metadata: nil) { (metadata, error) in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
            } else {
                print("Image uploaded successfully!")
                // Do something with the uploaded image URL
                let imageUrl = metadata?.downloadURL()?.absoluteString
            }
        }
    },
    onError: { (error) in
        print("Error picking image: \(error.localizedDescription)")
    }
)
let db = Firestore.firestore()
let imageCollectionRef = db.collection("images")

