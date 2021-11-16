import Foundation
import Entity
import Usecase

struct DaumSearchImageResult: Decodable {
  
  let searchedImages: [SearchedImageByDaum]
  let next: Int?
  
  enum CodingKeys: String, CodingKey {
    case documents
    case meta
  }
  
  struct Metadata: Decodable {
    var total_count: Int = 0
    var pageable_count: Int = 0
    var is_end: Bool = true
  }
  
  static let currentPage: CodingUserInfoKey = CodingUserInfoKey(rawValue: "currentPage")!
  
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.searchedImages = try values.decodeIfPresent([SearchedImageByDaum].self, forKey: .documents) ?? []
    let metadata = try values.decodeIfPresent(Metadata.self, forKey: .meta) ?? Metadata()
    if let currentPage = decoder.userInfo[DaumSearchImageResult.currentPage] as? Int, !metadata.is_end {
      self.next = currentPage + 1
    } else {
      self.next = nil
    }
  }
}

