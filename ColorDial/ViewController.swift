//
//  ViewController.swift
//  ColorDial
//
//  Created by Kenneth Allan on 30/11/2015.
//  Copyright © 2015 Kenneth Allan. All rights reserved.
//

import Cocoa

extension String {
    func hexNibbleAt(i: Int) -> Int {
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
    
    func hexByteAt(i: Int) -> Int {
        return hexNibbleAt(i) * 16 + hexNibbleAt(i+1)
    }
    
    subscript (i: Int) -> Character {
        return self[self.startIndex.advancedBy(i)]
    }
    
    subscript (r: Range<Int>) -> String {
        return substringWithRange(Range(start: startIndex.advancedBy(r.startIndex), end: startIndex.advancedBy(r.endIndex)))
    }
}

class ViewController: NSViewController, ColorCircleDelegate, NSTextFieldDelegate {
    var rValue: Int = 0
    var gValue: Int = 0
    var bValue: Int = 0
    var hValue: Int = 0
    var sValue: Int = 0
    var vValue: Int = 0
    
    var color: NSColor = NSColor(red: 0, green: 0, blue: 0, alpha: 0)
    
    var pickerWin: NSWindow!
    var picker: Picker!
    
    @IBOutlet weak var colorWell: NSColorWell!
    
    @IBOutlet weak var rSlider: NSSlider!
    @IBOutlet weak var gSlider: NSSlider!
    @IBOutlet weak var bSlider: NSSlider!
    @IBOutlet weak var hSlider: NSSlider!
    @IBOutlet weak var sSlider: NSSlider!
    @IBOutlet weak var vSlider: NSSlider!

    @IBOutlet weak var rText: NSTextField!
    @IBOutlet weak var gText: NSTextField!
    @IBOutlet weak var bText: NSTextField!
    @IBOutlet weak var hText: NSTextField!
    @IBOutlet weak var sText: NSTextField!
    @IBOutlet weak var vText: NSTextField!
    
    @IBOutlet weak var rStepper: NSStepper!
    @IBOutlet weak var gStepper: NSStepper!
    @IBOutlet weak var bStepper: NSStepper!
    @IBOutlet weak var hStepper: NSStepper!
    @IBOutlet weak var sStepper: NSStepper!
    @IBOutlet weak var vStepper: NSStepper!
    
    @IBOutlet weak var rSliderCell: ColorSlider!
    @IBOutlet weak var gSliderCell: ColorSlider!
    @IBOutlet weak var bSliderCell: ColorSlider!
    @IBOutlet weak var hSliderCell: ColorSlider!
    @IBOutlet weak var sSliderCell: ColorSlider!
    @IBOutlet weak var vSliderCell: ColorSlider!
    
    @IBOutlet weak var cc0: ColorCircle!
    @IBOutlet weak var cc30: ColorCircle!
    @IBOutlet weak var cc60: ColorCircle!
    @IBOutlet weak var cc90: ColorCircle!
    @IBOutlet weak var cc120: ColorCircle!
    @IBOutlet weak var cc150: ColorCircle!
    @IBOutlet weak var cc180: ColorCircle!
    @IBOutlet weak var cc210: ColorCircle!
    @IBOutlet weak var cc240: ColorCircle!
    @IBOutlet weak var cc270: ColorCircle!
    @IBOutlet weak var cc300: ColorCircle!
    @IBOutlet weak var cc330: ColorCircle!
    @IBOutlet weak var ccPlus: ColorCircle!
    @IBOutlet weak var ccMinus: ColorCircle!
    @IBOutlet weak var ccDown: ColorCircle!
    @IBOutlet weak var ccUp: ColorCircle!
    
    @IBOutlet weak var hexText: NSTextField!
    @IBOutlet weak var rgbText: NSTextField!
    @IBOutlet weak var hslText: NSTextField!

    @IBOutlet weak var eyeDropper: NSButton!
    
    func flashPress(item: NSView) {
        NSAnimationContext.currentContext().duration = 1.2;
        item.alphaValue = 0.3
        item.animator().alphaValue = 1
    }
    
    @IBAction func eyeDropper(sender: NSButton) {
        flashPress(sender)
        
        let p = NSReadPixel(NSPoint(x: 100,y: 100))
        print(p)
        
        pickerWin.makeKeyAndOrderFront(pickerWin)
        picker.handleMouseMovement()
        picker.becomeFirstResponder()
        //NSCursor.hide()
    }
    
