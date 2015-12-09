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


protocol ColorSupplyDelegate {
    func colorSupplied(supply: NSColor, sender: NSView?)
    func colorSampled(sample: NSColor)
}

class ViewController: NSViewController, ColorSupplyDelegate, NSTextFieldDelegate {
    var rValue: Int {
        get { return Int(round(rFloat * 255)) }
        set { rFloat = clamp(CGFloat(newValue) / 255) }
    }
    var gValue: Int {
        get { return Int(round(gFloat * 255)) }
        set { gFloat = clamp(CGFloat(newValue) / 255) }
    }
    var bValue: Int {
        get { return Int(round(bFloat * 255)) }
        set { bFloat = clamp(CGFloat(newValue) / 255) }
    }
    var hValue: Int {
        get { return Int(round(hFloat * 360)) }
        set { hFloat = clamp(CGFloat(newValue) / 360) }
    }
    var sValue: Int {
        get { return Int(round(sFloat * 100)) }
        set { sFloat = clamp(CGFloat(newValue) / 100) }
    }
    var lValue: Int {
        get { return Int(round(lFloat * 100)) }
        set { lFloat = clamp(CGFloat(newValue) / 100) }
    }
    
    var rFloat: CGFloat = 0
    var gFloat: CGFloat = 0
    var bFloat: CGFloat = 0
    var hFloat: CGFloat = 0
    var sFloat: CGFloat = 0
    var lFloat: CGFloat = 0
    
    var color: NSColor = NSColor(red: 0, green: 0, blue: 0, alpha: 0)
    var lockedColor: NSColor = NSColor(red: 0, green: 0, blue: 0, alpha: 0)
    var textBgColor: NSColor!
    var pickerWin: NSWindow!
    var picker: Picker!
    var harmony = "analogous"
    
    @IBOutlet weak var colorWell: NSColorWell!
    
    @IBOutlet weak var rSlider: NSSlider!
    @IBOutlet weak var gSlider: NSSlider!
    @IBOutlet weak var bSlider: NSSlider!
    @IBOutlet weak var hSlider: NSSlider!
    @IBOutlet weak var sSlider: NSSlider!
    @IBOutlet weak var lSlider: NSSlider!

    @IBOutlet weak var rText: NSTextField!
    @IBOutlet weak var gText: NSTextField!
    @IBOutlet weak var bText: NSTextField!
    @IBOutlet weak var hText: NSTextField!
    @IBOutlet weak var sText: NSTextField!
    @IBOutlet weak var lText: NSTextField!
    
    @IBOutlet weak var rStepper: NSStepper!
    @IBOutlet weak var gStepper: NSStepper!
    @IBOutlet weak var bStepper: NSStepper!
    @IBOutlet weak var hStepper: NSStepper!
    @IBOutlet weak var sStepper: NSStepper!
    @IBOutlet weak var lStepper: NSStepper!
    
    @IBOutlet weak var rSliderCell: ColorSlider!
    @IBOutlet weak var gSliderCell: ColorSlider!
    @IBOutlet weak var bSliderCell: ColorSlider!
    @IBOutlet weak var hSliderCell: ColorSlider!
    @IBOutlet weak var sSliderCell: ColorSlider!
    @IBOutlet weak var lSliderCell: ColorSlider!
    
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

    @IBOutlet weak var cc1: ColorCircle!
    @IBOutlet weak var cc2: ColorCircle!
    @IBOutlet weak var cc3: ColorCircle!
    @IBOutlet weak var cc4: ColorCircle!
    @IBOutlet weak var cc5: ColorCircle!
    
    @IBOutlet weak var hexText: NSTextField!
    @IBOutlet weak var rgbText: NSTextField!
    @IBOutlet weak var hslText: NSTextField!
    
    @IBOutlet weak var eyeDropper: NSButton!
    
    @IBOutlet weak var analogousHarmony: NSButton!
    @IBOutlet weak var compoundHarmony: NSButton!
    @IBOutlet weak var triadicHarmony: NSButton!
    @IBOutlet weak var complementaryHarmony: NSButton!
    @IBOutlet weak var shadesHarmony: NSButton!
    @IBOutlet weak var monochromaticHarmony: NSButton!
    
    @IBOutlet weak var lockButton: NSButton!
    
    func flashPress(item: NSView) {
        NSAnimationContext.currentContext().duration = 1.2;
        item.alphaValue = 0.3
        item.animator().alphaValue = 1
    }
    
