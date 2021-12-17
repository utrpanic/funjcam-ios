public protocol SearchBuildable {
  func build() -> ViewControllable
}

public final class SearchBuilder: SearchBuildable {
  
  private let dependency: SearchDependency
  private weak var listener: SearchListener?
  
  public init(dependency: SearchDependency, listener: SearchListener?) {
    self.dependency = dependency
    self.listener = listener
  }
  
  public func build() -> ViewControllable {
    let controller = SearchController(dependency: self.dependency)
    let viewController = SearchViewController(controller: controller)
    controller.viewController = viewController
    controller.listener = self.listener
    return viewController
  }
}
