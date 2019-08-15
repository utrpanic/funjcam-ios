
class BookmarkViewModel {
    
    private var service: SearchServiceProtocol
    
    init(with service: SearchServiceProtocol? = nil) {
        self.service = service ?? SearchService(with: Settings.shared.searchProvider)
    }   
}
