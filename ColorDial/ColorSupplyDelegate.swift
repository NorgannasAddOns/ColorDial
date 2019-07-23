//
//  ColorSupplyDelegate.swift
//  ColorDial
//
//  Created by Kenneth Allan on 13/12/2015.
//  Copyright © 2015 Kenneth Allan. All rights reserved.
//

import Cocoa

protocol ColorSupplyDelegate {
    func colorSupplied(_ supply: NSColor, sender: NSView?)
    func colorSampled(_ sample: NSColor)
}
