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
    
    static let `default`: SearchProvider = .daum
    
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
    var next: Int?
    
    private var keyword: String?
    
    func search(keyword: String, completion: @escaping (Code) -> Void) {
        self.keyword = keyword
        switch SettingsCenter.shared.searchProvider {
        case .daum:
            ApiManager.shared.searchDaumImage(keyword: keyword, next: nil) { (code, response) in
                if let response = response {
                    self.images = response.searchedImages
                    self.next = response.hasMore ? 2 : nil
                }
                completion(code)
            }
            
        case .naver:
            ApiManager.shared.searchNaverImage(keyword: keyword, next: nil) { (code, response) in
                if let response = response {
                    self.images = response.searchedImages
                    self.next = response.nextStartIndex
                }
                completion(code)
            }
            
        case .google:
            ApiManager.shared.searchGoogleImage(keyword: keyword, next: nil) { (code, response) in
                if let response = response {
                    self.images = response.searchedImages
                    self.next = response.nextPageStartIndex
                }
                completion(code)
            }
        }
    }
    
    func searchMore(completion: @escaping () -> Void) {
        guard let keyword = self.keyword, let next = self.next else {
            completion()
            return
        }
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
