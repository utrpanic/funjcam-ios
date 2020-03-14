import NaturalLanguage
import RxSwift

public class SearchViewModel {
    
    public private(set) var query: String = "삼시세끼"
    public private(set) var searchingGIF: Bool = false
    private var next: Int?
    
    public var images: [SearchedImage] = [SearchedImage]()
    public var hasMore: Bool { return self.next != nil }
    
    public let updateStream: PublishSubject<Code> = PublishSubject<Code>()
    
    private let service: SearchServiceProtocol
    
    public init(service: SearchServiceProtocol? = nil) {
        self.service = SearchService()
    }
    
    public func updateQuery(_ query: String) {
        self.query = query
        self.next = nil
    }
    
    public func toggleSearchingGIF() {
        self.searchingGIF.toggle()
        self.next = nil
    }
    
    public func search() {
        guard self.query.hasElement else { return }
        let query = self.appendQueryForGifSearchingIfNeeded()
        self.service.search(query: query, pivot: nil) { (code, images, next) in
            if code.isSucceed, let images = images {
                self.images = images
                self.next = next
            }
            self.updateStream.onNext(code)
        }
    }
    
    public func searchMore() {
        guard let next = self.next else { return }
        self.next = nil
        let query = self.appendQueryForGifSearchingIfNeeded()
        self.service.search(query: query, pivot: next) { (code, images, next) in
            if code.isSucceed, let images = images {
                self.images.append(contentsOf: images)
                self.next = next
            }
            self.updateStream.onNext(code)
        }
    }
    
    private func appendQueryForGifSearchingIfNeeded() -> String {
        guard self.searchingGIF else { return self.query }
        let recognizer = NLLanguageRecognizer()
        recognizer.processString(self.query)
        if recognizer.dominantLanguage == .korean {
            return "\(self.query) 움짤"
        } else {
            return "\(self.query) gif"
        }
    }
}
