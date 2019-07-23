//
//  NSUserDefaults.swift
//  ColorDial
//
//  Created by Kenneth Allan on 13/12/2015.
//  Copyright © 2015 Kenneth Allan. All rights reserved.
//

import Cocoa

extension UserDefaults {
    func setNSColor(_ value: NSColor, forKey: String) {
        var c = [Double](repeating: 0, count: 3)
        c[0] = Double(value.redComponent)
        c[1] = Double(value.greenComponent)
        c[2] = Double(value.blueComponent)
        self.set(c, forKey: forKey)
    }
    
    func NSColorForKey(_ defaultName: String) -> NSColor? {
        if let c = self.array(forKey: defaultName) {
            let r = c[0] as! Double
            let g = c[1] as! Double
            let b = c[2] as! Double
            return NSColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: 1)
        }
        return nil
    }
}
