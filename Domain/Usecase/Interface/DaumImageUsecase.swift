import Entity

public protocol DaumImageUsecase {
  func search(query: String, next: Int?) async throws -> DaumImageSearchResult
}

public protocol DaumImageSearchResult {
  var searchedImages: [SearchedImageByDaum] { get }
  var next: Int? { get }
}
