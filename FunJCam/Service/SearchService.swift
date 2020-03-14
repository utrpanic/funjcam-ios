
public enum SearchProvider: String {
    
    case daum
    case naver
    case google
    
    static var `default`: SearchProvider { return .daum }
    public static var all: [SearchProvider] { return [.daum, .naver, .google] }
    
    public var name: String {
        switch self {
        case .daum: return "provider:daum".localized()
        case .naver: return "provider:naver".localized()
        case .google: return "provider:google".localized()
        }
    }
    
    public init(string: String?) {
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
    
    private var provider: SearchProvider {
        return Settings.shared.searchProvider
    }
    
    public func search(query: String, pivot: Int?, completion: @escaping (Code, [SearchedImage]?, Int?) -> Void) {
        switch self.provider {
        case .daum:
            let pivot = pivot ?? 1
            Api.shared.searchDaumImage(with: query, pivot: pivot) { (code, response) in
                let images = response?.searchedImages
                let next = response?.hasMore == true ? pivot + 1 : nil
                completion(code, images, next)
            }
            
        case .naver:
            let pivot = pivot ?? 1
            Api.shared.searchNaverImage(with: query, pivot: pivot) { (code, response) in
                let images = response?.searchedImages
                let next = response?.nextStartIndex
                completion(code, images, next)
            }
            
        case .google:
            Api.shared.searchGoogleImage(with: query, pivot: pivot) { (code, response) in
                let images = response?.searchedImages
                let next = response?.nextPageStartIndex
                completion(code, images, next)
            }
        }
    }
}
