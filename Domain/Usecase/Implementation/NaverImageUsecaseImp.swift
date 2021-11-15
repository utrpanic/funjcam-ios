import Foundation
import Entity
import HTTPNetwork
import Usecase

public final class NaverImageUsecaseImp: NaverImageUsecase {
  
  private let network: HTTPNetwork
  
  public init(network: HTTPNetwork) {
    self.network = network
  }
  
  public func search(query: String, next: Int?) async throws -> NaverImageSearchResult {
    let params = HTTPGetParams(
      url: URL(string: "https://openapi.naver.com/v1/search/image"),
      headers: [
        "X-Naver-Client-Id": "93Aki4p3ckUPf2L7Lyac",
        "X-Naver-Client-Secret": "wD6dHhbcSs"
      ],
      queries: [
        "query": query,
        "sort": "sim", // sim or date
        "start": next, // 1 ~ 1000
        "display": "20", // 10 ~ 100
        "filter": "all" // all, large, medium, small
      ]
    )
    let responseBody = try await self.network.get(with: params).body
    return try JSONDecoder().decode(NaverImageSearchResultImp.self, from: responseBody)
  }
}

private struct NaverImageSearchResultImp: NaverImageSearchResult, Decodable {
  
  let searchedImages: [SearchedImageByNaver]
  let next: Int?
  
  enum CodingKeys: String, CodingKey {
    case items
    case display
    case total
    case start
    case lastBuildDate
  }
  
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    let images = try values.decodeIfPresent([SearchedImageByNaver].self, forKey: .items) ?? []
    self.searchedImages = images
    let startIndex = try values.decodeIfPresent(Int.self, forKey: .start)
    self.next = startIndex.map { $0 + images.count }
  }
}