    @IBAction func eyeDropper(sender: NSButton) {
        flashPress(sender)
        //picker.beginPicking()
        picker.picking = true
        pickerWin.makeKeyAndOrderFront(pickerWin)
        NSCursor.hide()
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
    
    @IBAction func lockPressed(sender: NSButton) {
        if sender.state == 0 {
            lockedColor = color
            setSliders()
        }
    }
    @IBAction func harmonyPressed(sender: NSButton) {
        flashPress(sender)

        switch sender {
        case complementaryHarmony:
            harmony = "complementary"
            break
        case monochromaticHarmony:
            harmony = "monochromatic"
            break
        case analogousHarmony:
            harmony = "analogous"
            break
        case compoundHarmony:
            harmony = "compound"
            break
        case triadicHarmony:
            harmony = "triadic"
            break
        case shadesHarmony:
            harmony = "shades"
            break
        default:
            break;
        }
        
        complementaryHarmony.state = 0
        monochromaticHarmony.state = 0
        analogousHarmony.state = 0
        compoundHarmony.state = 0
        triadicHarmony.state = 0
        shadesHarmony.state = 0
        
        sender.state = 1
        setSliders()
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
            if rSlider.integerValue == rText.integerValue { return }
            rSlider.integerValue = rText.integerValue
            rValue = clampTo(rSlider.integerValue)
            updateSliders(true)
            break
        case gText:
            if gSlider.integerValue == gText.integerValue { return }
            gSlider.integerValue = gText.integerValue
            gValue = clampTo(gSlider.integerValue)
            updateSliders(true)
            break
        case bText:
            if bSlider.integerValue == bText.integerValue { return }
            bSlider.integerValue = bText.integerValue
            bValue = clampTo(bSlider.integerValue)
            updateSliders(true)
            break
        case hText:
            if hSlider.integerValue == hText.integerValue { return }
            hSlider.integerValue = hText.integerValue
            hValue = clampTo(hSlider.integerValue)
            updateSliders(false)
            break
        case sText:
            if sSlider.integerValue == sText.integerValue { return }
            sSlider.integerValue = sText.integerValue
            sValue = clampTo(sSlider.integerValue)
            updateSliders(false)
            break
        case lText:
            if lSlider.integerValue == lText.integerValue { return }
            lSlider.integerValue = lText.integerValue
            lValue = clampTo(lSlider.integerValue)
            updateSliders(false)
            break
        case hexText:
            let value = sender.stringValue
            let matches = hexPattern.match(value)
            
            if matches.count > 0 {
                let nsrange = matches[0].rangeAtIndex(1)
                let range = value.rangeFromNSRange(nsrange)
                let code = value.substringWithRange(range!)
                
                if (code.characters.count == 3) {
                    let r = code.hexNibbleAt(0) * 17
                    let g = code.hexNibbleAt(1) * 17
                    let b = code.hexNibbleAt(2) * 17
                    
                    if r == rValue && g == gValue && b == bValue { return }
                    rValue = r
                    gValue = g
                    bValue = b
                    updateSliders(true)
                }
                if (code.characters.count >= 6) {
                    let r = code.hexByteAt(0)
                    let g = code.hexByteAt(2)
                    let b = code.hexByteAt(4)

                    if r == rValue && g == gValue && b == bValue { return }
                    rValue = r
                    gValue = g
                    bValue = b
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
        hexText.window?.makeFirstResponder(nil)

        switch (sender) {
        case rStepper:
            if rSlider.integerValue == rStepper.integerValue { return }
            rSlider.integerValue = rStepper.integerValue
            sliderUpdated(rSlider)
            break
        case gStepper:
            if gSlider.integerValue == gStepper.integerValue { return }
            gSlider.integerValue = gStepper.integerValue
            sliderUpdated(gSlider)
            break
        case bStepper:
            if bSlider.integerValue == bStepper.integerValue { return }
            bSlider.integerValue = bStepper.integerValue
            sliderUpdated(bSlider)
            break
        case hStepper:
            if hSlider.integerValue == hStepper.integerValue { return }
            hSlider.integerValue = hStepper.integerValue
            sliderUpdated(hSlider)
            break
        case sStepper:
            if sSlider.integerValue == sStepper.integerValue { return }
            sSlider.integerValue = sStepper.integerValue
            sliderUpdated(sSlider)
            break
        case lStepper:
            if lSlider.integerValue == lStepper.integerValue { return }
            lSlider.integerValue = lStepper.integerValue
            sliderUpdated(lSlider)
            break
        default:
            break
        }
    }
    
    @IBAction func sliderUpdated(sender: NSSlider) {
        editingTextType = ""
        hexText.window?.makeFirstResponder(nil)

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
        case lSlider:
            lValue = clampTo(lSlider.integerValue, max: 100)
            isRGB = false
            break
        default:
            break
        }
        
        updateSliders(isRGB)
    }
    
    func updateSliders(isRGB: Bool) {
        if (isRGB) {
            color = NSColor(red: rFloat, green: gFloat, blue: bFloat, alpha: 1.0)
            hFloat = color.hueComponent
            sFloat = color.saturationComponent
            lFloat = color.brightnessComponent
        } else {
            color = NSColor(hue: hFloat, saturation: sFloat, brightness: lFloat, alpha: 1.0)
            rFloat = color.redComponent
            gFloat = color.greenComponent
            bFloat = color.blueComponent
        }
        
        setSliders()
    }
    
    func colorSupplied(supply: NSColor, sender: NSView?) {
        if sender != nil {
            flashPress(sender!)
        }
        editingTextType = ""
        hexText.window?.makeFirstResponder(nil)
        hexText.backgroundColor = NSColor.whiteColor()
        color = supply
        setFromColor()
    }
    
    func colorSampled(sample: NSColor) {
        editingTextType = "hexText"
        hexText.backgroundColor = sample
        let rInt = clampFloatTo(sample.redComponent * 255)
        let gInt = clampFloatTo(sample.greenComponent * 255)
        let bInt = clampFloatTo(sample.blueComponent * 255)
        hexText.stringValue = String(format: "#%02x%02x%02x", rInt, gInt, bInt)
        hexText.window?.makeFirstResponder(nil)
    }
        

    
    override func viewDidLoad() {
        super.viewDidLoad()

        color = NSColor(red: 0.2, green: 0.6, blue: 0.8, alpha: 1)
        colorWell.color = color
        
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
        
        cc1.delegate = self
        cc2.delegate = self
        cc3.delegate = self
        cc4.delegate = self
        cc5.delegate = self
        
        rText.delegate = self
        gText.delegate = self
        bText.delegate = self
        hText.delegate = self
        sText.delegate = self
        lText.delegate = self

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
        picker.delegate = self

        pickerWin = NSWindow(contentRect: NSRect(x: 0, y: 0, width: picker.pickerSize, height: picker.pickerSize), styleMask: NSBorderlessWindowMask, backing: NSBackingStoreType.Buffered, `defer`: true)
        
        pickerWin.backgroundColor = NSColor.clearColor()
        pickerWin.level = Int(CGWindowLevelForKey(.MaximumWindowLevelKey))
        pickerWin.contentView?.addSubview(picker)

        hexText.window?.makeFirstResponder(nil)

        setFromColor()
    }
    
    override func viewDidDisappear() {
        exit(EXIT_SUCCESS)
    }
    
    func setFromColor() {
/*
        hValue = clampFloatTo(color.hueComponent * 360, max: 359)
        sValue = clampFloatTo(color.saturationComponent * 100, max: 100)
        lValue = clampFloatTo(color.brightnessComponent * 100, max: 100)
        rValue = clampFloatTo(color.redComponent * 255)
        gValue = clampFloatTo(color.greenComponent * 255)
        bValue = clampFloatTo(color.blueComponent * 255)
*/
        hFloat = color.hueComponent
        sFloat = color.saturationComponent
        lFloat = color.brightnessComponent
        rFloat = color.redComponent
        gFloat = color.greenComponent
        bFloat = color.blueComponent
        
        setSliders()
    }
    
    func clamp(value: CGFloat, max: CGFloat = 1, min: CGFloat = 0) -> CGFloat {
        return value > 1 ? 1 : value < 0 ? 0 : value
    }
    
    func clampFloatTo (value: CGFloat, max: Int = 255, min: Int = 0) -> Int {
        return clampTo(Int(round(value)), max: max, min: min)
    }
    
    func clampTo (value: Int, max: Int = 255, min: Int = 0) -> Int {
        if (value < min) { return min; }
        if (value > max) { return max; }
        return value
    }
    
    func mapRange(value: CGFloat, _ fromLower: CGFloat, _ fromUpper: CGFloat, _ toLower: CGFloat, _ toUpper: CGFloat) -> CGFloat {
        return (round((toLower) + (value - fromLower) * ((toUpper - toLower) / (fromUpper - fromLower))));
    }

    func artistToHue(hue: CGFloat) -> CGFloat {
        if hue < 60 { return (round((hue) * (35 / 60))) }
        if hue < 122 { return mapRange(hue, 60,  122, 35,  60) }
        if hue < 165 { return mapRange(hue, 122, 165, 60,  120) }
        if hue < 218 { return mapRange(hue, 165, 218, 120, 180) }
        if hue < 275 { return mapRange(hue, 218, 275, 180, 240) }
        if hue < 330 { return mapRange(hue, 275, 330, 240, 300) }
        return mapRange(hue, 330, 360, 300, 360)
    }
    
    func hueToArtist (hue: CGFloat) -> CGFloat {
        if hue < 35 { return (round(CGFloat(hue) * (60 / 35))) }
        if hue < 60 { return mapRange(hue, 35,  60,  60,  122) }
        if hue < 120 { return mapRange(hue, 60,  120, 122, 165) }
        if hue < 180 { return mapRange(hue, 120, 180, 165, 218) }
        if hue < 240 { return mapRange(hue, 180, 240, 218, 275) }
        if hue < 300 { return mapRange(hue, 240, 300, 275, 330) }
        return mapRange(hue, 300, 360, 330, 360)
    }
    
    func addHue(h: CGFloat, _ add: CGFloat) -> CGFloat {
        return artistToHue((hueToArtist(h) + add) % 360)
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
    
    func addValueOverflowOppose(v: CGFloat, _ add: CGFloat, cap: CGFloat = 100) -> CGFloat {
        return (v + add) % cap
    }

    func setSliders() {
        if lockButton.state == 0 && color != lockedColor {
            lockedColor = color
        }
        
        let rInt = clampTo(rValue)
        let gInt = clampTo(gValue)
        let bInt = clampTo(bValue)
        let hInt = clampTo(hValue, max: 359)
        let sInt = clampTo(sValue, max: 100)
        let lInt = clampTo(lValue, max: 100)
        
        rText.integerValue = rInt
        gText.integerValue = gInt
        bText.integerValue = bInt
        hText.integerValue = hInt
        sText.integerValue = sInt
        lText.integerValue = lInt

        rStepper.integerValue = rInt
        gStepper.integerValue = gInt
        bStepper.integerValue = bInt
        hStepper.integerValue = hInt
        sStepper.integerValue = sInt
        lStepper.integerValue = lInt

        rSlider.integerValue = rInt
        gSlider.integerValue = gInt
        bSlider.integerValue = bInt
        hSlider.integerValue = hInt
        sSlider.integerValue = sInt
        lSlider.integerValue = lInt
        
        colorWell.color = color
        
        rSliderCell.setColors(0, g1: gValue, b1: bValue, r2: 255, g2: gValue, b2: bValue)
        gSliderCell.setColors(rValue, g1: 0, b1: bValue, r2: rValue, g2: 255, b2: bValue)
        bSliderCell.setColors(rValue, g1: gValue, b1: 0, r2: rValue, g2: gValue, b2: 255)
        hSliderCell.setHue(sValue, l: lValue)
        sSliderCell.setSaturation(hValue, l: lValue)
        lSliderCell.setBrightness(hValue, s: sValue)
        
        rSlider.setNeedsDisplay()
        gSlider.setNeedsDisplay()
        bSlider.setNeedsDisplay()
        hSlider.setNeedsDisplay()
        sSlider.setNeedsDisplay()
        lSlider.setNeedsDisplay()
        
        if (editingTextType != "hexText") {
            hexText.stringValue = String(format: "#%02x%02x%02x", rInt, gInt, bInt)
        }
        
        if (editingTextType != "rgbText") {
            rgbText.stringValue = String(format: "rgb(%d, %d, %d)", rInt, gInt, bInt)
        }
        
        if (editingTextType != "hslText") {
            hslText.stringValue = String(format: "hsl(%d, %d%%, %d%%)", hInt, sInt, lInt)
        }

        let h = lockedColor.hueComponent * 360
        let s = lockedColor.saturationComponent * 100
        let l = lockedColor.brightnessComponent * 100
        
        cc0.setHSV(h, s: s, l: l)
        cc30.setHSV(addHue(h, 30), s: s, l: l)
        cc60.setHSV(addHue(h, 60), s: s, l: l)
        cc90.setHSV(addHue(h, 90), s: s, l: l)
        cc120.setHSV(addHue(h, 120), s: s, l: l)
        cc150.setHSV(addHue(h, 150), s: s, l: l)
        cc180.setHSV(addHue(h, 180), s: s, l: l)
        cc210.setHSV(addHue(h, 210), s: s, l: l)
        cc240.setHSV(addHue(h, 240), s: s, l: l)
        cc270.setHSV(addHue(h, 270), s: s, l: l)
        cc300.setHSV(addHue(h, 300), s: s, l: l)
        cc330.setHSV(addHue(h, 330), s: s, l: l)

        ccUp.setHSV(h, s: s, l: l + 20)
        ccDown.setHSV(h, s: s, l: l - 20)
        ccPlus.setHSV(h, s: s + 20, l: l)
        ccMinus.setHSV(h, s: s - 20, l: l)

        cc3.setHSV(h, s: s, l: l)
        
        switch (harmony) {
        case "analogous":
            cc1.setHSV(addHue(h,  30), s: addValueOverflowBounce(s, 5), l: addValueOverflowSlow(l, 5, min: 20))
            cc2.setHSV(addHue(h,  15), s: addValueOverflowBounce(s, 5), l: addValueOverflowFlip(l, 9, min: 20))
            cc4.setHSV(addHue(h, -15), s: addValueOverflowBounce(s, 5), l: addValueOverflowFlip(l, 9, min: 20))
            cc5.setHSV(addHue(h, -30), s: addValueOverflowBounce(s, 5), l: addValueOverflowSlow(l, 5, min: 20))
            break
        case "complementary":
            cc1.setHSV(addHue(h,   0), s: addValueOverflowSlow(s, 10), l: addValueOverflowFlip(l, -30, lcap: 20))
            cc2.setHSV(addHue(h,   0), s: addValueOverflowCap(s, -10), l: addValueOverflowCap(l, 30))
            cc4.setHSV(addHue(h, 180), s: addValueOverflowCap(s, 20), l: addValueOverflowFlip(l, -30, lcap: 20))
            cc5.setHSV(addHue(h, 180), s: s, l: l)
            break
        case "compound":
            cc1.setHSV(addHue(h, 30), s: addValueOverflowFlip(s, 10), l: addValueOverflowFlip(l, 20))
            cc2.setHSV(addHue(h, 30), s: addValueOverflowFlip(s, -40), l: addValueOverflowFlip(l, 40))
            cc4.setHSV(addHue(h, 165), s: addValueOverflowFlip(s, -25), l: addValueOverflowSlow(l, 5, brake: 40))
            cc5.setHSV(addHue(h, 150), s: addValueOverflowFlip(s, 10), l: addValueOverflowCap(l, 20))
            break
        case "monochromatic":
            cc1.setHSV(addHue(h, 0), s: addValueOverflowCap(s, 0), l: addValueOverflowCap(l, 30))
            cc2.setHSV(addHue(h, 0), s: addValueOverflowCap(s, -30), l: addValueOverflowCap(l, 10))
            cc4.setHSV(addHue(h, 0), s: addValueOverflowCap(s, -30), l: addValueOverflowCap(l, 30))
            cc5.setHSV(addHue(h, 0), s: addValueOverflowCap(s, 0), l: addValueOverflowCap(l, 60))
            break
        case "shades":
            cc1.setHSV(addHue(h, 0), s: addValueOverflowCap(s, 0), l: addValueOverflowCap(l, -25))
            cc2.setHSV(addHue(h, 0), s: addValueOverflowCap(s, 0), l: addValueOverflowCap(l, -50))
            cc4.setHSV(addHue(h, 0), s: addValueOverflowCap(s, 0), l: addValueOverflowCap(l, -75))
            cc5.setHSV(addHue(h, 0), s: addValueOverflowCap(s, 0), l: addValueOverflowCap(l, -90))
            break
        case "triadic":
            cc1.setHSV(addHue(h, 0), s: addValueOverflowCap(s, 10), l: addValueOverflowCap(l, -30))
            cc2.setHSV(addHue(h, 120), s: addValueOverflowCap(s, -10), l: addValueOverflowCap(l, 5))
            cc4.setHSV(addHue(h, -120), s: addValueOverflowCap(s, 10), l: addValueOverflowCap(l, -20))
            cc5.setHSV(addHue(h, -120), s: addValueOverflowCap(s, 5), l: addValueOverflowCap(l, 30))
            break
        default: break
        }
        
        
        if (l == 100) { ccUp.hidden = true; } else if (ccUp.hidden) { ccUp.hidden = false; }
        if (s == 100) { ccPlus.hidden = true; } else if (ccPlus.hidden) { ccPlus.hidden = false; }
        if (l == 0) { ccDown.hidden = true; } else if (ccDown.hidden) { ccDown.hidden = false; }
        if (s == 0) { ccMinus.hidden = true; } else if (ccMinus.hidden) { ccMinus.hidden = false; }
        
        textBgColor = hexText.backgroundColor
    }

}

