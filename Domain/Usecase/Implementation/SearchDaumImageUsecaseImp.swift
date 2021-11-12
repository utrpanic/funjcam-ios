import Foundation
import Entity
import Usecase
import Network

public final class SearchDaumImageUsecaseImp: SearchDaumImageUsecase {
  
  private let network: Network
  
  public init(network: Network) {
    self.network = network
  }
  
  public func execute(query: String, pivot: Int) async throws -> SearchDaumImageResult {
    let params = NetworkGetParams(
        url: URL(string: "https://dapi.kakao.com/v2/search/image"),
        headers: [
          "Authorization": "KakaoAK 3aa0ae0423487ecc4eda2664cc7bc936"
        ],
        queries: [
          "query": query,
          "sort": "accuracy", // accuracy or recency
          "page": pivot, // 1 ~ 50
          "size": "20" // 1 ~ 80
        ]
    )
    let responseBody = try await self.network.get(with: params).body
    return try JSONDecoder().decode(SearchDaumImageResultImp.self, from: responseBody)
  }
}

private struct SearchDaumImageResultImp: SearchDaumImageResult, Decodable {
  
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
