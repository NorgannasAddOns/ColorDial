//
//  Picker.swift
//  ColorDial
//
//  Created by Kenneth Allan on 7/12/2015.
//  Copyright © 2015 Kenneth Allan. All rights reserved.
//

import Cocoa

class Picker: NSView {
    let pickerSize: CGFloat = 99.0
    let zoom: CGFloat = 10.0
    
    var parent: ViewController!
    var circle: NSBezierPath!
    var image: NSImage!
    var centerColor: NSColor!
    var picking: Bool = false

    var delegate: ColorSupplyDelegate?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)!
    }

    override func awakeFromNib() {
        setItemPropertiesToDefault()
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        var scaled: NSImage = image
        
        let half = pickerSize / 2.0
        let inset = pickerSize / zoom / 2.0
        
        if (image != nil) {
            let scaler = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: Int(pickerSize), pixelsHigh: Int(pickerSize), bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: NSDeviceRGBColorSpace, bytesPerRow: 0, bitsPerPixel: 0) as NSBitmapImageRep!
            
            NSGraphicsContext.saveGraphicsState()
            NSGraphicsContext.setCurrentContext(NSGraphicsContext(bitmapImageRep: scaler))
            NSGraphicsContext.currentContext()?.imageInterpolation = .None
            
            scaled = NSImage(size: NSSize(width: pickerSize, height: pickerSize))
            
            scaled.lockFocus()
            image.drawInRect(frame, fromRect: NSRect(x: half - inset, y: half - inset, width: inset * 2.0, height: inset * 2.0), operation: NSCompositingOperation.CompositeSourceOver, fraction: 1.0)
            scaled.unlockFocus()
            
            NSGraphicsContext.restoreGraphicsState()
        }
        
        NSColor(patternImage: scaled).setFill()
        circle.fill()
        
        NSColor.blackColor().setStroke()
        circle.lineWidth = 2
        circle.stroke()
        
        NSColor.whiteColor().setStroke()
        circle.lineWidth = 1.25
        circle.stroke()

        circle.lineWidth = 1
        NSColor.gridColor().setStroke()
        
        circle.moveToPoint(NSPoint(x: 2,              y: half))
        circle.lineToPoint(NSPoint(x: pickerSize - 2, y: half))
        
        circle.moveToPoint(NSPoint(x: half,           y: 2))
        circle.lineToPoint(NSPoint(x: half,           y: pickerSize - 2))
        
    }
    
    func timerDidFire(timer: NSTimer!) {
        if (window!.visible) {
            handleMouseMovement()
        }
    }

    func setItemPropertiesToDefault() {
        circle = NSBezierPath(ovalInRect: NSRect(x: 1, y: 1, width: pickerSize - 2, height: pickerSize - 2))
        
        NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "timerDidFire:", userInfo: nil, repeats: true)

        frame = NSRect(x: 0, y: 0, width: pickerSize, height: pickerSize)

        let t = NSTrackingArea(
            rect: frame,
            options: [
                NSTrackingAreaOptions.ActiveAlways,
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

    var lastColor: NSColor!
    func handleMouseMovement() {
        if (!picking) { return }

        let m = NSEvent.mouseLocation()
        
        let half = pickerSize / 2.0
        let nx = m.x - half
        let ny = m.y - half
        
        window!.setFrame(NSRect(
            x: nx,
            y: ny,
            width: pickerSize,
            height: pickerSize),
            display: true,
            animate: false
        )
        
        let carbonPoint = carbonScreenPointFromCocoaScreenPoint(NSPoint(x: m.x, y: m.y))
        let s = NSRect(
            origin: NSPoint(x: carbonPoint.x - half, y: carbonPoint.y - half),
            size: frame.size
        )
        
        let cgimage = CGWindowListCreateImage(s, CGWindowListOption.OptionOnScreenBelowWindow, CGWindowID(window!.windowNumber), CGWindowImageOption.BestResolution)
        
        let rep = NSBitmapImageRep(CGImage: cgimage!)
        centerColor = rep.colorAtX(Int(CGFloat(rep.size.width) / 2)-1, y: Int(CGFloat(rep.size.height) / 2)-1)
        
        if let delegate = self.delegate {
            if (!centerColor.isEqualTo(lastColor)) {
                delegate.colorSampled(centerColor)
                lastColor = centerColor
            }
        }

        image = NSImage(CGImage: cgimage!, size: frame.size)
        setNeedsDisplayInRect(frame)
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
                picking = false
                if let delegate = self.delegate {
                    delegate.colorSupplied(centerColor, sender: nil)
                }
            }
        }
    }
    
    func beginPicking() {
        if (picking) { return }
        picking = true
        window?.makeKeyAndOrderFront(window!)
        becomeFirstResponder()
        handleMouseMovement()
        NSCursor.hide()
    }
    
    func carbonScreenPointFromCocoaScreenPoint(cocoaPoint: NSPoint) -> NSPoint {
        for screen in NSScreen.screens()! {
            let sr = NSRect(x: screen.frame.origin.x, y: screen.frame.origin.y - 1, width: screen.frame.size.width, height: screen.frame.size.height + 2)
            if NSPointInRect(cocoaPoint, sr) {
                let screenHeight = screen.frame.size.height
                return NSPoint(x: cocoaPoint.x, y: screenHeight - cocoaPoint.y - 1)
            }
        }
        return NSPoint(x: 0, y: 0)
    }
    
}
