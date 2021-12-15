import Usecase
import SQLite

public protocol BookmarkDependency {
  var bookmarkImageUsecase: BookmarkImageUsecase { get }
}

public protocol BookmarkListener: AnyObject {
  
}

public protocol BookmarkBuildable {
  func build() -> ViewControllable
}

public final class BookmarkBuilder: BookmarkBuildable {
  
  private let dependency: BookmarkDependency
  private weak var listener: BookmarkListener?
  
  public init(dependency: BookmarkDependency, listener: BookmarkListener?) {
    self.dependency = dependency
    self.listener = listener
  }
  
  public func build() -> ViewControllable {
    let controller = BookmarkController(dependency: self.dependency, listener: self.listener)
    let viewController = BookmarkViewController(controller: controller)
    controller.viewController = viewController
    return viewController
  }
}
