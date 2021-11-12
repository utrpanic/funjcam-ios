import Foundation
import Entity
import Network
import Usecase

public final class SearchNaverImageUsecase {
  
  private let network: Network
  
  public init(network: Network) {
    self.network = network
  }
  
  public func execute(query: String, pivot: Int) async throws -> SearchNaverImageResult {
    let params = NetworkGetParams(
      url: URL(string: "https://openapi.naver.com/v1/search/image"),
      headers: [
        "X-Naver-Client-Id": "93Aki4p3ckUPf2L7Lyac",
        "X-Naver-Client-Secret": "wD6dHhbcSs"
      ],
      queries: [
        "query": query,
        "sort": "sim", // sim or date
        "start": pivot, // 1 ~ 1000
        "display": "20", // 10 ~ 100
        "filter": "all" // all, large, medium, small
      ]
    )
    let responseBody = try await self.network.get(with: params).body
    return try JSONDecoder().decode(SearchNaverImageResultImp.self, from: responseBody)
  }
}

private struct SearchNaverImageResultImp: SearchNaverImageResult, Decodable {
  
  let searchedImages: [SearchedImageByNaver]
  let nextStartIndex: Int?
  
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
    self.nextStartIndex = startIndex.map { $0 + images.count }
  }
}
