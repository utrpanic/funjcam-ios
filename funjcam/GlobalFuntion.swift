//
//  GlobalFuntion.swift
//  funjcam
//
//  Created by gurren-l on 2016. 7. 22..
//  Copyright © 2016년 boxjeon. All rights reserved.
//

public func LocalizedString(key: String, args: CVarArgType...) -> String {
    let format = NSLocalizedString(key, comment: "")
    if args.count == 0 {
        return format
    } else {
        return String(format: format, arguments: args)
    }
}
