import Foundation
import Entity

public protocol RecentImageUsecase {
  func query() throws -> [RecentImage]
  func insert(name: String, url: URL?) throws
}

public enum RecentImageError: Error {
  case emptyURLString
}
