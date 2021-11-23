import Foundation
import Entity
import Usecase

struct NaverSearchImageResult: Decodable {
  
  let searchedImages: [SearchedImage]
  let next: Int?
  
  private enum CodingKeys: String, CodingKey {
    case items
    case display
    case total
    case start
    case lastBuildDate
  }
  
  private struct Image: Decodable {
    var link: String
    var sizewidth: String
    var sizeheight: String
    var thumbnail: String
    var title: String
  }
  
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    let images = try values.decodeIfPresent([Image].self, forKey: .items) ?? []
    self.searchedImages = images.map { item in
      return SearchedImage(
        urlString: item.link,
        pixelWidth: Int(item.sizewidth) ?? 0,
        pixelHeight: Int(item.sizeheight) ?? 0,
        thumbnailURLString: item.thumbnail
      )
    }
    let startIndex = try values.decodeIfPresent(Int.self, forKey: .start)
    self.next = startIndex.map { $0 + images.count }
  }
}
