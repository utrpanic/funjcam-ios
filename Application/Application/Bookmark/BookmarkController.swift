public protocol BookmarkDependency {
  
}

public protocol BookmarkListener: AnyObject {
  
}

public protocol BookmarkViewControllable: ViewControllable {
  
}

public final class BookmarkController: BookmarkControllable {
  
  private let dependency: BookmarkDependency
  private weak var viewController: BookmarkViewControllable?
  weak var listener: BookmarkListener?
  
  public init(dependency: BookmarkDependency) {
    self.dependency = dependency
  }
  
  public func createViewController() -> ViewControllable {
    return BookmarkViewController(controller: self)
  }
  
  public func activate(with viewController: BookmarkViewControllable) {
    self.viewController = viewController
  }
}
