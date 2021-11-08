public protocol SearchDependency {
  
}

public protocol SearchListener: AnyObject {
  
}

public protocol SearchViewControllable: ViewControllable {
  
}

public final class SearchController: SearchControllable {
  
  private let dependency: SearchDependency
  private weak var viewController: SearchViewControllable?
  weak var listener: SearchListener?
  
  public init(dependency: SearchDependency) {
    self.dependency = dependency
  }
  
  public func createViewController() -> ViewControllable {
    let viewController = SearchViewController(controller: self)
    self.viewController = viewController
    return viewController
  }
  
  public func activate(with viewController: SearchViewControllable) {
    self.viewController = viewController
  }
}
