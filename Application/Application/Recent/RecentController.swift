public protocol RecentDependency {
  
}

public protocol RecentListener: AnyObject {
  
}

public protocol RecentViewControllable: ViewControllable {
  
}

public final class RecentController: RecentControllable {
  
  

  private let dependency: RecentDependency
  private weak var viewController: RecentViewControllable?
  weak var listener: RecentListener?
  
  public init(dependency: RecentDependency) {
    self.dependency = dependency
  }
  
  public func activate(with viewController: RecentViewControllable) {
    self.viewController = viewController
  }
  
  public func createViewController() -> ViewControllable {
    let viewController = RecentViewController(controller: self)
    self.viewController = viewController
    return viewController
  }
}
