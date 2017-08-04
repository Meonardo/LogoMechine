//
//  OperationViewController.swift
//  Logo Mechine
//
//  Created by Meonardo on 2017/7/10.
//  Copyright © 2017年 Meonardo. All rights reserved.
//

import Cocoa

class OperationViewController: NSViewController {
    
    open var fileURL: URL!
    open var image: NSImage!
    
    @IBOutlet weak var fileNameLabel: NSTextField!
    @IBOutlet var arrayController: NSArrayController!
    var tableViewDataSource = NSMutableArray()

    @IBOutlet weak var splitView: NSSplitView!
    @IBOutlet weak var displayView: DisplayView!
    @IBOutlet weak var tableView: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setups()
        // Do view setup here.
    }
    
}

extension OperationViewController{
    
    func setups() {
        displayView.imageView.image = image
        displayView.delegate = self
        fileNameLabel.stringValue = fileURL.lastPathComponent
        
        let temp = fileURL.lastPathComponent
        if let targetIndex = temp.characters.index(of: "."){
            let directoryName = temp.substring(with: temp.startIndex..<targetIndex)
            
            fileURL.deleteLastPathComponent()
            fileURL.appendPathComponent(directoryName)
        }
    }
    
    func startOperation(_ image: NSImage, type: OperationType) {

        if createFileDirectory(type){
            
            let queue = OperationQueue.init()
            queue.name = "\(type.representValue.uppercased())_OPERATION_QUEUE"
            let finishedOperation = BlockOperation.init {[weak self] _ in
                print("\(type.representValue.uppercased())_OPERATION_QUEUE is finished!")
                if let weakSelf = self{
                    OperationQueue.main.addOperation {
                        weakSelf.displayView.startButton.isEnabled = true
                        weakSelf.displayView.startButton.title = "返回"
                    }
                }
            }
            if let operations = type.representOperation {
                displayView.startButton.isEnabled = false
                for name in operations {
                    addOperation(with: image, name: name, type: type, finishedOperation: finishedOperation, on: queue)
                }
                queue.addOperation(finishedOperation)
            }
        }
    }
    
    func addOperation(with image: NSImage,
                      name: String,
                      type: OperationType,
                      finishedOperation: BlockOperation,
                      on queue: OperationQueue) {
        
        let model = OperationModel.init()
        model.name = name
        model.type = type
        model.status = .ready
        
        arrayController.addObject(model)

        let blockOperation = BlockOperation.init { 
            model.status = .processing
            let size = self.size(from: model.name!)
            let result = image.resizeImage(width: size.width, height: size.height)
            var url = self.fileURL!
            url.appendPathComponent(type.representValue)
            let name = model.name!.components(separatedBy: " ").joined()
            url.appendPathComponent("\(name).png")
            self.save(image: result, to: url, model: model)
        }
        
        blockOperation.completionBlock = {
            OperationQueue.main.addOperation {
                model.status = .finished
                let index = self.tableViewDataSource.index(of: model)
                self.tableView.reloadData(forRowIndexes: IndexSet.init(integer: index), columnIndexes: IndexSet.init(integer: 2))
            }
        }
        finishedOperation.addDependency(blockOperation)
        queue.addOperation(blockOperation)
    }
    
    func createFileDirectory(_ type: OperationType = .iPhone) -> Bool{
        do {
            var url = fileURL
            url?.appendPathComponent(type.representValue)
            try FileManager.default.createDirectory(at: url!, withIntermediateDirectories: true, attributes: nil)
            return true
            
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    func size(from name: String) -> CGSize {
        
        let temp = name.components(separatedBy: " ")
        let size = CGFloat(NumberFormatter().number(from: temp[2])!)
        let last = temp.last!
        
        let startIndex = last.index(after: last.startIndex)
        let targetIndex = last.index(after: startIndex)
        let factor = Int(last.substring(with: startIndex..<targetIndex))!
        
        return CGSize.init(width: CGFloat(factor) * size, height: CGFloat(factor) * size)
    }
    
    func save(image: NSImage, to url: URL, model: OperationModel) {
        if let cgRef = image.cgImage(forProposedRect: nil, context: nil, hints: nil){
            let bitMap = NSBitmapImageRep.init(cgImage: cgRef)
            bitMap.size = image.size
            let data = bitMap.representation(using: .PNG, properties: [:])
            do {
                try data?.write(to: url)
            }catch{
                print(error)
            }
        }
    }
}

extension OperationViewController: NSSplitViewDelegate{
    
    func splitView(_ splitView: NSSplitView, constrainMinCoordinate proposedMinimumPosition: CGFloat, ofSubviewAt dividerIndex: Int) -> CGFloat {
        if dividerIndex == 0 {
            return 200
        }else{
            return 350
        }
    }
    
    func splitView(_ splitView: NSSplitView, constrainMaxCoordinate proposedMaximumPosition: CGFloat, ofSubviewAt dividerIndex: Int) -> CGFloat {
        if dividerIndex == 0 {
            return 240
        }else{
            return 1000
        }
    }
}

extension OperationViewController: NSTableViewDelegate{
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 30
    }
    
}

extension OperationViewController: DisplayViewDelegte{
    
    func displayViewDidStart(_ type: OperationType, image: NSImage) {
    
        if type.contains(.iPhone) {
            startOperation(image, type: .iPhone)
        }
        
        if type.contains(.iPad) {
            startOperation(image, type: .iPad)
        }
        
        if type.contains(.Mac) {
            startOperation(image, type: .Mac)
        }
        
        if type.contains(.CarPlay) {
            startOperation(image, type: .CarPlay)
        }
        
    }
    
    func goBack() {
        self.dismissViewController(self)
    }
}
