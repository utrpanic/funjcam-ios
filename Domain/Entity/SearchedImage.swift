import Foundation
import BoxKit

public struct SearchedImage {
  
  public var displayName: String
  public var url: URL?
  public var pixelWidth: Int
  public var pixelHeight: Int
  public var thumbnailURL: URL?
  
  public init(
    displayName: String,
    urlString: String,
    pixelWidth: Int,
    pixelHeight: Int,
    thumbnailURLString: String)
  {
    self.displayName = displayName
    self.url = URL.safeVersion(from: urlString)
    self.pixelWidth = pixelWidth
    self.pixelHeight = pixelHeight
    self.thumbnailURL = URL.safeVersion(from: thumbnailURLString)
  }
}
