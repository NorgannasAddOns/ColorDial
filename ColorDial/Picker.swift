//
//  Picker.swift
//  ColorDial
//
//  Created by Kenneth Allan on 7/12/2015.
//  Copyright © 2015 Kenneth Allan. All rights reserved.
//

import Cocoa

class Picker: NSView {
//    override var opaque: Bool { return true }
//    override var acceptsFirstResponder: Bool { return true }
    let pickerSize: Int = 64
    
    var parent: ViewController!
    var circle: NSBezierPath!
    var image: NSImage!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)!
//        setItemPropertiesToDefault()
    }

    override func awakeFromNib() {
        setItemPropertiesToDefault()
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        if (image != nil) {
            let scaler = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: pickerSize, pixelsHigh: pickerSize, bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: NSDeviceRGBColorSpace, bytesPerRow: 0, bitsPerPixel: 0) as NSBitmapImageRep!
            
            NSGraphicsContext.saveGraphicsState()
            NSGraphicsContext.setCurrentContext(NSGraphicsContext(bitmapImageRep: scaler))
            
            let scaled = NSImage(size: NSSize(width: pickerSize, height: pickerSize))
            
            scaled.lockFocus()
            image.drawInRect(frame, fromRect: NSRect(x: pickerSize/4, y: pickerSize/4, width: pickerSize/2, height: pickerSize/2), operation: NSCompositingOperation.CompositeSourceOver, fraction: 1.0)
            scaled.unlockFocus()
            
            NSColor(patternImage: scaled).setFill()
            circle.fill()
            
            NSGraphicsContext.restoreGraphicsState()
        }
            
        NSColor.blackColor().setStroke()
        circle.lineWidth = 2
        circle.stroke()
        
        NSColor.whiteColor().setStroke()
        circle.lineWidth = 1.25
        circle.stroke()
    }
    
    func timerDidFire(timer: NSTimer!) {
        if (window!.visible) {
            handleMouseMovement()
        }
    }

    func setItemPropertiesToDefault() {
        circle = NSBezierPath(ovalInRect: NSRect(x: 1, y: 1, width: pickerSize - 2, height: pickerSize - 2))
        
        NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: "timerDidFire:", userInfo: nil, repeats: true)

        frame = NSRect(x: 0, y: 0, width: pickerSize, height: pickerSize)

        let t = NSTrackingArea(
            rect: frame,
            options: [
                NSTrackingAreaOptions.ActiveAlways,
//                NSTrackingAreaOptions.InVisibleRect,
                NSTrackingAreaOptions.MouseEnteredAndExited,
                NSTrackingAreaOptions.MouseMoved
            ],
            owner: self,
            userInfo: nil
        )
        self.addTrackingArea(t)
        
        setNeedsDisplayInRect(frame)
    }
    
    var downInView: Bool = false

    func handleMouseMovement() {
        let m = NSEvent.mouseLocation()
        
        let nx = Int(m.x) - pickerSize/2
        let ny = Int(m.y) - pickerSize/2
        
        if (nx != Int(window!.frame.origin.x) || ny != Int(window!.frame.origin.y)) {
            window!.setFrame(NSRect(
                x: nx,
                y: ny,
                width: pickerSize,
                height: pickerSize),
                display: true,
                animate: false
            )
            
            let s = window!.convertRectToScreen(NSRect(origin: m, size: frame.size))
            
            let cgimage = CGWindowListCreateImage(s, CGWindowListOption.OptionOnScreenBelowWindow, CGWindowID(window!.windowNumber), CGWindowImageOption.BestResolution)
            
            image = NSImage(CGImage: cgimage!, size: frame.size)
            if let b: NSButton = parent.eyeDropper as NSButton {
                b.image = image
            }
            setNeedsDisplayInRect(frame)
        }
    }

    override func mouseMoved(theEvent: NSEvent) {
        handleMouseMovement()
    }
    
    override func mouseExited(theEvent: NSEvent) {
        handleMouseMovement()
    }
    
    override func mouseDown(theEvent: NSEvent) {
        downInView = false
        let click = self.convertPoint(theEvent.locationInWindow, fromView: nil)
        if (circle.containsPoint(click)) {
            downInView = true
        }
    }
    
    override func mouseUp(theEvent: NSEvent) {
        if (downInView) {
            downInView = false
            
            let click = self.convertPoint(theEvent.locationInWindow, fromView: nil)
            if (circle.containsPoint(click)) {
                NSCursor.unhide()
                window!.orderOut(window!)
            }
        }
    }
}
