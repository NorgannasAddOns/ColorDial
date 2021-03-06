//
//  Regex.swift
//  ColorDial
//
//  Created by Kenneth Allan on 6/12/2015.
//  Copyright © 2015 Kenneth Allan. All rights reserved.
//

import Foundation

extension String {
    func rangeFromNSRange(_ nsRange: NSRange) -> Range<String.Index>? {
        let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location)
        let to16 = utf16.index(from16, offsetBy: nsRange.length)
        if let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self) {
                return from ..< to
        }
        return nil
    }
}

extension NSTextCheckingResult {
    func stringAtRange(_ value: String, _ index: Int) -> String {
        let nsrange = self.range(at: index)
        let range = value.rangeFromNSRange(nsrange)
        return String(value[range!])
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
            range: NSRange(location: 0, length: input.count)
        )
        return matches
    }
    
    func test(_ input: String) -> Bool {
        return match(input).count > 0
    }
}
