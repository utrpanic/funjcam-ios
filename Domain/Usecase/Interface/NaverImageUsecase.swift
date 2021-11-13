import Entity

public protocol NaverImageUsecase {
  func search(query: String, page: Int?) async throws -> NaverImageSearchResult
}

public protocol NaverImageSearchResult {
  var searchedImages: [SearchedImageByNaver] { get }
  var nextStartIndex: Int? { get }
}
