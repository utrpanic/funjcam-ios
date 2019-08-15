import RxSwift

class SearchViewModel {
    
    private(set) var query: String = "삼시세끼"
    private(set) var searchingGIF: Bool = false
    private var next: Int?
    
    var images: [SearchedImage] = [SearchedImage]()
    var hasMore: Bool { return self.next != nil }
    
    let updateStream: PublishSubject<Code> = PublishSubject<Code>()
    
    private let service: SearchServiceProtocol
    
    init(service: SearchServiceProtocol? = nil) {
        self.service = SearchService()
    }
    
    func updateQuery(_ query: String) {
        self.query = query
        self.next = nil
    }
    
    func toggleSearchingGIF() {
        self.searchingGIF.toggle()
        self.next = nil
    }
    
    func search() {
        guard self.query.hasElement else { return }
        let query = self.query + (self.searchingGIF ? " gif" : "")
        self.service.search(query: query, pivot: nil) { (code, images, next) in
            if code.isSucceed, let images = images {
                self.images = images
                self.next = next
            }
            self.updateStream.onNext(code)
        }
    }
    
    func searchMore() {
        guard let next = self.next else { return }
        self.next = nil
        let query = self.query + (self.searchingGIF ? " gif" : "")
        self.service.search(query: query, pivot: next) { (code, images, next) in
            if code.isSucceed, let images = images {
                self.images.append(contentsOf: images)
                self.next = next
            }
            self.updateStream.onNext(code)
        }
    }
}
