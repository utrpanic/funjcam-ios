//
//  Code.swift
//  FunJCam
//
//  Created by boxjeon on 2017. 10. 22..
//  Copyright © 2017년 the42apps. All rights reserved.
//

enum Code {
    
    case none
    case unknown(code: Int)
    case jsonError(message: String)
    
    case ok
    
    case notFound
    
    init(value: Int?) {
        if let code = value {
            switch code {
            case 200:
                self = .ok
            case 404:
                self = .notFound
            default:
                self = .unknown(code: code)
            }
        } else {
            self = .none
        }
    }
    
}

