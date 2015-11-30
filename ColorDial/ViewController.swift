//
//  ViewController.swift
//  ColorDial
//
//  Created by Kenneth Allan on 30/11/2015.
//  Copyright © 2015 Kenneth Allan. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, ColorCircleDelegate {
    var rValue: Int = 0
    var gValue: Int = 0
    var bValue: Int = 0
    var hValue: Int = 0
    var sValue: Int = 0
    var vValue: Int = 0
    
    var color: NSColor = NSColor(red: 0, green: 0, blue: 0, alpha: 0)
    
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

    @IBAction func colorUpdated(sender: AnyObject) {
        if let cw = sender as? NSColorWell {
            color = cw.color
            setFromColor()
        }
    }
    
    @IBAction func sliderUpdated(sender: NSSlider) {
        var isRGB: Bool = true;
        switch (sender) {
        case rSlider:
            rValue = (rSlider.integerValue)
            break;
        case gSlider:
            gValue = (gSlider.integerValue)
            break;
        case bSlider:
            bValue = (bSlider.integerValue)
            break;
        case hSlider:
            hValue = (hSlider.integerValue)
            isRGB = false
            break;
        case sSlider:
            sValue = (sSlider.integerValue)
            isRGB = false
            break;
        case vSlider:
            vValue = (vSlider.integerValue)
            isRGB = false
            break;
        default: break
        }
        
        if (isRGB) {
            color = NSColor(red: CGFloat(rValue)/255, green: CGFloat(gValue)/255, blue: CGFloat(bValue)/255, alpha: 1.0)
            hValue = Int(color.hueComponent * 360)
            sValue = Int(color.saturationComponent * 100)
            vValue = Int(color.brightnessComponent * 100)
        } else {
            color = NSColor(hue: CGFloat(hValue)/360, saturation: CGFloat(sValue)/100, brightness: CGFloat(vValue)/100, alpha: 1.0)
            rValue = Int(color.redComponent * 255)
            gValue = Int(color.greenComponent * 255)
            bValue = Int(color.blueComponent * 255)
        }
        
        setSliders()
    }
    
    @IBAction func colorClicked(sender: ColorCircle) {
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
        
        setFromColor()
    }
    
    override func viewDidDisappear() {
        exit(EXIT_SUCCESS)
    }
    
    func setFromColor() {
        hValue = Int(color.hueComponent * 360)
        sValue = Int(color.saturationComponent * 100)
        vValue = Int(color.brightnessComponent * 100)
        rValue = Int(color.redComponent * 255)
        gValue = Int(color.greenComponent * 255)
        bValue = Int(color.blueComponent * 255)
        setSliders()
    }
    
    func setSliders() {
        let rInt = Int(rValue)
        let gInt = Int(gValue)
        let bInt = Int(bValue)
        let hInt = Int(hValue)
        let sInt = Int(sValue)
        let vInt = Int(vValue)
        
        rText.integerValue = rInt
        gText.integerValue = gInt
        bText.integerValue = bInt
        hText.integerValue = hInt
        sText.integerValue = sInt
        vText.integerValue = vInt
        
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

        ccUp.setHSV(hValue, s: sValue + 10, v: vValue)
        ccDown.setHSV(hValue, s: sValue - 10, v: vValue)
        ccPlus.setHSV(hValue, s: sValue, v: vValue + 10)
        ccMinus.setHSV(hValue, s: sValue, v: vValue - 10)
        
/*        ccPlus.setHSV(hValue, s: sValue, v: vValue)
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

