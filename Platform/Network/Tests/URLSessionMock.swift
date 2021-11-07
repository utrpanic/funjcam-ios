import Foundation
import Network
import NetworkImp

final class URLSessionMock: URLSessionProtocol {
  
  private(set) var request: URLRequest?
  private var response: NetworkResponse
  
  init(response: NetworkResponse) {
    self.response = response
  }
  
  func data(_ request: URLRequest) async throws -> (Data, URLResponse) {
    self.request = request
    
    return (self.response.body, URLResponse())
  }
}
