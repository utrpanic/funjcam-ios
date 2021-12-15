import Usecase

public protocol SearchDependency {
  var searchProviderUsecase: SearchProviderUsecase { get }
  var searchImageUsecase: SearchImageUsecase { get }
  func imageViewerBuilder(listener: ImageViewerListener?) -> ImageViewerBuildable
}

public protocol SearchListener: AnyObject {
  
}

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
    let controller = SearchController(dependency: self.dependency, listener: self.listener)
    let viewController = SearchViewController(controller: controller)
    controller.viewController = viewController
    return viewController
  }
}
