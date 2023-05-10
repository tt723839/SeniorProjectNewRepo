//
//  Array+Ext.swift
//  videojournal
//
//  Created by Tyler Thammavong
//

import Foundation

extension Array where Element: Equatable {
    
    @discardableResult mutating func remove(object: Element) -> Bool {
        if let index = firstIndex(of: object) {
            self.remove(at: index)
            return true
        }
        return false
    }
    
    @discardableResult mutating func remove(where predicate: (Array.Iterator.Element) -> Bool) -> Bool {
        if let index = self.firstIndex(where: { (element) -> Bool in
            return predicate(element)
        }) {
            self.remove(at: index)
            return true
        }
        return false
    }
    
    @discardableResult
    public mutating func update(_ element: Element) -> Bool {
        if let f = self.firstIndex(where: { $0 == element}) {
            self[f] = element
            return true
        }
        return false
    }
}

extension Array {
    mutating func rearrange(from: Int, to: Int) {
        insert(remove(at: from), at: to)
    }
}
