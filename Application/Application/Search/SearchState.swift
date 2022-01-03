import Entity

struct SearchState {
  
  var provider: SearchProvider
  var query: String = "김연아"
  var searchAnimatedGIF: Bool = false
  var images: [SearchImage] = []
  var next: Int?
  var hasMore: Bool { return self.next != nil }
  
  init(provider: SearchProvider) {
    self.provider = provider
  }
}

enum SearchEvent {
  case loading(Bool)
  case errorSearch(Error)
  case errorSearchMore(Error)
}
