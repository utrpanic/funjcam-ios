import Foundation

public protocol Network {
  func get(with params: NetworkGetParams) async throws -> NetworkResponse
}

public enum NetworkError: Error {
  case malformedURL
  case httpError(Int)
}

public struct NetworkGetParams {
  
  public let url: URL?
  public let headers: [String: String]?
  public let queries: [String: Any]?
  
  public init(url: URL?, headers: [String: String]?, queries :[String: Any]?) {
    self.url = url
    self.headers = headers
    self.queries = queries
  }
}

public struct NetworkResponse {
  
  public let body: Data
  
  public init(body: Data) {
    self.body = body
  }
}
