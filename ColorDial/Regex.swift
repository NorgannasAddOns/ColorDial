//
//  Regex.swift
//  ColorDial
//
//  Created by Kenneth Allan on 6/12/2015.
//  Copyright © 2015 Kenneth Allan. All rights reserved.
//

import Foundation

extension String {
    func rangeFromNSRange(nsRange : NSRange) -> Range<String.Index>? {
        let from16 = utf16.startIndex.advancedBy(nsRange.location, limit: utf16.endIndex)
        let to16 = from16.advancedBy(nsRange.length, limit: utf16.endIndex)
        if let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self) {
                return from ..< to
        }
        return nil
    }
}

extension NSTextCheckingResult {
    func stringAtRange(value: String, _ index: Int) -> String {
        let nsrange = self.rangeAtIndex(index)
        let range = value.rangeFromNSRange(nsrange)
        return value.substringWithRange(range!)
    }
}

class Regex {
    let internalExpression: NSRegularExpression
    let pattern: String
    
    init(_ pattern: String) {
        self.pattern = pattern
        try! self.internalExpression = NSRegularExpression(
            pattern: pattern, options: .CaseInsensitive
        )
    }
    
    func match(input: String) -> [NSTextCheckingResult] {
        let matches = self.internalExpression.matchesInString(
            input,
            options: [],
            range: NSMakeRange(0, input.characters.count)
        )
        return matches
    }
    
    func test(input: String) -> Bool {
        return match(input).count > 0
    }
}
