//
//  DragView.swift
//  Logo Mechine
//
//  Created by Meonardo on 2017/7/7.
//  Copyright © 2017年 Meonardo. All rights reserved.
//

import Cocoa

protocol DragViewDelegate: class {
    
    func dragViewDidDrag(with image: NSImage, fileURL: URL, dragView: DragView)
}

class DragView: NSView {

    open weak var delegate: DragViewDelegate?
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        let lineWidth: CGFloat = 3
        let dashColor: NSColor = .darkGray
        
        let innerRect = bounds.insetBy(dx: lineWidth, dy: lineWidth)
        let roundCornerPath = NSBezierPath.init(roundedRect: innerRect, xRadius: 8, yRadius: 8)
        roundCornerPath.lineWidth = lineWidth
        let dashPattern: [CGFloat] = [6, 4]
        roundCornerPath.setLineDash(dashPattern, count: 2, phase: 0)
        
        let lineHeight = dirtyRect.height / 4
        let path1 = NSBezierPath.init()
        path1.lineWidth = lineWidth
        path1.move(to: NSPoint(x: dirtyRect.width / 2, y: dirtyRect.height / 2 - lineHeight))
        path1.line(to: NSPoint(x: dirtyRect.width / 2, y: dirtyRect.height / 2 + lineHeight))
        
        let path2 = NSBezierPath.init()
        path2.lineWidth = lineWidth
        path2.move(to: NSPoint(x: dirtyRect.width / 2 - lineHeight, y: dirtyRect.height / 2))
        path2.line(to: NSPoint(x: dirtyRect.width / 2 + lineHeight, y: dirtyRect.height / 2))
        
        dashColor.setStroke()
        roundCornerPath.stroke()
        path1.stroke()
        path2.stroke()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.register(forDraggedTypes: [NSFilenamesPboardType])
    }
}

extension DragView{
    
    fileprivate func handleImage(_ path: String) {
        let url = URL.init(fileURLWithPath: path)
        if let image = NSImage.init(contentsOf: url){
            guard image.size.width == image.size.width, image.size.width >= 1024 else { return }
            delegate?.dragViewDidDrag(with: image, fileURL: url, dragView: self)
        }
    }
    
}

extension DragView{
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        return .copy
    }
    
    override func draggingUpdated(_ sender: NSDraggingInfo) -> NSDragOperation {
        return .copy
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        
        let pboard = sender.draggingPasteboard()
        let fileNames = pboard.propertyList(forType: NSFilenamesPboardType) as! [String]

        if !fileNames.isEmpty {
            Swift.print(fileNames)
            if let type = fileNames.first{
                if let suffix = type.components(separatedBy: ".").last {
                    if suffix == "png"{
                        handleImage(type)
                        return true
                    }
                    return false
                }
            }
        }
        return false
    }
    
}

