//
//  NSUserDefaults.swift
//  ColorDial
//
//  Created by Kenneth Allan on 13/12/2015.
//  Copyright © 2015 Kenneth Allan. All rights reserved.
//

import Cocoa

extension NSUserDefaults {
    func setNSColor(value: NSColor, forKey: String) {
        var c = [Double](count: 3, repeatedValue: 0)
        c[0] = Double(value.redComponent)
        c[1] = Double(value.greenComponent)
        c[2] = Double(value.blueComponent)
        self.setObject(c, forKey: forKey)
    }
    
    func NSColorForKey(defaultName: String) -> NSColor? {
        if let c = self.arrayForKey(defaultName) {
            let r = c[0] as! Double
            let g = c[1] as! Double
            let b = c[2] as! Double
            return NSColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: 1)
        }
        return nil
    }
}
