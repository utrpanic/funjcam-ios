import Foundation
import HTTPNetwork

public final class HTTPNetworkMock: HTTPNetwork {
  
  public enum Response {
    case response(HTTPNetworkResponse)
    case error(Error)
  }

  public var response: Response = .error(NSError())
  
  public func get(with params: HTTPGetParams) async throws -> HTTPNetworkResponse {
    switch self.response {
    case let .response(response):
      return response
    case let .error(error):
      throw error
    }
  }
}
