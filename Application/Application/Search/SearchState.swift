import Entity

struct SearchState {
  
  var provider: SearchProvider
  var query: String = "김연아"
  var searchingGif: Bool = false
  var images: [SearchedImage] = []
  var next: Int?
  var hasMore: Bool { return self.next != nil }
  
  init(provider: SearchProvider) {
    self.provider = provider
  }
}

enum SearchError: Error {
  case search(Error)
  case searchMore(Error)
}

enum SearchViewState {
  case loading(Bool)
  case stateArrived(SearchState)
  case errorArrived(SearchError)
}
