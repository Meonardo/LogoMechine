//
//  Categories.swift
//  Logo Mechine
//
//  Created by Meonardo on 2017/7/8.
//  Copyright © 2017年 Meonardo. All rights reserved.
//

import Foundation
import AppKit

extension NSView{
    
    class func loadNib<T: NSView>(of type: T.Type, owner: Any?) -> T? {

        let className = String.init(describing: type.self)
        var list = NSArray.init()
        if Bundle.main.loadNibNamed(className, owner: owner, topLevelObjects: &list){
            let temp = list as Array
            let result = temp.filter {$0 is T}
            return result.first as? T
        }
        return nil
    }
    
}

extension NSImage {
    
    func resizeImage(width: CGFloat, height: CGFloat) -> NSImage {
        let newSize = NSSize(width: width, height: height)
        
        if let bitmapRep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: Int(width), pixelsHigh: Int(height), bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: NSCalibratedRGBColorSpace, bytesPerRow: 0, bitsPerPixel: 0) {
            bitmapRep.size = newSize
            NSGraphicsContext.saveGraphicsState()
            NSGraphicsContext.setCurrent(NSGraphicsContext(bitmapImageRep: bitmapRep))
            self.draw(in: NSRect(x: 0, y: 0, width: width, height: height), from: NSZeroRect, operation: .copy, fraction: 1.0)
            NSGraphicsContext.restoreGraphicsState()
            
            let resizedImage = NSImage(size: newSize)
            resizedImage.addRepresentation(bitmapRep)
            return resizedImage
        }
        return self
    }
}
