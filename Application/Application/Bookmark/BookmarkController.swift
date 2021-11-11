public protocol BookmarkDependency {
  
}

public protocol BookmarkListener: AnyObject {
  
}

public protocol BookmarkViewControllable: ViewControllable {
  
}

public final class BookmarkController: BookmarkControllable, Buildable {
  
  private weak var viewController: BookmarkViewControllable?
  weak var listener: BookmarkListener?
  
  public init(dependency: BookmarkDependency) {
    
  }
  
  public func createViewController() -> ViewControllable {
    return BookmarkViewController(controller: self)
  }
}
