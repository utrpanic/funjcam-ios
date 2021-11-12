import Entity

public protocol SearchGoogleImageUsecase {
  func execute(query: String, pivot: Int) async throws -> SearchGoogleImageResult
}

public protocol SearchGoogleImageResult {
  var searchedImages: [SearchedImageByGoogle] { get }
  var nextPageStartIndex: Int? { get }
}
