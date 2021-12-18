import Foundation
import Entity
import UIKit

public protocol BookmarkImageUsecase {
  func query() throws -> [BookmarkImage]
  func insert(name: String, url: URL?, image: UIImage) throws
  func delete(id: Int) throws
}

public enum BookmarkImageError: Error {
  case emptyURLString
}
