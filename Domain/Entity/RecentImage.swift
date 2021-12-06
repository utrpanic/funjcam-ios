import Foundation

public struct RecentImage {
  
  public var id: Int
  public var name: String
  public var url: URL?
  
  public init(id: Int, name: String, urlString: String) {
    self.id = id
    self.name = name
    self.url = URL(string: urlString)
  }
}
