//
//  User.swift
//  videojournal
//
//  Created by Tyler Thammavong 05/05/2023
//
import Foundation

struct User: Codable {
    let id: String
    let name: String
    let photoURL: String
    
    static let mockData = [
        User(id: UUID().uuidString, name: "Kaitlyn Wills", photoURL: "https://firebasestorage.googleapis.com/v0/b/project-1b74f.appspot.com/o/ME%201%201.png?alt=media&token=4bd05cc7-c809-436a-a07a-583642400e58"),
        User(id: UUID().uuidString, name: "Mike Allison", photoURL: "https://firebasestorage.googleapis.com/v0/b/project-1b74f.appspot.com/o/istockphoto-941241246-612x612%201.png?alt=media&token=b92c5f96-9b2b-4b93-882f-b2ed8920326e"),
        User(id: UUID().uuidString, name: "Steve Martin", photoURL: "https://firebasestorage.googleapis.com/v0/b/project-1b74f.appspot.com/o/ME%201%202.png?alt=media&token=66c0bea3-ce59-43b7-aa3a-dbc5b118f6f0"),
        User(id: UUID().uuidString, name: "Tyler Tham", photoURL: "https://firebasestorage.googleapis.com/v0/b/project-1b74f.appspot.com/o/prof.webp?alt=media&token=ea1b6e40-c622-4d77-92ea-4679dec91635"),
    ]
}
