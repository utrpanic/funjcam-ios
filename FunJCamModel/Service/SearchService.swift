//
//  SearchManager.swift
//  FunJCam
//
//  Created by boxjeon on 2018. 2. 10..
//  Copyright © 2018년 the42apps. All rights reserved.
//

public enum SearchProvider: String {
    
    case daum
    case naver
    case google
    
    static var `default`: SearchProvider { return .daum }
    static var all: [SearchProvider] { return [.daum, .naver, .google] }
    
    var name: String {
        switch self {
        case .daum: return "provider:daum".localized()
        case .naver: return "provider:naver".localized()
        case .google: return "provider:google".localized()
        }
    }
    
    init(string: String?) {
        if let provider = SearchProvider(rawValue: string ?? "") {
            self = provider
        } else {
            self = .default
        }
    }
}

public protocol SearchServiceProtocol {
    
    func search(query: String, pivot: Int?, completion: @escaping (Code, [SearchedImage]?, Int?) -> Void)
}

public class SearchService: SearchServiceProtocol {
    
    private let provider: SearchProvider
    
    public init(with provider: SearchProvider) {
        self.provider = provider
    }
    
    public func search(query: String, pivot: Int?, completion: @escaping (Code, [SearchedImage]?, Int?) -> Void) {
        switch self.provider {
        case .daum:
            let pivot = pivot ?? 1
            RestAPI.shared.searchDaumImage(with: query, pivot: pivot) { (code, response) in
                let images = response?.searchedImages
                let next = response?.hasMore == true ? pivot + 1 : nil
                completion(code, images, next)
            }
            
        case .naver:
            let pivot = pivot ?? 1
            RestAPI.shared.searchNaverImage(with: query, pivot: pivot) { (code, response) in
                let images = response?.searchedImages
                let next = response?.nextStartIndex
                completion(code, images, next)
            }
            
        case .google:
            RestAPI.shared.searchGoogleImage(with: query, pivot: pivot) { (code, response) in
                let images = response?.searchedImages
                let next = response?.nextPageStartIndex
                completion(code, images, next)
            }
        }
    }
}
