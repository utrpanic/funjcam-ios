import Foundation
import Entity
import Usecase

struct DaumSearchImageResult: Decodable {
  
  let searchedImages: [SearchImage]
  let next: Int?
  
  private enum CodingKeys: String, CodingKey {
    case documents
    case meta
  }
  
  private struct Image: Decodable {
    var image_url: String
    var width: Int
    var height: Int
    var thumbnail_url: String
    var collection: String
    var display_sitename: String
    var doc_url: String
    var datetime: String
  }
  
  struct Metadata: Decodable {
    var total_count: Int = 0
    var pageable_count: Int = 0
    var is_end: Bool = true
  }
  
  static let currentPage: CodingUserInfoKey = CodingUserInfoKey(rawValue: "currentPage")!
  
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.searchedImages = (try values.decodeIfPresent([Image].self, forKey: .documents) ?? []).map { image in
      return SearchImage(
        displayName: image.display_sitename,
        urlString: image.image_url,
        pixelWidth: image.width,
        pixelHeight: image.height,
        thumbnailURLString: image.thumbnail_url
      )
    }
    let metadata = try values.decodeIfPresent(Metadata.self, forKey: .meta) ?? Metadata()
    if let currentPage = decoder.userInfo[DaumSearchImageResult.currentPage] as? Int, !metadata.is_end {
      self.next = currentPage + 1
    } else {
      self.next = nil
    }
  }
}
