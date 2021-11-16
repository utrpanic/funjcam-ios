import Foundation
import Entity
import Usecase

struct GoogleImageSearchResult: Decodable {
  
  var searchedImages: [SearchedImageByGoogle]
  var nextPages: [NextPage]?
  var next: Int? { return self.nextPages?.first?.startIndex }
  
  enum CodingKeys: String, CodingKey {
    case items
    case queries
  }
  
  enum Queries: String, CodingKey {
    case nextPage
  }
  
  struct NextPage: Decodable {
    
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
  
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.searchedImages = try values.decodeIfPresent([SearchedImageByGoogle].self, forKey: .items) ?? []
    let queriesContainer = try values.nestedContainer(keyedBy: Queries.self, forKey: .queries)
    self.nextPages = try queriesContainer.decodeIfPresent([NextPage].self, forKey: .nextPage)
  }
}
