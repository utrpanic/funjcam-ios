import Foundation

public protocol AlertBuildable {
  func build(title: String, message: String?) -> ViewControllable
}

public final class AlertBuilder: AlertBuildable {
  
  public init() {
    // Do nothing.
  }
  
  public func build(title: String, message: String?) -> ViewControllable {
    return AlertViewController(title: title, message: message, preferredStyle: .alert)
  }
}
