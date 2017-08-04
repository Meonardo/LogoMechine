//
//  OperationModel.swift
//  Logo Mechine
//
//  Created by Meonardo on 2017/7/10.
//  Copyright © 2017年 Meonardo. All rights reserved.
//

import Foundation

struct Configuration {
    
    // iPhone logo
    static var operationPhone = [
        "iPhone App 60 @3x",
        "iPhone App 60 @2x",
        "iPhone Spotlight 40 @3x",
        "iPhone Spotlight 40 @2x",
        "iPhone Settings 29 @3x",
        "iPhone Settings 29 @2x",
        "iPhone Notification 20 @3x",
        "iPhone Notification 20 @2x",
        ]
    // iPad logo
    static var operationPad = [
        "iPadPro App 83.5 @2x",
        "iPad App 76 @2x",
        "iPad Spotlight 40 @2x",
        "iPad Settings 29 @2x",
        "iPad Notification 20 @2x",
        ]
    // Mac logo
    static var operationMac = [
        "Mac App 512 @2x",
        "Mac App 256 @2x",
        "Mac App 128 @2x",
        "Mac App 32 @2x",
        "Mac App 16 @2x"
        ]
    // Car Play logo
    static var operationCarPlay = [
        "Car Play 60 @3x",
        "Car Play 60 @2x",
        ]
}

enum OperationStatus {
    case ready, processing, finished, error
    
    var representValue: String{
        switch self {
        case .ready:
            return "准备"
        case .processing:
            return "进行中"
        case .finished:
            return "完成"
        case .error:
            return "错误"
        }
    }
}

class OperationModel: NSObject {
    
    var type: OperationType = .iPhone
    var name: String?
    var status: OperationStatus = .ready
    
    var tTypeValue: String{
        get{
            return type.representValue
        }
    }
    
    var tStatusValue: String{
        get{
            return self.status.representValue
        }
    }
    
}
