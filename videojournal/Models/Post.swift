//
//  Post.swift
//  videojournal
//
//  Created by Tyler Thammavong on 5/05/23.
//

import FirebaseFirestore

struct Post: Codable {
    var id: String
    let photoUrl: String
    let user: User
    var createdAt: Timestamp = Timestamp(date: Date())
    var isLocalImage = false
}
