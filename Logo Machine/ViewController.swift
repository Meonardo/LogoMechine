//
//  ViewController.swift
//  Logo Machine
//
//  Created by Meonardo on 2017/7/12.
//  Copyright © 2017年 Meonardo. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var dragView: DragView!
    internal var viewController: NSViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dragView.delegate = self
    }
    
    override func viewWillLayout() {
        super.viewWillLayout()
        viewController?.view.frame = view.bounds
    }
    
    @IBAction func buttonAction(_ sender: Any) {
        openFile()
    }
    
}

extension ViewController{
    
    public func openFile() {
        
        let openPanel = NSOpenPanel.init()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canChooseFiles = true
        openPanel.isFloatingPanel = true
        openPanel.allowedFileTypes = ["png", "PNG"]
        
        if let window = view.window {
            openPanel.beginSheetModal(for: window, completionHandler: { (result) in
                if result == 1{
                    if let url = openPanel.urls.first{
                        if let image = NSImage.init(contentsOf: url){
                            guard image.size.width == image.size.width, image.size.width >= 1024 else {
                                self.showAlert(question: "图片不符合 Logo 尺寸规范", text: "最大为1024px", alertStyle: .warning)
                                return
                            }
                            self.dragViewDidDrag(with: image, fileURL: url, dragView: self.dragView)
                        }
                    }
                }
            })
        }
    }
    
    fileprivate func presentOperationViewController(_ image: NSImage, fileURL: URL) {
        
        let temp = OperationViewController.init()
        temp.image = image
        temp.fileURL = fileURL
        viewController = temp
        presentViewController(temp, animator: FullWindowPresentationAnimator())
    }

    
}

extension ViewController: DragViewDelegate{
    
    func dragViewDidDrag(with image: NSImage, fileURL: URL, dragView: DragView) {
        presentOperationViewController(image, fileURL: fileURL)
    }
}

extension NSViewController{
    
    func showAlert(question: String,
                   text: String,
                   alertStyle: NSAlertStyle,
                   completionHandler handler: ((NSModalResponse) -> Swift.Void)? = nil){
        
        let alert = NSAlert()
        alert.messageText = question
        alert.informativeText = text
        alert.alertStyle = alertStyle
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")
        
        if let window = view.window {
            alert.beginSheetModal(for: window, completionHandler: handler)
        }
    }
}

