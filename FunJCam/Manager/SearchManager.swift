//
//  SearchManager.swift
//  FunJCam
//
//  Created by boxjeon on 2018. 2. 10..
//  Copyright © 2018년 the42apps. All rights reserved.
//

enum SearchProvider: String {
    
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

class SearchManager {
    
    var images: [SearchedImage] = [SearchedImage]()
    
    private var keyword: String = ""
    private var next: Int?
    
    var hasMore: Bool { return self.next != nil }
    
    func search(keyword: String, gif: Bool, completion: @escaping (Code) -> Void) {
        guard !keyword.isEmpty else { return }
        self.keyword = keyword + (gif ? " \("search:gif".localized())" : "")
        switch SettingsCenter.shared.searchProvider {
        case .daum:
            ApiManager.shared.searchDaumImage(keyword: self.keyword, next: nil) { (code, response) in
                if let response = response {
                    self.images = response.searchedImages
                    self.next = response.hasMore ? 2 : nil
                }
                completion(code)
            }
            
        case .naver:
            ApiManager.shared.searchNaverImage(keyword: self.keyword, next: nil) { (code, response) in
                if let response = response {
                    self.images = response.searchedImages
                    self.next = response.nextStartIndex
                }
                completion(code)
            }
            
        case .google:
            ApiManager.shared.searchGoogleImage(keyword: self.keyword, next: nil) { (code, response) in
                if let response = response {
                    self.images = response.searchedImages
                    self.next = response.nextPageStartIndex
                }
                completion(code)
            }
        }
    }
    
    func searchMore(completion: @escaping () -> Void) {
        guard let next = self.next else {
            completion()
            return
        }
        self.next = nil
        switch SettingsCenter.shared.searchProvider {
        case .daum:
            ApiManager.shared.searchDaumImage(keyword: keyword, next: next) { (code, response) in
                if let response = response {
                    self.images.append(contentsOf: response.searchedImages)
                    self.next = response.hasMore ? next + 1 : nil
                }
                completion()
            }
            
        case .naver:
            ApiManager.shared.searchNaverImage(keyword: keyword, next: next) { (code, response) in
                if let response = response {
                    self.images.append(contentsOf: response.searchedImages)
                    self.next = response.nextStartIndex
                }
                completion()
            }
            
        case .google:
            ApiManager.shared.searchGoogleImage(keyword: keyword, next: next) { (code, response) in
                if let response = response {
                    self.images.append(contentsOf: response.searchedImages)
                    self.next = response.nextPageStartIndex
                }
                completion()
            }
        }
    }
}
