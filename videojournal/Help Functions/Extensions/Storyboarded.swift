//
//  Storyboarded.swift
//  videojournal
//
//  Created by Tyler Thammavong 
//
//  setting up storyvoard for user info/chats/contacts etc.

import Foundation
import UIKit

enum StoryboardName: String {
    case onboarding = "OnBoarding"
    case main = "Main"
    case chats = "Chats"
    case dialler = "Dialler"
    case contacts = "Contacts"
}

protocol Storyboarded {
    static func instantiate(storyboard name: StoryboardName) -> Self
}

extension Storyboarded where Self: UIViewController {
    static func instantiate(storyboard name: StoryboardName) -> Self {
        let id = String(describing: self)
        let storyboard = UIStoryboard(name: name.rawValue, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: id) as! Self
    }
}
