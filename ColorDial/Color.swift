//
//  Color.swift
//  ColorDial
//
//  Created by Kenneth Allan on 11/12/2015.
//  Copyright © 2015 Kenneth Allan. All rights reserved.
//

import Cocoa

extension NSColor {
    func get(hue: UnsafeMutablePointer<CGFloat>, saturation: UnsafeMutablePointer<CGFloat>, lightness: UnsafeMutablePointer<CGFloat>, alpha: UnsafeMutablePointer<CGFloat>) {
        var r, g, b, h, s, l: CGFloat
        
        r = 0
        g = 0
        b = 0

        self.getRed(&r, green: &g, blue: &b, alpha: alpha)
        
        h = 0
        s = 0
        let v: CGFloat = max(r, g, b)
        let m: CGFloat = min(r, g, b)
        
        l = (m + v) / 2
        if l < 0 {
            hue.initialize(h)
            saturation.initialize(s)
            lightness.initialize(l)
            return
        }
        
        let vm = v - m
        s = vm
        
        if s <= 0 {
            hue.initialize(h)
            saturation.initialize(s)
            lightness.initialize(l)
            return
        }
        
        s /= l <= 0.5 ? v + m : 2 - vm

        let r2 = (v - r) / vm
        let g2 = (v - g) / vm
        let b2 = (v - b) / vm
        
        if r == v {
            h = g == m ? 5 + b2 : 1 - g2
        } else if (g == v) {
            h = b == m ? 1 + r2 : 3 - b2
        } else {
            h = r == m ? 3 + g2 : 5 - r2
        }
        
        h /= 6
        
        hue.initialize(h)
        saturation.initialize(s)
        lightness.initialize(l)
    }
    
    static func colorWith(hue: CGFloat, saturation: CGFloat, lightness: CGFloat, alpha: CGFloat) -> NSColor {
        if saturation == 0 {
            return NSColor(red: lightness, green: lightness, blue: lightness, alpha: alpha)
        }
        
        let t2 = lightness < 0.5 ? lightness * (1 + saturation) : lightness + saturation - lightness * saturation
        let t1 = 2 * lightness - t2
        
        var c = [CGFloat](count: 3, repeatedValue: hue)
        c[0] = hue + 1 / 3
        c[1] = hue
        c[2] = hue + 1 / 3
        
        for var i = 0; i < 3; i++ {
            if c[i] < 0 {
                c[i] += 1
            }
            if c[i] > 1 {
                c[i] -= 1
            }
            
            if c[i] * 6 < 1 {
                c[i] = t1 + (t2 - t1) * c[i] * 6
            } else if c[i] * 2 < 1 {
                c[i] = t2
            } else if c[i] * 3 < 2 {
                c[i] = t1 + (t2 - t1) * ((2/3) - c[i]) * 6
            } else {
                c[i] = t1
            }
        }
        
        return NSColor(red: c[0], green: c[1], blue: c[2], alpha: alpha)
    }
}


func mapRange(value: CGFloat, _ fromLower: CGFloat, _ fromUpper: CGFloat, _ toLower: CGFloat, _ toUpper: CGFloat) -> CGFloat {
    return (round((toLower) + (value - fromLower) * ((toUpper - toLower) / (fromUpper - fromLower))));
}

func convertHueRYBtoRGB(hue: CGFloat) -> CGFloat {
    if hue < 60 { return (round((hue) * (35 / 60))) }
    if hue < 122 { return mapRange(hue, 60,  122, 35,  60) }
    if hue < 165 { return mapRange(hue, 122, 165, 60,  120) }
    if hue < 218 { return mapRange(hue, 165, 218, 120, 180) }
    if hue < 275 { return mapRange(hue, 218, 275, 180, 240) }
    if hue < 330 { return mapRange(hue, 275, 330, 240, 300) }
    return mapRange(hue, 330, 360, 300, 360)
}

func convertHueRGBtoRYB (hue: CGFloat) -> CGFloat {
    if hue < 35 { return (round(CGFloat(hue) * (60 / 35))) }
    if hue < 60 { return mapRange(hue, 35,  60,  60,  122) }
    if hue < 120 { return mapRange(hue, 60,  120, 122, 165) }
    if hue < 180 { return mapRange(hue, 120, 180, 165, 218) }
    if hue < 240 { return mapRange(hue, 180, 240, 218, 275) }
    if hue < 300 { return mapRange(hue, 240, 300, 275, 330) }
    return mapRange(hue, 300, 360, 330, 360)
}

func addValueOverflowCap(v: CGFloat, _ add: CGFloat, cap: CGFloat = 100, min: CGFloat = -1, max: CGFloat = -1) -> CGFloat {
    var w = v + add
    if (min > -1 && w < min) { w = min }
    if (max > -1 && w > max) { w = max }
    
    if w > cap {
        return cap
    } else if w < 0 {
        return 0
    }
    return w
}

func addValueOverflowFlip(v: CGFloat, _ add: CGFloat, cap: CGFloat = 100, lcap: CGFloat = 0, min: CGFloat = -1, max: CGFloat = -1) -> CGFloat {
    var w = v + add
    if (min > -1 && w < min) { w = min }
    if (max > -1 && w > max) { w = max }
    
    // If we overflow, need to subtract instead
    if (w > cap || w < lcap) {
        return v - add
    }
    
    return w
}

func addValueOverflowBounce(v: CGFloat, _ add: CGFloat, cap: CGFloat = 100, lcap: CGFloat = 0, min: CGFloat = -1, max: CGFloat = -1) -> CGFloat {
    var w = v + add
    if (min > -1 && w < min) { w = min }
    if (max > -1 && w > max) { w = max }
    
    // If we overflow, need to subtract overflow amount
    if (w > cap) {
        return cap - (w - cap)
    } else if (w < lcap) {
        return lcap + (lcap - w)
    }
    return w
}

func addValueOverflowSlow(v: CGFloat, _ add: CGFloat, cap: CGFloat = 100, lcap: CGFloat = 0, min: CGFloat = -1, max: CGFloat = -1, brake: CGFloat = -1) -> CGFloat {
    var w = v + add
    if (min > -1 && w < min) { w = min }
    if (max > -1 && w > max) { w = max }
    
    let b = brake > -1 ? brake : abs(add)
    
    // Stop us from overflowing by slowing add down (by 50%) as we approch cap.
    if (w > cap - b) {
        let d = v - (cap - b)
        w = v + (floor((add) * (d)/(b)))
        return w
    } else if (w < lcap + b) {
        let d = lcap + b - w
        w += (floor((d) / 2))
    }
    return w
}

func addValueOverflowOppose(v: CGFloat, _ add: CGFloat, cap: CGFloat = 100, roffs: CGFloat = 0) -> CGFloat {
    var w = v + add
    if w > cap { w = (roffs + w) % cap }
    return w
}



