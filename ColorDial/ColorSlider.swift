//
//  ColorSlider.swift
//  ColorDial
//
//  Created by Kenneth Allan on 30/11/2015.
//  Copyright © 2015 Kenneth Allan. All rights reserved.
//

import Cocoa

class ColorSlider: NSSliderCell {
    var grad: NSGradient! = nil
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        grad = NSGradient.init(
            startingColor: NSColor(red: 0, green: 0, blue: 0, alpha: 1),
            endingColor: NSColor(red: 1, green: 1, blue: 1, alpha: 1)
        )
    }
    
    func setColors(r1:Int, g1:Int, b1:Int, r2:Int, g2:Int, b2:Int) {
        grad = NSGradient.init(
            startingColor: NSColor(red: CGFloat(r1)/255, green: CGFloat(g1)/255, blue: CGFloat(b1)/255, alpha: 1),
            endingColor: NSColor(red: CGFloat(r2)/255, green: CGFloat(g2)/255, blue: CGFloat(b2)/255, alpha: 1)
        )
    }

    
    func setSaturation(h:Int, l:Int) {
        grad = NSGradient.init(
            startingColor: NSColor(hue: CGFloat(h)/360, saturation: 0, brightness: CGFloat(l)/100, alpha: 1),
            endingColor: NSColor(hue: CGFloat(h)/360, saturation: 1, brightness: CGFloat(l)/100, alpha: 1)
        )
    }
    
    func setBrightness(h:Int, s:Int) {
        grad = NSGradient.init(
            startingColor: NSColor(hue: CGFloat(h)/360, saturation: CGFloat(s)/100, brightness: 0, alpha: 1),
            endingColor: NSColor(hue: CGFloat(h)/360, saturation: CGFloat(s)/100, brightness: 1, alpha: 1)
        )
    }
    
    func setHue(s:Int, l:Int) {
        let ss = CGFloat(s)/100
        let ll = CGFloat(l)/100
        
        grad = NSGradient.init(colors: [
            NSColor(hue: 0/360, saturation: ss, brightness: ll, alpha: 1),
            NSColor(hue: 30/360, saturation: ss, brightness: ll, alpha: 1),
            NSColor(hue: 60/360, saturation: ss, brightness: ll, alpha: 1),
            NSColor(hue: 90/360, saturation: ss, brightness: ll, alpha: 1),
            NSColor(hue: 120/360, saturation: ss, brightness: ll, alpha: 1),
            NSColor(hue: 150/360, saturation: ss, brightness: ll, alpha: 1),
            NSColor(hue: 180/360, saturation: ss, brightness: ll, alpha: 1),
            NSColor(hue: 210/360, saturation: ss, brightness: ll, alpha: 1),
            NSColor(hue: 240/360, saturation: ss, brightness: ll, alpha: 1),
            NSColor(hue: 270/360, saturation: ss, brightness: ll, alpha: 1),
            NSColor(hue: 300/360, saturation: ss, brightness: ll, alpha: 1),
            NSColor(hue: 330/360, saturation: ss, brightness: ll, alpha: 1),
            NSColor(hue: 360/360, saturation: ss, brightness: ll, alpha: 1),
        ])
    }
    
    override func drawBarInside(aRect: NSRect, flipped: Bool) {
        var rect = aRect
        
        rect.offsetInPlace(dx: 5, dy: -5)
        rect.size.height += 10
        rect.size.width -= 10
        
        let barRadius = CGFloat(5)
        
        let value = CGFloat((self.doubleValue - self.minValue) / (self.maxValue - self.minValue))
        
        let finalWidth = CGFloat(value * (self.controlView!.frame.size.width - 8))
        
        var leftRect = rect
        
        leftRect.size.width = finalWidth
        
        let bg = NSBezierPath(roundedRect: rect, xRadius: barRadius, yRadius: barRadius)
        
        grad.drawInBezierPath(bg, angle: 0)
    }
}
