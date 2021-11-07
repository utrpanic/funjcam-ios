import Foundation
import AnyCodable
import Network

enum HTTPMethod: String {
  case get = "GET"
}

public final class NetworkImp: Network {
  
  private let session: URLSessionProtocol
  
  public init(session: URLSessionProtocol) {
    self.session = session
  }
  
  public func get(with params: NetworkGetParams) async throws -> NetworkResponse {
    guard let url = params.url,
          var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
      throw NetworkError.malformedURL
    }
    urlComponents.queryItems = params.queries?.map {
      return URLQueryItem(name: $0.key, value: String(describing: $0.value))
    }
    guard let urlWithQuery = urlComponents.url else {
      throw NetworkError.malformedURL
    }
    var request = URLRequest(url: urlWithQuery)
    request.allHTTPHeaderFields = params.headers
    request.httpMethod = HTTPMethod.get.rawValue
    let (data, _) = try await self.session.data(request)
    return NetworkResponse(body: data)
  }
}
