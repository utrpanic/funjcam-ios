import Entity

public protocol RecentImageUsecase {
  func query() async throws -> [RecentImage]
}

public enum RecentImageError: Error {
  case emptyURLString
}
