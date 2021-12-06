import Entity

public protocol RecentImageUsecase {
  func query() async throws -> [RecentImage]
}
