import Foundation
import Entity
import Network
import Usecase

public final class SearchGoogleImageUsecase {
  
  private let network: Network
  
  public init(network: Network) {
    self.network = network
  }
  
  public func execute(query: String, pivot: Int) async throws -> SearchGoogleImageResult {
    let params = NetworkGetParams(
      url: URL(string: "https://www.googleapis.com/customsearch/v1"),
      headers: nil,
      queries: [
        "q": query,
        "key": "AIzaSyCTdQn7PY1xP5d_Otz8O8aTvbCSslU7lBQ",
        "cx": "015032654831495313052:qzljc0expde",
        "searchType": "image",
        "start": pivot,
        "num": 10 // 1~10만 허용.
      ]
    )
    let responseBody = try await self.network.get(with: params).body
    return try JSONDecoder().decode(SearchGoogleImageResultImp.self, from: responseBody)
  }
}

private struct SearchGoogleImageResultImp: SearchGoogleImageResult, Decodable {
  
  var searchedImages: [SearchedImageByGoogle]
  var nextPages: [NextPage]?
  var nextPageStartIndex: Int? { return self.nextPages?.first?.startIndex }
  
  enum CodingKeys: String, CodingKey {
    case items
    case queries
  }
  
  enum Queries: String, CodingKey {
    case nextPage
  }
  
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.searchedImages = try values.decodeIfPresent([SearchedImageByGoogle].self, forKey: .items) ?? []
    let queriesContainer = try values.nestedContainer(keyedBy: Queries.self, forKey: .queries)
    self.nextPages = try queriesContainer.decodeIfPresent([NextPage].self, forKey: .nextPage)
  }
}

private struct NextPage: Decodable {
  
  var startIndex: Int = 0
  
  enum CodingKeys: String, CodingKey {
    case startIndex
  }
  
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    if let startIndex = try values.decodeIfPresent(Int.self, forKey: .startIndex) {
      self.startIndex = startIndex
    }
  }
}
