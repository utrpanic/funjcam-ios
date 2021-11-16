import Foundation
import Entity
import Usecase

struct NaverSearchImageResult: Decodable {
  
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
