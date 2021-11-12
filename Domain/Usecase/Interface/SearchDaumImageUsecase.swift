import Entity

public protocol SearchDaumImageUsecase {
  func execute(query: String, pivot: Int) async throws -> SearchDaumImageResult
}

public protocol SearchDaumImageResult {
  var searchedImages: [SearchedImageByDaum] { get }
  var hasMore: Bool { get }
}
