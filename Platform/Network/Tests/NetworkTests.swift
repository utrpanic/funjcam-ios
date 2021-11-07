import XCTest
import Network
@testable import NetworkImp

final class NetworkTests: XCTestCase {
  
  private func sut(session: URLSessionProtocol) -> Network {
    return NetworkImp(session: session)
  }
    
  func testGet() async throws {
    let stub = NetworkResponse(body: "stub".data(using: .utf8)!)
    let session = URLSessionMock(response: stub)
    let sut = self.sut(session: session)
    let params = NetworkGetParams(
      url: URL(string: "https://test.com"),
      headers: ["Authroization": "Bearer lsdkj23j"],
      queries: ["query": "someWord", "num": 3]
    )
    _ = try await sut.get(with: params)
    
    XCTAssert(session.request?.url?.host == params.url?.host)
    XCTAssert(session.request?.url?.path == params.url?.path)
    XCTAssert(session.request?.httpMethod == HTTPMethod.get.rawValue)
    XCTAssert(session.request?.allHTTPHeaderFields == params.headers)
    params.queries?.forEach { key, value in
      XCTAssert(session.request?.url?.queries[key] == String(describing: value))
    }
  }
}

private extension URL {
  var queries: [String: String] {
    guard let urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false) else { return [:] }
    var queries = [String: String]()
    urlComponents.queryItems?.forEach { queryItem in
      queries[queryItem.name] = queryItem.value
    }
    return queries
  }
}
