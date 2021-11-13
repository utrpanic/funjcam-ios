import Foundation
import Entity
import Usecase
import HTTPNetwork

public final class DaumImageUsecaseImp: DaumImageUsecase {
  
  private let network: HTTPNetwork
  
  public init(network: HTTPNetwork) {
    self.network = network
  }
  
  public func search(query: String, page: Int?) async throws -> DaumImageSearchResult {
    let params = HTTPGetParams(
        url: URL(string: "https://dapi.kakao.com/v2/search/image"),
        headers: [
          "Authorization": "KakaoAK 3aa0ae0423487ecc4eda2664cc7bc936"
        ],
        queries: [
          "query": query,
          "sort": "accuracy", // accuracy or recency
          "page": page, // 1 ~ 50
          "size": "20" // 1 ~ 80
        ]
    )
    let responseBody = try await self.network.get(with: params).body
    return try JSONDecoder().decode(DaumImageSearchResultImp.self, from: responseBody)
  }
}

private struct DaumImageSearchResultImp: DaumImageSearchResult, Decodable {
  
  let searchedImages: [SearchedImageByDaum]
  let hasMore: Bool
  
  enum CodingKeys: String, CodingKey {
    case documents
    case meta
  }
  
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.searchedImages = try values.decodeIfPresent([SearchedImageByDaum].self, forKey: .documents) ?? []
    let metadata = try values.decodeIfPresent(Metadata.self, forKey: .meta) ?? Metadata()
    self.hasMore = !metadata.is_end
  }
}

private class Metadata: Decodable {
  var total_count: Int = 0
  var pageable_count: Int = 0
  var is_end: Bool = true
}
