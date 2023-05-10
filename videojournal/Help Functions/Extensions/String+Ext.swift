//
//  String+Ext.swift
//  videojournal
//
//  Created by Tyler Thammavong
//

import UIKit

extension String {
    func underlineWithItalic(font: UIFont) -> NSAttributedString {
        NSMutableAttributedString(string: self, attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue, .font: font])
    }
    
    func attributedString(font: UIFont) -> NSAttributedString {
        NSAttributedString(string: self, attributes: [.font: font])
    }
    
    func width(withHeight constrainedHeight: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: constrainedHeight)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(boundingBox.width)
    }
    
    func height(withWidth constrainedWidth: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: constrainedWidth, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(boundingBox.height)
    }
    
    /// mask example: `+X (XXX) XXX-XXXX`
    func format(with mask: String = "+X (XXX) XXX-XXXX") -> String {
        let numbers = self.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex // numbers iterator

        // iterate over the mask characters until the iterator of numbers ends
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                // mask requires a number in this place, so take the next one
                result.append(numbers[index])

                // move numbers iterator to the next index
                index = numbers.index(after: index)

            } else {
                result.append(ch) // just append a mask character
            }
        }
        return result
    }
}

extension StringProtocol {
    
    /// Returns the string with only [0-9], all other characters are filtered out
    var digitsOnly: String {
        return String(filter(("0"..."9").contains))
    }
}

extension String? {
    var isNilOrEmpty: Bool {
        return self == nil || self == ""
    }
}
