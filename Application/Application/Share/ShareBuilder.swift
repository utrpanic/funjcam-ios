import Foundation

public protocol ShareBuildable {
  func build(data: Data) -> ViewControllable
}

public final class ShareBuilder: ShareBuildable {
  
  public init() {
    // Do nothing.
  }
  
  public func build(data: Data) -> ViewControllable {
    return ShareViewController(activityItems: [data], applicationActivities: nil)
  }
}
