import Combine
import Entity
import UIKit

public protocol BookmarkImageUsecase {
  func query() -> AnyPublisher<[BookmarkImage], Error>
  func insert(name: String, url: URL?, image: UIImage) throws
  func delete(id: Int) throws
}

public enum BookmarkImageError: Error {
  case emptyURLString
}
