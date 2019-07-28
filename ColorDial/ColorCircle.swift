//
//  ColorCircle.swift
//  ColorDial
//
//  Created by Kenneth Allan on 1/12/2015.
//  Copyright © 2015 Kenneth Allan. All rights reserved.
//

import Cocoa

class ColorCircle: NSView {
    var fill: NSColor = NSColor.black
    var bg: NSBezierPath?
    var downInView: Bool = false
    
    var delegate: ColorSupplyDelegate?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        var rect = self.bounds.offsetBy(dx: 1, dy: 1)
        rect.size.width -= 2
        rect.size.height -= 2
        
        bg = NSBezierPath(roundedRect: rect, xRadius: rect.width / 2, yRadius: rect.height / 2)
                
        self.setNeedsDisplay(self.bounds)
    }
    
    func changeShapeToSquare() {
        bg = NSBezierPath(roundedRect: NSRect(x: self.bounds.origin.x + 1, y: self.bounds.origin.y + 1, width: self.bounds.size.width - 2, height: self.bounds.size.height - 2), xRadius: 3, yRadius: 3)
        setNeedsDisplay(self.bounds)
    }
    
    override func mouseDown(with theEvent: NSEvent) {
        downInView = false
        let click = self.convert(theEvent.locationInWindow, from: nil)
        if let bg = self.bg {
            if (bg.contains(click)) {
                downInView = true
            }
        }
    }
    
    override func mouseUp(with theEvent: NSEvent) {
        if (downInView) {
            downInView = false
            let click = self.convert(theEvent.locationInWindow, from: nil)
            if let bg = self.bg {
                if (bg.contains(click)) {
                    if let delegate = self.delegate {
                        delegate.colorSupplied(fill, sender: self)
                    }
                }
            }
        }
    }
    
    override func mouseDragged(with theEvent: NSEvent) {
        NSColorPanel.dragColor(fill, with: theEvent, from: self)
    }
    
    func setColor(_ c: NSColor) {
        fill = c
        self.setNeedsDisplay(self.bounds)
    }
    
    func lighten(_ color: NSColor, n: CGFloat) {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var l: CGFloat = 0
        var a: CGFloat = 0
        color.get(&h, saturation: &s, lightness: &l, alpha: &a)
        
        fill = NSColor.colorWith(h, saturation: s, lightness: clamp(l + n), alpha: a)
        self.setNeedsDisplay(self.bounds)
    }

    func saturate(_ color: NSColor, n: CGFloat) {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var l: CGFloat = 0
        var a: CGFloat = 0
        color.get(&h, saturation: &s, lightness: &l, alpha: &a)
        
        fill = NSColor.colorWith(h, saturation: clamp(s + n), lightness: l, alpha: a)
        self.setNeedsDisplay(self.bounds)
    }
        
    func setHSV(_ h: CGFloat, s: CGFloat, v: CGFloat) {
        fill = NSColor(hue: clamp((h/360).truncatingRemainder(dividingBy: 360)), saturation: clamp(s/100), brightness: clamp(v/100), alpha: 1)
        
        self.setNeedsDisplay(self.bounds)
    }
    
    func clamp(_ value: CGFloat) -> CGFloat {
        if (value >= 1) { return 0.99999 }
        if (value <= 0) { return 0.00001 }
        return value
    }
        
    func mix(_ value: CGFloat, with: CGFloat, factor: CGFloat) -> CGFloat {
        return value*(1-factor) + with*factor
    }
    
    func adjustColor(_ brightness: CGFloat, contrast: CGFloat, saturation: CGFloat) {
        let r = fill.redComponent
        let g = fill.greenComponent
        let b = fill.blueComponent
        
        let br = r * brightness
        let bg = g * brightness
        let bb = b * brightness
        
        let ir = br * 0.2125
        let ig = bg * 0.7154
        let ib = bb * 0.0721
        
        let sr = mix(ir, with: br, factor: saturation)
        let sg = mix(ig, with: bg, factor: saturation)
        let sb = mix(ib, with: bb, factor: saturation)
        
        let cr = mix(0.5, with: sr, factor: contrast)
        let cg = mix(0.5, with: sg, factor: contrast)
        let cb = mix(0.5, with: sb, factor: contrast)
        
        fill = NSColor(red: clamp(cr), green: clamp(cg), blue: clamp(cb), alpha: 1)
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        if let bg = self.bg {
            NSColor.black.setStroke()
            fill.setFill()
            bg.fill()

            NSColor.black.setStroke()
            bg.lineWidth = 2
            bg.stroke()
            
            NSColor.white.setStroke()
            bg.lineWidth = 1.25
            bg.stroke()
        }
    }

}
