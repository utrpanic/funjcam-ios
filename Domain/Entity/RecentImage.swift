import Foundation

public struct RecentImage {
  
  public var id: Int
  public var name: String
  public var url: URL?
  public var createdAt: Date
  
  public init(id: Int, name: String, urlString: String, createdAt: Date) {
    self.id = id
    self.name = name
    self.url = URL(string: urlString)
    self.createdAt = createdAt
  }
}
