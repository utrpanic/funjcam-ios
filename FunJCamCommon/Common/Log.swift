//
//  Log.swift
//  BoxJeonExtension
//
//  Created by BoxJeon on 13/04/2019.
//  Copyright © 2019 boxjeon. All rights reserved.
//

public class Log {
    
    public static func d<T>(_ value: T, file: NSString = #file, line: Int = #line) {
        print("\(file.lastPathComponent.ns.deletingPathExtension)[\(line)]: \(value)", terminator: "\n")
    }
    
    public static func e<T>(_ value: T, file: NSString = #file, line: Int = #line) {
        print("\(file.lastPathComponent.ns.deletingPathExtension)[\(line)]: Error - \(value)", terminator: "\n")
    }
}