    @IBAction func hexCopy(sender: NSButton) {
        flashPress(sender)
        let pb = NSPasteboard.generalPasteboard()
        pb.clearContents()
        pb.writeObjects([hexText.stringValue])
    }
    
    @IBAction func rgbCopy(sender: NSButton) {
        flashPress(sender)
        let pb = NSPasteboard.generalPasteboard()
        pb.clearContents()
        pb.writeObjects([rgbText.stringValue])
    }
    
    @IBAction func hslCopy(sender: NSButton) {
        flashPress(sender)
        let pb = NSPasteboard.generalPasteboard()
        pb.clearContents()
        pb.writeObjects([hslText.stringValue])
    }
    
    @IBAction func colorUpdated(sender: AnyObject) {
        if let cw = sender as? NSColorWell {
            color = cw.color
            setFromColor()
        }
    }
    
    var editingTextType: String = ""
    
    var hexPattern: Regex = Regex("^#?([\\da-z]{3}|[\\da-z]{6,})$")
    
    override func controlTextDidChange(obj: NSNotification) {
        if let field = obj.object as? NSTextField {
            inputUpdated(field)
            switch (field) {
            case hexText:
                editingTextType = "hexText"
                break
            case rgbText:
                editingTextType = "rgbText"
                break
            case hslText:
                editingTextType = "hslText"
                break
            default:
                editingTextType = ""
                break
            }
        }
    }
    
    override func controlTextDidEndEditing(obj: NSNotification) {
        editingTextType = ""
    }
    
    override func doCommandBySelector(aSelector: Selector) {
        print(aSelector)
    }
    
    @IBAction func inputUpdated(sender: NSTextField) {
        switch (sender) {
        case rText:
            rSlider.integerValue = rText.integerValue
            sliderUpdated(rSlider)
            break
        case gText:
            gSlider.integerValue = gText.integerValue
            sliderUpdated(gSlider)
            break
        case bText:
            bSlider.integerValue = bText.integerValue
            sliderUpdated(bSlider)
            break
        case hText:
            hSlider.integerValue = hText.integerValue
            sliderUpdated(hSlider)
            break
        case sText:
            sSlider.integerValue = sText.integerValue
            sliderUpdated(sSlider)
            break
        case vText:
            vSlider.integerValue = vText.integerValue
            sliderUpdated(vSlider)
            break
        case hexText:
            let value = sender.stringValue
            let matches = hexPattern.match(value)
            
            if matches.count > 0 {
                let nsrange = matches[0].rangeAtIndex(1)
                let range = value.rangeFromNSRange(nsrange)
                let code = value.substringWithRange(range!)
                
                if (code.characters.count == 3) {
                    rValue = code.hexNibbleAt(0) * 17
                    gValue = code.hexNibbleAt(1) * 17
                    bValue = code.hexNibbleAt(2) * 17
                    updateSliders(true)
                }
                if (code.characters.count >= 6) {
                    rValue = code.hexByteAt(0)
                    gValue = code.hexByteAt(2)
                    bValue = code.hexByteAt(4)
                    updateSliders(true)
                }
            }
            break
        default:
            break
        }
    }
    
    @IBAction func stepperUpdated(sender: NSStepper) {
        editingTextType = ""
        switch (sender) {
        case rStepper:
            rSlider.integerValue = rStepper.integerValue
            sliderUpdated(rSlider)
            break
        case gStepper:
            gSlider.integerValue = gStepper.integerValue
            sliderUpdated(gSlider)
            break
        case bStepper:
            bSlider.integerValue = bStepper.integerValue
            sliderUpdated(bSlider)
            break
        case hStepper:
            hSlider.integerValue = hStepper.integerValue
            sliderUpdated(hSlider)
            break
        case sStepper:
            sSlider.integerValue = sStepper.integerValue
            sliderUpdated(sSlider)
            break
        case vStepper:
            vSlider.integerValue = vStepper.integerValue
            sliderUpdated(vSlider)
            break
        default:
            break
        }
    }
    
    @IBAction func sliderUpdated(sender: NSSlider) {
        editingTextType = ""

        var isRGB: Bool = true;
        switch (sender) {
        case rSlider:
            rValue = clampTo(rSlider.integerValue)
            break
        case gSlider:
            gValue = clampTo(gSlider.integerValue)
            break
        case bSlider:
            bValue = clampTo(bSlider.integerValue)
            break
        case hSlider:
            hValue = clampTo(hSlider.integerValue, max: 359)
            isRGB = false
            break
        case sSlider:
            sValue = clampTo(sSlider.integerValue, max: 100)
            isRGB = false
            break
        case vSlider:
            vValue = clampTo(vSlider.integerValue, max: 100)
            isRGB = false
            break
        default:
            break
        }
        
        updateSliders(isRGB)
    }
    
