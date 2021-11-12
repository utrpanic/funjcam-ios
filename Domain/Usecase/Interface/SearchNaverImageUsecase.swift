import Entity

public protocol SearchNaverImageUsecase {
  func execute(query: String, pivot: Int) async throws -> SearchNaverImageResult
}

public protocol SearchNaverImageResult {
  var searchedImages: [SearchedImageByNaver] { get }
  var nextStartIndex: Int? { get }
}
