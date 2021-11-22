import Entity

public protocol SearchImageUsecase {
  func execute(query: String, next: Int?, provider: SearchProvider) async throws -> SearchImageResult
}

public struct SearchImageResult {
  
  public let images: [SearchedImage]
  public let next: Int?
  
  public init(images: [SearchedImage], next: Int?) {
    self.images = images
    self.next = next
  }
}
