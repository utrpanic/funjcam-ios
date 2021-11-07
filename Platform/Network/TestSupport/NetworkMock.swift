import Foundation
import Network

public final class NetworkMock: Network {
  
  public enum Response {
    case response(NetworkResponse)
    case error(Error)
  }

  public var response: Response = .error(NSError())
  
  public func get(with params: NetworkGetParams) async throws -> NetworkResponse {
    switch self.response {
    case let .response(response):
      return response
    case let .error(error):
      throw error
    }
  }
}
