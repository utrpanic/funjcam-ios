import Foundation

public protocol URLSessionProtocol {
  func data(_ request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {
  public func data(_ request: URLRequest) async throws -> (Data, URLResponse) {
    return try await self.data(for: request)
  }
}
