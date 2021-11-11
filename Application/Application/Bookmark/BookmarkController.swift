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
  
  public init(dependency: BookmarkDependency, listener: BookmarkListener?) {
    self.dependency = dependency
    self.listener = listener
  }
  
  public func buildViewController() -> ViewControllable {
    return BookmarkViewController(controller: self)
  }
  
  public func activate(with viewController: BookmarkViewControllable) {
    self.viewController = viewController
  }
}
