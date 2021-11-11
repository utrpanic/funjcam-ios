public protocol RecentDependency {
  
}

public protocol RecentListener: AnyObject {
  
}

public protocol RecentViewControllable: ViewControllable {
  
}

public final class RecentController: RecentControllable, ViewControllerBuildable {

  private let dependency: RecentDependency
  private weak var viewController: RecentViewControllable?
  weak var listener: RecentListener?
  
  public init(dependency: RecentDependency) {
    self.dependency = dependency
  }
  
  public func buildViewController() -> ViewControllable {
    let viewController = RecentViewController(controller: self)
    self.viewController = viewController
    return viewController
  }
}
