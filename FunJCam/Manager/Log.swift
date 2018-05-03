//
//  Log.swift
//  FunJCam
//
//  Created by boxjeon on 2017. 1. 12..
//  Copyright © 2017년 the42apps. All rights reserved.
//

class Log {
    
    class func d<T>(_ value: T, file: NSString = #file, line: Int = #line) {
        print("\(file.lastPathComponent)[\(line)]: \(value)", terminator: "\n")
    }
    
    class func e<T>(_ value: T, file: NSString = #file, line: Int = #line) {
        print("\(file.lastPathComponent)[\(line)]: Error - \(value)", terminator: "\n")
    }
}
