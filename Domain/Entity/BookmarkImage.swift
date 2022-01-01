import UIKit

public struct BookmarkImage: Identifiable {
  
  public var id: Int
  public var name: String
  public var url: URL?
  public var image: UIImage
  public var createdAt: Date
  
  public init(id: Int, name: String, urlString: String, image: UIImage, createdAt: Date) {
    self.id = id
    self.name = name
    self.url = URL(string: urlString)
    self.image = image
    self.createdAt = createdAt
  }
}
