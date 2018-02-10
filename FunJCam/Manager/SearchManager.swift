//
//  SearchManager.swift
//  FunJCam
//
//  Created by boxjeon on 2018. 2. 10..
//  Copyright © 2018년 the42apps. All rights reserved.
//

enum Provider {
    case naver
    case google
    
    var controller: SearchManager {
        switch self {
        case .naver:
            return NaverSearchManager.shared
        case .google:
            return GoogleSearchManager.shared
        }
    }
}

protocol SearchManager: class {
    
    var searchUrl: String { get }
}

class NaverSearchManager: SearchManager {
    
    static let shared = NaverSearchManager()
    
    var searchUrl: String { return "https://openapi.naver.com/v1/search/image" }
}

class GoogleSearchManager: SearchManager {
    
    static let shared = GoogleSearchManager()
    
    var searchUrl: String { return "https://www.googleapis.com/customsearch/v1" }
}
