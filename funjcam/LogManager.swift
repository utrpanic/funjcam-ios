//
//  LogManager.swift
//  funjcam
//
//  Created by gurren-l on 2016. 7. 19..
//  Copyright © 2016년 boxjeon. All rights reserved.
//

let Log: LogManager? = {
    #if DEBUG
        return LogManager()
    #else
        return nil
    #endif
}()

class LogManager {
    func d<T>(value: T, file: NSString = #file, line: Int = #line) {
        print("\(file.lastPathComponent)[\(line)]: \(value)", terminator: "\n")
    }
    
    func printError(error: NSError?) {
        if let error = error {
            self.d("error code: \(error.code)")
            self.d("error description: \(error.localizedDescription)")
        }
    }
}
