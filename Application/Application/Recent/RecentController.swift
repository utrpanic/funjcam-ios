public protocol RecentDependency {
  
}

public protocol RecentListener: AnyObject {
  
}

public protocol RecentViewControllable: ViewControllable {
  
}

public final class RecentController: RecentControllable, Buildable {

  private weak var viewController: RecentViewControllable?
  weak var listener: RecentListener?
  
  public init(dependency: RecentDependency) {
    
  }
  
  public func createViewController() -> ViewControllable {
    let viewController = RecentViewController(controller: self)
    self.viewController = viewController
    return viewController
  }
}
