import Entity

public protocol DaumImageUsecase {
  func search(query: String, page: Int?) async throws -> DaumImageSearchResult
}

public protocol DaumImageSearchResult {
  var searchedImages: [SearchedImageByDaum] { get }
  var hasMore: Bool { get }
}
