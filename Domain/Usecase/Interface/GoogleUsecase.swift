import Entity

public protocol GoogleImageUsecase {
  func search(query: String, page: Int?) async throws -> GoogleImageSearchResult
}

public protocol GoogleImageSearchResult {
  var searchedImages: [SearchedImageByGoogle] { get }
  var nextPageStartIndex: Int? { get }
}
