//
//  Code.swift
//  FunJCam
//
//  Created by boxjeon on 2017. 10. 22..
//  Copyright © 2017년 the42apps. All rights reserved.
//

enum Code {
    
    case none
    case undefined(code: Int)
    case jsonError(message: String)
    
    case ok
    
    case forbidden
    case notFound
    
    private static let map: [Int: Code] = [
        200: .ok,
        403: .forbidden,
        404: .notFound,
    ]
    
    init(value: Int?) {
        if let value = value {
            self = Code.map[value] ?? .undefined(code: value)
        } else {
            self = .none
        }
    }
}
