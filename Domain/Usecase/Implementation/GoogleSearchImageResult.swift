import Foundation
import Entity
import Usecase

struct GoogleImageSearchResult: Decodable {
  
  var searchedImages: [SearchedImage]
  var nextPages: [NextPage]?
  var next: Int? { return self.nextPages?.first?.startIndex }
  
  enum CodingKeys: String, CodingKey {
    case items
    case queries
  }
  
  private struct Image: Decodable {
    var link: String
    var image: Metadata
    var mime: String
    var displayLink: String
  }
  
  private struct Metadata: Decodable {
    var width: Int = 0
    var height: Int = 0
    var thumbnailLink: String = ""
  }
  
  struct Queries: Decodable {
    var nextPage: [NextPage]
  }
  
  struct NextPage: Decodable {
    var startIndex: Int?
  }
  
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.searchedImages = (try values.decodeIfPresent([Image].self, forKey: .items) ?? []).map { item in
      return SearchedImage(
        urlString: item.link,
        pixelWidth: item.image.width,
        pixelHeight: item.image.height,
        thumbnailURLString: item.image.thumbnailLink
      )
    }
    let queries = try values.decodeIfPresent(Queries.self, forKey: .queries)
    self.nextPages = queries?.nextPage
  }
}
