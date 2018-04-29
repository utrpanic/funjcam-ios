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
    
    static let `default`: SearchProvider = .naver
    
    init(string: String?) {
        switch string {
        case "daum": self = .daum
        case "naver": self = .naver
        case "google": self = .google
        default: self = .default
        }
    }
    
//    var manager: SearchManager {
//        switch self {
//        case .daum: return DaumSearchManager()
//        case .naver: return NaverSearchManager()
//        case .google: return GoogleSearchManager()
//        }
//    }
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
                    self.next = response.nextPageStartIndex
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
                    self.next = response.nextPageStartIndex
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

//protocol SearchManager: class {
//
//    var searchUrl: String { get }
//
//    func parameters(keyword: String, next: Int?) -> [String: Any]
//}
//
//class DaumSearchManager: SearchManager {
//
//    var searchUrl: String { return "https://dapi.kakao.com/v2/search/image" }
//
//    func parameters(keyword: String, next: Int?) -> [String: Any] {
//        return [String: Any]()
//    }
//}
//
//class NaverSearchManager: SearchManager {
//
//    var searchUrl: String { return "https://openapi.naver.com/v1/search/image" }
//
//    func parameters(keyword: String, next: Int?) -> [String: Any] {
//        return [String: Any]()
//    }
//}
//
//class GoogleSearchManager: SearchManager {
//
//    var searchUrl: String { return "https://www.googleapis.com/customsearch/v1" }
//
//    func parameters(keyword: String, next: Int?) -> [String: Any] {
//        var parameters: [String: Any] = [
//            "key": "AIzaSyCTdQn7PY1xP5d_Otz8O8aTvbCSslU7lBQ",
//            "cx": "015032654831495313052:qzljc0expde",
//            "searchType": "image",
//            "num": 10 // 1~10만 허용.
//        ]
//        parameters["q"] = keyword
//        if let startIndex = next {
//            parameters["start"] = startIndex
//        }
//        return parameters
//    }
//}
