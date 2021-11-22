import Entity

public protocol NaverImageUsecase {
  func search(query: String, next: Int?) async throws -> NaverImageSearchResult
}

public protocol NaverImageSearchResult {
  var searchedImages: [SearchedImageByNaver] { get }
  var next: Int? { get }
}
