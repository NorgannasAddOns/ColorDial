//
//  String.swift
//  ColorDial
//
//  Created by Kenneth Allan on 13/12/2015.
//  Copyright © 2015 Kenneth Allan. All rights reserved.
//

import Foundation

extension String {
    func hexNibbleAt(_ i: Int) -> Int {
        let c = self[i] as Character
        switch (c) {
        case "0": return 0
        case "1": return 1
        case "2": return 2
        case "3": return 3
        case "4": return 4
        case "5": return 5
        case "6": return 6
        case "7": return 7
        case "8": return 8
        case "9": return 9
        case "a", "A": return 10
        case "b", "B": return 11
        case "c", "C": return 12
        case "d", "D": return 13
        case "e", "E": return 14
        case "f", "F": return 15
        default: break
        }
        return 0
    }
    
    func hexByteAt(_ i: Int) -> Int {
        return hexNibbleAt(i) * 16 + hexNibbleAt(i+1)
    }
    
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    subscript (r: Range<Int>) -> String {
        return String(self[index(startIndex, offsetBy: r.lowerBound) ..< index(startIndex, offsetBy: r.upperBound)])
    }
}
