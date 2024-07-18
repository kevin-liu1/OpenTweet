//
//  StringFormatter.swift
//  OpenTweet
//
//  Created by Kevin Liu on 2024-07-18.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import Foundation
import UIKit

class StringFormatter {
    static func colorSelectedText(fullString: String, selectedTexts: [String], color: UIColor) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: fullString)
        
        for selectedText in selectedTexts {
            let range = (fullString as NSString).range(of: selectedText)
            if range.location != NSNotFound {
                attributedString.addAttribute(.foregroundColor, value: color, range: range)
            }
        }
        
        return attributedString
    }
    
    static func extractWordsWithPrefix(_ prefix: String, from input: String) -> [String] {
        let words = input.split(separator: " ")
        var result: [String] = []
        
        for word in words {
            if word.hasPrefix(prefix) {
                result.append(String(word))
            }
        }
        
        return result
    }
    
    static func detectLinks(from input: String) -> [String] {
        var links: [String] = []
        
        // Regular expression pattern for detecting URLs
        let pattern = "((?:http|https)://)?(?:www\\.)?\\S+(?:\\.\\S+)+(?:/\\S*)?"
        
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let nsString = input as NSString
            let results = regex.matches(in: input, options: [], range: NSRange(location: 0, length: nsString.length))
            
            for result in results {
                if let range = Range(result.range, in: input) {
                    let url = String(input[range])
                    links.append(url)
                }
            }
        } catch let error {
            print("Invalid regex: \(error.localizedDescription)")
        }
        
        return links
    }
}
