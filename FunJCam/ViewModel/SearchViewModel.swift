import RxSwift

class SearchViewModel {
    
    public var images: [SearchedImage] = [SearchedImage]()
    public var hasMore: Bool { return self.next != nil }
    
    private var query: String = ""
    private var isGifOn: Bool = false
    private var next: Int?
    
    let updatedStream: PublishSubject<Code> = PublishSubject<Code>()
    
    private let service: SearchServiceProtocol
    
    init(service: SearchServiceProtocol? = nil) {
        self.service = service ?? SearchService(with: Settings.shared.searchProvider)
    }
    
    func updateQuery(_ query: String) {
        
    }
    
    func search() {
        
    }
    
    func searchMore() {
        
    }
}
