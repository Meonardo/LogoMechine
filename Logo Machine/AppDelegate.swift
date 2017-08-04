//
//  AppDelegate.swift
//  Logo Machine
//
//  Created by Meonardo on 2017/7/12.
//  Copyright © 2017年 Meonardo. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @IBAction func openFileAction(_ sender: NSMenuItem) {
        if let window = NSApplication.shared().mainWindow {
            if let viewController = window.windowController?.contentViewController{
                if let temp = viewController as? ViewController {
                    temp.openFile()
                }
            }
        }
    }

}

