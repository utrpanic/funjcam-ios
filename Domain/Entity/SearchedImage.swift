import Foundation
import BoxKit

public struct SearchedImage {
  
  public var url: URL?
  public var pixelWidth: Int
  public var pixelHeight: Int
  public var thumbnailURL: URL?
  
  public init(urlString: String, pixelWidth: Int, pixelHeight: Int, thumbnailURLString: String) {
    self.url = URL.safeVersion(from: urlString)
    self.pixelWidth = pixelWidth
    self.pixelHeight = pixelHeight
    self.thumbnailURL = URL.safeVersion(from: thumbnailURLString)
  }
}
