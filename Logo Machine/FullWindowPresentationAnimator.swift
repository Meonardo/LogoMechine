//
//  FullWindowPresentationAnimator.swift
//  Logo Mechine
//
//  Created by Meonardo on 2017/7/10.
//  Copyright © 2017年 Meonardo. All rights reserved.
//

import Cocoa

class FullWindowPresentationAnimator: NSObject, NSViewControllerPresentationAnimator {
    
    func animatePresentation(of viewController: NSViewController, from fromViewController: NSViewController) {
        
        viewController.view.wantsLayer = true
        viewController.view.layerContentsRedrawPolicy = .onSetNeedsDisplay
        fromViewController.view.addSubview(viewController.view)
        
        let frame = fromViewController.view.frame
        viewController.view.frame = frame
        viewController.view.layer?.backgroundColor = NSColor.clear.cgColor
        
    }
    
    func animateDismissal(of viewController: NSViewController, from fromViewController: NSViewController) {
        viewController.view.wantsLayer = true
        viewController.view.layerContentsRedrawPolicy = .onSetNeedsDisplay
        viewController.view.removeFromSuperview()
    }
}
