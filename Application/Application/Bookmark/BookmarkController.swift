public protocol BookmarkDependency {
  
}

public protocol BookmarkListener: AnyObject {
  
}

public protocol BookmarkViewControllable: ViewControllable {
  
}

public final class BookmarkController: BookmarkControllable, ViewControllerBuildable {
  
  private let dependency: BookmarkDependency
  private weak var viewController: BookmarkViewControllable?
  weak var listener: BookmarkListener?
  
  public init(dependency: BookmarkDependency) {
    self.dependency = dependency
  }
  
  public func buildViewController() -> ViewControllable {
    let viewController = BookmarkViewController(controller: self)
    self.viewController = viewController
    return viewController
  }
}
