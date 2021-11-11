import Entity

public struct SearchState {
  
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
