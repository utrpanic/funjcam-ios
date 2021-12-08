import Usecase

public protocol RecentDependency {
  var recentImageUsecase: RecentImageUsecase { get }
}

public protocol RecentListener: AnyObject {
  
}

public protocol RecentViewControllable: ViewControllable {
  
}

public final class RecentController: RecentControllable, ViewControllerBuildable {

  private let dependency: RecentDependency
  private weak var viewController: RecentViewControllable?
  weak var listener: RecentListener?
  
  public init(dependency: RecentDependency, listener: RecentListener?) {
    self.dependency = dependency
    self.listener = listener
  }
  
  public func buildViewController() -> ViewControllable {
    return RecentViewController(controller: self)
  }
  
  public func activate(with viewController: RecentViewControllable) {
    self.viewController = viewController
  }
}