    func updateSliders(isRGB: Bool) {
        if (isRGB) {
            color = NSColor(red: CGFloat(rValue)/255, green: CGFloat(gValue)/255, blue: CGFloat(bValue)/255, alpha: 1.0)
            hValue = clampFloatTo(color.hueComponent * 360, max: 359)
            sValue = clampFloatTo(color.saturationComponent * 100, max: 100)
            vValue = clampFloatTo(color.brightnessComponent * 100, max: 100)
        } else {
            color = NSColor(hue: CGFloat(hValue)/360, saturation: CGFloat(sValue)/100, brightness: CGFloat(vValue)/100, alpha: 1.0)
            rValue = clampFloatTo(color.redComponent * 255)
            gValue = clampFloatTo(color.greenComponent * 255)
            bValue = clampFloatTo(color.blueComponent * 255)
        }
        
        setSliders()
    }
    
    @IBAction func colorClicked(sender: ColorCircle) {
        flashPress(sender)
        editingTextType = ""
        color = sender.fill
        setFromColor()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        color = colorWell.color
        
        cc0.delegate = self
        cc30.delegate = self
        cc60.delegate = self
        cc90.delegate = self
        cc120.delegate = self
        cc150.delegate = self
        cc180.delegate = self
        cc210.delegate = self
        cc240.delegate = self
        cc270.delegate = self
        cc300.delegate = self
        cc330.delegate = self
        ccUp.delegate = self
        ccDown.delegate = self
        ccPlus.delegate = self
        ccMinus.delegate = self
        
        rText.delegate = self
        gText.delegate = self
        bText.delegate = self
        hText.delegate = self
        sText.delegate = self
        vText.delegate = self

        hexText.delegate = self
        rgbText.delegate = self
        hslText.delegate = self

        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = NSNib(nibNamed: "Picker", bundle: bundle)
        var topLevelObjects: NSArray?
        nib?.instantiateWithOwner(pickerWin, topLevelObjects: &topLevelObjects)
        for object: AnyObject in topLevelObjects! {
            if let obj = object as? Picker {
                self.picker = obj
            }
        }
        picker.parent = self

        pickerWin = NSWindow(contentRect: NSRect(x: 0, y: 0, width: picker.pickerSize, height: picker.pickerSize), styleMask: NSBorderlessWindowMask, backing: NSBackingStoreType.Buffered, `defer`: true)
        
        pickerWin.backgroundColor = NSColor.clearColor()
        pickerWin.level = Int(CGWindowLevelForKey(.MaximumWindowLevelKey))
        pickerWin.contentView?.addSubview(picker)

        setFromColor()
    }
    
    override func viewDidDisappear() {
        exit(EXIT_SUCCESS)
    }
    
    func setFromColor() {
        hValue = clampFloatTo(color.hueComponent * 360, max: 359)
        sValue = clampFloatTo(color.saturationComponent * 100, max: 100)
        vValue = clampFloatTo(color.brightnessComponent * 100, max: 100)
        rValue = clampFloatTo(color.redComponent * 255)
        gValue = clampFloatTo(color.greenComponent * 255)
        bValue = clampFloatTo(color.blueComponent * 255)
        setSliders()
    }
    
    func clampFloatTo (value: CGFloat, max: Int = 255, min: Int = 0) -> Int {
        return clampTo(Int(value), max: max, min: min)
    }
    
    func clampTo (value: Int, max: Int = 255, min: Int = 0) -> Int {
        if (value < min) { return min; }
        if (value > max) { return max; }
        return value
    }
    
