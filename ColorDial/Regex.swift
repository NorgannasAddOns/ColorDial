//
//  Regex.swift
//  ColorDial
//
//  Created by Kenneth Allan on 6/12/2015.
//  Copyright © 2015 Kenneth Allan. All rights reserved.
//

import Foundation

extension String {
    func rangeFromNSRange(_ nsRange : NSRange) -> Range<String.Index>? {
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
    func stringAtRange(_ value: String, _ index: Int) -> String {
        let nsrange = self.rangeAt(index)
        let range = value.rangeFromNSRange(nsrange)
        return value.substring(with: range!)
    }
}

class Regex {
    let internalExpression: NSRegularExpression
    let pattern: String
    
    init(_ pattern: String) {
        self.pattern = pattern
        try! self.internalExpression = NSRegularExpression(
            pattern: pattern, options: .caseInsensitive
        )
    }
    
    func match(_ input: String) -> [NSTextCheckingResult] {
        let matches = self.internalExpression.matches(
            in: input,
            options: [],
            range: NSMakeRange(0, input.characters.count)
        )
        return matches
    }
    
    func test(_ input: String) -> Bool {
        return match(input).count > 0
    }
}
