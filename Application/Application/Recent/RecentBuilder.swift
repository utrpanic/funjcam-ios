import Usecase

public protocol RecentDependency {
  var recentImageUsecase: RecentImageUsecase { get }
}

public protocol RecentListener: AnyObject {
  
}

public protocol RecentBuildable {
  func build() -> ViewControllable
}

public final class RecentBuilder: RecentBuildable {
  
  private let dependency: RecentDependency
  private weak var listener: RecentListener?
  
  public init(dependency: RecentDependency, listener: RecentListener?) {
    self.dependency = dependency
    self.listener = listener
  }
  
  public func build() -> ViewControllable {
    let controller = RecentController(dependency: self.dependency, listener: self.listener)
    let viewController = RecentViewController(controller: controller)
    return viewController
  }
}
