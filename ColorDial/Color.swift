//
//  Color.swift
//  ColorDial
//
//  Created by Kenneth Allan on 11/12/2015.
//  Copyright © 2015 Kenneth Allan. All rights reserved.
//

import Cocoa

extension NSColor {
    func get(_ hue: UnsafeMutablePointer<CGFloat>, saturation: UnsafeMutablePointer<CGFloat>, lightness: UnsafeMutablePointer<CGFloat>, alpha: UnsafeMutablePointer<CGFloat>) {
        var h, s, l: CGFloat
        
        //let color = self.colorUsingColorSpaceName(NSCalibratedRGBColorSpace)!
        
        let r = self.redComponent
        let g = self.greenComponent
        let b = self.blueComponent
        let a = self.alphaComponent
        
        h = 0
        s = 0
        let maxi: CGFloat = max(r, g, b)
        let mini: CGFloat = min(r, g, b)
        
        l = (mini + maxi) / 2
        if l >= 0 {
            let d = maxi - mini
            s = l > 0.5 ? d / (2 - maxi - mini) : d / (maxi + mini)
            if r == maxi {
                h = (g - b) / d + (g < b ? 6 : 0)
            } else if g == maxi {
                h = (b - r) / d + 2
            } else if b == maxi {
                h = (r - g) / d + 4
            }
            
            h /= 6
        }
        
        hue.initialize(to: h)
        saturation.initialize(to: s)
        lightness.initialize(to: l)
        alpha.initialize(to: a)
    }
    
    static func colorWith(_ hue: CGFloat, saturation: CGFloat, lightness: CGFloat, alpha: CGFloat) -> NSColor {
        if saturation == 0 {
            return NSColor(red: lightness, green: lightness, blue: lightness, alpha: alpha)
        }
        
        let q = lightness < 0.5 ? lightness * (1 + saturation) : lightness + saturation - lightness * saturation
        let p = 2 * lightness - q
        
        var rgb = [CGFloat](repeating: 0, count: 3)
        rgb[0] = hue + 1 / 3
        rgb[1] = hue
        rgb[2] = hue - 1 / 3
        
        for i in 0 ..< 3 {
            if rgb[i] < 0 {
                rgb[i] += 1
            }
            if rgb[i] > 1 {
                rgb[i] -= 1
            }
            
            if rgb[i] * 6 < 1 {
                rgb[i] = p + (q - p) * rgb[i] * 6
            } else if rgb[i] * 2 < 1 {
                rgb[i] = q
            } else if rgb[i] * 3 < 2 {
                rgb[i] = p + (q - p) * ((2/3) - rgb[i]) * 6
            } else {
                rgb[i] = p
            }
        }
        
        let color = NSColor(red: rgb[0], green: rgb[1], blue: rgb[2], alpha: alpha)
        return color
    }
    
    func colorDifference(_ with: NSColor) -> CGFloat {
        let r: CGFloat = pow(self.redComponent-with.redComponent, 2.0)
        let g: CGFloat = pow(self.greenComponent-with.greenComponent, 2.0)
        let b: CGFloat = pow(self.blueComponent-with.blueComponent, 2.0)

        let d: CGFloat = sqrt(r + g + b)
        return d
    }
}


func mapRange(_ value: CGFloat, _ fromLower: CGFloat, _ fromUpper: CGFloat, _ toLower: CGFloat, _ toUpper: CGFloat) -> CGFloat {
    return (round((toLower) + (value - fromLower) * ((toUpper - toLower) / (fromUpper - fromLower))));
}

func convertHueRYBtoRGB(_ hue: CGFloat) -> CGFloat {
    if hue < 60 { return (round((hue) * (35 / 60))) }
    if hue < 122 { return mapRange(hue, 60,  122, 35,  60) }
    if hue < 165 { return mapRange(hue, 122, 165, 60,  120) }
    if hue < 218 { return mapRange(hue, 165, 218, 120, 180) }
    if hue < 275 { return mapRange(hue, 218, 275, 180, 240) }
    if hue < 330 { return mapRange(hue, 275, 330, 240, 300) }
    return mapRange(hue, 330, 360, 300, 360)
}

func convertHueRGBtoRYB (_ hue: CGFloat) -> CGFloat {
    if hue < 35 { return (round(CGFloat(hue) * (60 / 35))) }
    if hue < 60 { return mapRange(hue, 35,  60,  60,  122) }
    if hue < 120 { return mapRange(hue, 60,  120, 122, 165) }
    if hue < 180 { return mapRange(hue, 120, 180, 165, 218) }
    if hue < 240 { return mapRange(hue, 180, 240, 218, 275) }
    if hue < 300 { return mapRange(hue, 240, 300, 275, 330) }
    return mapRange(hue, 300, 360, 330, 360)
}

func addValueOverflowCap(_ v: CGFloat, _ add: CGFloat, cap: CGFloat = 100, min: CGFloat = -1, max: CGFloat = -1) -> CGFloat {
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

func addValueOverflowFlip(_ v: CGFloat, _ add: CGFloat, cap: CGFloat = 100, lcap: CGFloat = 0, min: CGFloat = -1, max: CGFloat = -1) -> CGFloat {
    var w = v + add
    if (min > -1 && w < min) { w = min }
    if (max > -1 && w > max) { w = max }
    
    // If we overflow, need to subtract instead
    if (w > cap || w < lcap) {
        return v - add
    }
    
    return w
}

func addValueOverflowBounce(_ v: CGFloat, _ add: CGFloat, cap: CGFloat = 100, lcap: CGFloat = 0, min: CGFloat = -1, max: CGFloat = -1) -> CGFloat {
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

func addValueOverflowSlow(_ v: CGFloat, _ add: CGFloat, cap: CGFloat = 100, lcap: CGFloat = 0, min: CGFloat = -1, max: CGFloat = -1, brake: CGFloat = -1) -> CGFloat {
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

func addValueOverflowOppose(_ v: CGFloat, _ add: CGFloat, cap: CGFloat = 100, roffs: CGFloat = 0) -> CGFloat {
    var w = v + add
    if w > cap { w = (roffs + w).truncatingRemainder(dividingBy: cap) }
    return w
}