    func setSliders() {
        let rInt = clampTo(rValue)
        let gInt = clampTo(gValue)
        let bInt = clampTo(bValue)
        let hInt = clampTo(hValue, max: 359)
        let sInt = clampTo(sValue, max: 100)
        let vInt = clampTo(vValue, max: 100)
        
        rText.integerValue = rInt
        gText.integerValue = gInt
        bText.integerValue = bInt
        hText.integerValue = hInt
        sText.integerValue = sInt
        vText.integerValue = vInt

        rStepper.integerValue = rInt
        gStepper.integerValue = gInt
        bStepper.integerValue = bInt
        hStepper.integerValue = hInt
        sStepper.integerValue = sInt
        vStepper.integerValue = vInt

        rSlider.integerValue = rInt
        gSlider.integerValue = gInt
        bSlider.integerValue = bInt
        hSlider.integerValue = hInt
        sSlider.integerValue = sInt
        vSlider.integerValue = vInt
        
        colorWell.color = color
        
        rSliderCell.setColors(0, g1: gValue, b1: bValue, r2: 255, g2: gValue, b2: bValue)
        gSliderCell.setColors(rValue, g1: 0, b1: bValue, r2: rValue, g2: 255, b2: bValue)
        bSliderCell.setColors(rValue, g1: gValue, b1: 0, r2: rValue, g2: gValue, b2: 255)
        hSliderCell.setHue(sValue, v: vValue)
        sSliderCell.setSaturation(hValue, v: vValue)
        vSliderCell.setBrightness(hValue, s: sValue)
        
        rSlider.setNeedsDisplay()
        gSlider.setNeedsDisplay()
        bSlider.setNeedsDisplay()
        hSlider.setNeedsDisplay()
        sSlider.setNeedsDisplay()
        vSlider.setNeedsDisplay()
        
        if (editingTextType != "hexText") {
            hexText.stringValue = String(format: "#%02x%02x%02x", rInt, gInt, bInt)
        }
        
        if (editingTextType != "rgbText") {
            rgbText.stringValue = String(format: "rgb(%d, %d, %d)", rInt, gInt, bInt)
        }
        
        if (editingTextType != "hslText") {
            hslText.stringValue = String(format: "hsl(%d, %d%%, %d%%)", hInt, sInt, vInt)
        }
        
        
        cc0.setHSV(hValue, s: sValue, v: vValue)
        cc30.setHSV((hValue + 30)%360, s: sValue, v: vValue)
        cc60.setHSV((hValue + 60)%360, s: sValue, v: vValue)
        cc90.setHSV((hValue + 90)%360, s: sValue, v: vValue)
        cc120.setHSV((hValue + 120)%360, s: sValue, v: vValue)
        cc150.setHSV((hValue + 150)%360, s: sValue, v: vValue)
        cc180.setHSV((hValue + 180)%360, s: sValue, v: vValue)
        cc210.setHSV((hValue + 210)%360, s: sValue, v: vValue)
        cc240.setHSV((hValue + 240)%360, s: sValue, v: vValue)
        cc270.setHSV((hValue + 270)%360, s: sValue, v: vValue)
        cc300.setHSV((hValue + 300)%360, s: sValue, v: vValue)
        cc330.setHSV((hValue + 330)%360, s: sValue, v: vValue)

/*
        ccUp.setHSV(hValue, s: sValue, v: vValue + 10)
        ccDown.setHSV(hValue, s: sValue, v: vValue - 10)
        
        ccPlus.setHSV(hValue, s: sValue, v: vValue)
        ccPlus.saturate(0.2)
        
        ccMinus.setHSV(hValue, s: sValue, v: vValue)
        ccMinus.desaturate(0.2)
*/
        
//*
        ccUp.setHSV(hValue, s: sValue, v: vValue + 20)
        ccDown.setHSV(hValue, s: sValue, v: vValue - 20)
        ccPlus.setHSV(hValue, s: sValue + 20, v: vValue)
        ccMinus.setHSV(hValue, s: sValue - 20, v: vValue)
        
        if (vValue == 100) { ccUp.hidden = true; } else if (ccUp.hidden) { ccUp.hidden = false; }
        if (sValue == 100) { ccPlus.hidden = true; } else if (ccPlus.hidden) { ccPlus.hidden = false; }
        if (vValue == 0) { ccDown.hidden = true; } else if (ccDown.hidden) { ccDown.hidden = false; }
        if (sValue == 0) { ccMinus.hidden = true; } else if (ccMinus.hidden) { ccMinus.hidden = false; }
        

/*
        ccUp.setHSV(hValue, s: sValue + 10, v: vValue)
        ccDown.setHSV(hValue, s: sValue - 10, v: vValue)
        ccPlus.setHSV(hValue, s: sValue, v: vValue + 10)
        ccMinus.setHSV(hValue, s: sValue, v: vValue - 10)
        
/ *
        ccPlus.setHSV(hValue, s: sValue, v: vValue)
        ccPlus.adjustColor(1, contrast: 1, saturation: 1.1)
        ccMinus.setHSV(hValue, s: sValue, v: vValue)
        ccMinus.desaturate(0.1)
*/
        
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

