import Entity

public protocol GoogleImageUsecase {
  func search(query: String, next: Int?) async throws -> GoogleImageSearchResult
}

public protocol GoogleImageSearchResult {
  var searchedImages: [SearchedImageByGoogle] { get }
  var next: Int? { get }
}
