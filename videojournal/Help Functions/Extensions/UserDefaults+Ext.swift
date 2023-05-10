//
//  UserDefaults+Ext.swift
//  videojournal
//
//  Created by Tyler Thammavong
//
//  json to data for user info in resources

import Foundation

extension UserDefaults {
    func storeCodable<T: Codable>(_ object: T, forKey: String) {
        do {
            let data = try JSONEncoder().encode(object)
            UserDefaults.standard.set(data, forKey: forKey)
        } catch let error {
            print("Error encoding: \(error)")
        }
    }
    
    func retrieveCodable<T: Codable>(for key: String) -> T? {
        do {
            guard let data = UserDefaults.standard.data(forKey: key) else {
                return nil
            }
            return try JSONDecoder().decode(T.self, from: data)
        } catch let error {
            print("Error decoding: \(error)")
            return nil
        }
    }
}

