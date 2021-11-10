import Entity

public struct SearchState {
  
  public var provider: SearchProvider
  public var query: String = "김연아"
  public var searchingGif: Bool = false
  public var images: [SearchedImage] = []
  var next: Int?
  public var hasMore: Bool { return self.next != nil }
  
  init(provider: SearchProvider) {
    self.provider = provider
  }
}
