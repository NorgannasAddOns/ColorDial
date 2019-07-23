//
//  TiledImage.swift
//  ColorDial
//
//  Created by Kenneth Allan on 10/12/2015.
//  Copyright © 2015 Kenneth Allan. All rights reserved.
//

import Cocoa

class TiledImage: NSImageView {
    var bg: NSColor!
    var path: NSBezierPath!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)!
        self.bg = NSColor(patternImage: self.image!)
        self.path = NSBezierPath(rect: self.bounds)
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        bg.setFill()
        path.fill()
    }
}
