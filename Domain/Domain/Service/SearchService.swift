import RxSwift

public enum SearchProvider: String {
    
    case daum
    case naver
    case google
    
    static var `default`: SearchProvider { return .daum }
    public static var all: [SearchProvider] { return [.daum, .naver, .google] }
    
    public init(string: String?) {
        if let provider = SearchProvider(rawValue: string ?? "") {
            self = provider
        } else {
            self = .default
        }
    }
}

class SearchService {
    
    var api: SearchApiProtocol
    
    init(api: SearchApiProtocol? = nil) {
        self.api = api ?? Api.shared
    }
    
    func search(query: String, pivot: Int?, from searchProvider: SearchProvider) -> Observable<([SearchedImage], Int?)> {
        switch searchProvider {
        case .daum:
            let pivot = pivot ?? 1
            let observable = self.api.searchDaumImage(with: query, pivot: pivot)
                .asObservable()
                .flatMap { (response) -> Observable<([SearchedImage], Int?)> in
                    let images = response.searchedImages
                    let next = response.hasMore ? pivot + 1 : nil
                    return Observable.just((images, next))
            }
            return observable.share()
        case .naver:
            let pivot = pivot ?? 1
            let observable = self.api.searchNaverImage(with: query, pivot: pivot)
                .asObservable()
                .flatMap { (response) -> Observable<([SearchedImage], Int?)> in
                    let images = response.searchedImages
                    let next = response.nextStartIndex
                    return Observable.just((images, next))
            }
            return observable.share()
        case .google:
            let observable = self.api.searchGoogleImage(with: query, pivot: pivot)
                .asObservable()
                .flatMap { (response) -> Observable<([SearchedImage], Int?)> in
                    let images = response.searchedImages
                    let next = response.nextPageStartIndex
                    return Observable.just((images, next))
            }
            return observable.share()
        }
    }
}
