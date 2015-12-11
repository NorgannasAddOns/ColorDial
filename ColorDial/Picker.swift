//
//  Picker.swift
//  ColorDial
//
//  Created by Kenneth Allan on 7/12/2015.
//  Copyright © 2015 Kenneth Allan. All rights reserved.
//

import Cocoa

class Picker: NSView {
    let pickerSize: CGFloat = 149.0 // Must be odd number
    let blockSize: Int = 11 // Must be odd number
    
    var parent: ViewController!
    var circle: NSBezierPath!
    var image: CGImage!
    var imageRep: NSBitmapImageRep!
    var centerColor: NSColor!
    var pixels: [PixelData]!
    var picking: Bool = false
    var scaleFactor: CGFloat = 0.0

    var delegate: ColorSupplyDelegate?

    /**
     * Courtesy HumanFriendly:
     * http://blog.human-friendly.com/drawing-images-from-pixel-data-in-swift
     * Modified to work with Swift 2 and NSImage
     *
     * {{{
     */
    internal struct PixelData {
        var a:UInt8 = 255
        var r:UInt8 = 0
        var g:UInt8 = 0
        var b:UInt8 = 0
    }
    
    private let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
    private let bitmapInfo:CGBitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedFirst.rawValue)
    
    internal func imageFromARGB32Bitmap(pixels: [PixelData], width: Int, height: Int)->NSImage {
        let bitsPerComponent: Int = 8
        let bitsPerPixel: Int = 32
        
        assert(pixels.count == Int(width * height))
        
        var data = pixels // Copy to mutable []
        let providerRef = CGDataProviderCreateWithCFData(
            NSData(bytes: &data, length: data.count * sizeof(PixelData))
        )
        
        let cgimage = CGImageCreate(
            width,
            height,
            bitsPerComponent,
            bitsPerPixel,
            width * Int(sizeof(PixelData)),
            rgbColorSpace,
            bitmapInfo,
            providerRef,
            nil,
            true,
            CGColorRenderingIntent.RenderingIntentDefault
        )
        return NSImage(CGImage: cgimage!, size: NSSize(width: width, height: height))
    }
    // }}}
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)!
    }

    override func awakeFromNib() {
        setItemPropertiesToDefault()
    }
    
    /**
     * Draws a block of blockSize x blockSize around the pixel at x, y.
     */
    func drawBlock(x: Int, y: Int, c: NSColor, blockSize: Int) {
        let r = UInt8(c.redComponent * 255)
        let g = UInt8(c.greenComponent * 255)
        let b = UInt8(c.blueComponent * 255)

        let offs = Int(floor(CGFloat(blockSize) / 2))
        let size = Int(pickerSize)
        
        for (var p = -offs; p <= offs; p++) {
            for (var q = -offs; q <= offs; q++) {
                let bx = x + p;
                let by = y + q;
                
                if (bx < 0 || by < 0) { continue }
                if (bx >= size || by >= size) { continue }
                
                let pos = by * size + bx
                pixels[pos].r = r
                pixels[pos].g = g
                pixels[pos].b = b
            }
        }
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        if (image == nil) { return }

        objc_sync_enter(self);
        
        let cmid = Int(round(imageRep.size.width/2))
        let half = Int(round(pickerSize / 2))
        let limit = Int(ceil(pickerSize / CGFloat(blockSize)))
        let mid = Int(floor(CGFloat(limit) / 2))
        let offs = Int(floor(CGFloat(blockSize) / 2))
        
        for (var x = -mid; x < mid; x++) {
            for (var y = -mid; y < mid; y++) {
                let c = imageRep.colorAtX(cmid + x + offsX, y: cmid + y + offsY)!
                
                if (x == 0 && y == 0) {
                    centerColor = c
                    continue
                }
                
                drawBlock(
                    half + blockSize * x, // + (x<0 ? offs : -offs),
                    y: half + blockSize * y, // + (y<0 ? offs : -offs),
                    c: c,
                    blockSize: blockSize
                )
            }
        }
        objc_sync_exit(self);

        drawBlock(
            half,
            y: half,
            c: centerColor,
            blockSize: blockSize + offs
        )

        if let delegate = self.delegate {
            if (!centerColor.isEqualTo(lastColor)) {
                delegate.colorSampled(centerColor)
                lastColor = centerColor
            }
        }

        
        let scaled = imageFromARGB32Bitmap(pixels, width: Int(pickerSize), height: Int(pickerSize))
        //parent.eyeDropper.image = scaled
        
        NSColor(patternImage: scaled).setFill()
        circle.fill()
        
        NSColor.blackColor().setStroke()
        circle.lineWidth = 2
        circle.stroke()
        
        NSColor.whiteColor().setStroke()
        circle.lineWidth = 1
        circle.stroke()

        
        circle.moveToPoint(NSPoint(x: 2,                    y: half))
        circle.lineToPoint(NSPoint(x: half - offs,             y: half))

        circle.moveToPoint(NSPoint(x: Int(pickerSize) - 2,  y: half))
        circle.lineToPoint(NSPoint(x: half + offs,             y: half))
        
        circle.moveToPoint(NSPoint(x: half,                 y: 2))
        circle.lineToPoint(NSPoint(x: half,                 y: half - offs))
        
        circle.moveToPoint(NSPoint(x: half,                 y: Int(pickerSize) - 2))
        circle.lineToPoint(NSPoint(x: half,                 y: half + offs))
        
    }
    
    func timerDidFire(timer: NSTimer!) {
        if (window!.visible) {
            handleMouseMovement()
        }
    }
    
    func changeShapeToSquare() {
        circle = NSBezierPath(roundedRect: NSRect(x:1, y:1, width: pickerSize - 2, height: pickerSize - 2), xRadius: 5, yRadius: 5)
        setNeedsDisplayInRect(self.bounds)
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
        
        pixels = [PixelData](count: Int(pickerSize * pickerSize), repeatedValue: PixelData())

        setNeedsDisplayInRect(frame)
    }
    
    var downInView: Bool = false

    var lastColor: NSColor!
    
    var lastX: CGFloat = 0
    var lastY: CGFloat = 0
    var offsX: Int = 0
    var offsY: Int = 0
    
    func handleMouseMovement() {
        if (!picking) {
            return
        }

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

        let limit = Int(ceil(pickerSize / CGFloat(blockSize)))
        let halflimit = limit / 2
        let carbonPoint = carbonScreenPointFromCocoaScreenPoint(NSPoint(x: m.x, y: m.y))
        let s = NSRect(x: Int(carbonPoint.x) - halflimit, y: Int(carbonPoint.y) - halflimit, width: limit, height: limit)

        if scaleFactor == 2.0 {
            if m.x > lastX {
                offsX = 0
            } else if m.x < lastX {
                offsX = 1
            }
            if m.y > lastY {
                offsY = 1
            } else if m.y < lastY {
                offsY = 0
            }
        } else {
            offsX = 0
            offsY = 0
        }
        lastX = m.x
        lastY = m.y
        
        image = CGWindowListCreateImage(s, CGWindowListOption.OptionOnScreenBelowWindow, CGWindowID(window!.windowNumber), CGWindowImageOption.BestResolution)
        
        objc_sync_enter(self);
        imageRep = NSBitmapImageRep(CGImage: image!)
        objc_sync_exit(self);
        
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

    func closePicker() {
        NSCursor.unhide()
        window!.orderOut(window!)
        picking = false
    }
    
    override func mouseUp(theEvent: NSEvent) {
        if (downInView) {
            downInView = false
            
            let click = self.convertPoint(theEvent.locationInWindow, fromView: nil)
            if (circle.containsPoint(click)) {
                if !theEvent.modifierFlags.contains(NSEventModifierFlags.CommandKeyMask) {
                    closePicker();
                }
                
                if let delegate = self.delegate {
                    delegate.colorSupplied(centerColor, sender: nil)
                }
            }
        }
    }
    
    func carbonScreenPointFromCocoaScreenPoint(cocoaPoint: NSPoint) -> NSPoint {
        //debugPrint("Convert")
        for screen in NSScreen.screens()! {
            /*debugPrint(
                String(format: "Test if %0.1f, %0.1f inside  %0.1f, %0.1f @ %0.1f x %0.1f",
                    cocoaPoint.x, cocoaPoint.y,
                    screen.frame.origin.x, screen.frame.origin.y, screen.frame.size.width, screen.frame.size.height
                )
            )*/
            let sr = NSRect(x: screen.frame.origin.x, y: screen.frame.origin.y - 1, width: screen.frame.size.width, height: screen.frame.size.height + 2)
            if NSPointInRect(cocoaPoint, sr) {
                let screenHeight = screen.frame.size.height
                let convertY = screenHeight + screen.frame.origin.y - cocoaPoint.y - 1
                //debugPrint(String(format: "  Converting y to %0.1f + %0.1f - %0.1f - 1 = %0.1f", screenHeight, screen.frame.origin.y, cocoaPoint.y, convertY))
                scaleFactor = screen.backingScaleFactor
                return NSPoint(x: cocoaPoint.x, y: convertY)
            }
        }
        return NSPoint(x: 0, y: 0)
    }
    
}
