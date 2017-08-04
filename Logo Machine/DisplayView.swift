//
//  DisplayView.swift
//  Logo Mechine
//
//  Created by Meonardo on 2017/7/8.
//  Copyright © 2017年 Meonardo. All rights reserved.
//

import Cocoa

protocol DisplayViewDelegte: class {
    func displayViewDidStart(_ type: OperationType, image: NSImage)
    func goBack()
}

//enum OperationType {
//    case iPhone, iPad, Mac, CarPlay
//    var representValue: String{
//        switch self {
//        case .iPhone: return "iPhone"
//        case .iPad: return "iPad"
//        case .Mac: return "Mac"
//        case .CarPlay: return "CarPlay"
//        }
//    }
//}

struct OperationType: OptionSet {
    
    let rawValue: Int
    
    static let iPhone = OperationType(rawValue: 1 << 0)
    static let iPad = OperationType(rawValue: 1 << 1)
    static let Mac = OperationType(rawValue: 1 << 2)
    static let CarPlay = OperationType(rawValue: 1 << 3)
    
    public var representValue: String {
        switch self {
        case OperationType.iPhone: return "iPhone"
        case OperationType.iPad: return "iPad"
        case OperationType.Mac: return "Mac"
        case OperationType.CarPlay: return "CarPlay"
        default: return "none"
        }
    }
    
    public var representOperation: [String]?{
        switch self {
        case OperationType.iPhone: return Configuration.operationPhone
        case OperationType.iPad: return Configuration.operationPad
        case OperationType.Mac: return Configuration.operationMac
        case OperationType.CarPlay: return Configuration.operationCarPlay
        default: return nil
        }
    }
}

class DisplayView: NSView {

    open weak var delegate: DisplayViewDelegte?
    fileprivate var type: OperationType {
        get{
            let selected = checkButtons.filter {$0.state == 1}
            let sum = selected.reduce(0, {$0 + $1.tag})
            return OperationType(rawValue: sum)
        }
    }
    
    lazy var checkButtons: [NSButton] = {
        var temp = [NSButton]()
        self.checkArea.subviews.forEach { (view) in
            if view.tag >= 1{
                temp.append(view as! NSButton)
            }
        }
        return temp
    }()
    
    @IBOutlet weak var imageView: NSImageView!
    @IBOutlet weak var startButton: NSButton!
    @IBOutlet weak var checkArea: NSView!
    
    @IBAction func buttonAction(_ sender: NSButton) {}
    
    @IBAction func startAction(_ sender: NSButton) {
        if sender.title == "返回" {
            delegate?.goBack()
        }else{
            delegate?.displayViewDidStart(type, image: imageView.image!)
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        let path = NSBezierPath.init(rect: dirtyRect)
        NSColor.init(hex: "FFFFFF").setFill()
        path.fill()
    }
}
