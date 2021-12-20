public protocol MainBuildable {
  func build() -> ViewControllable
}

public final class MainBuilder: MainBuildable {
  
  private let dependency: MainDependency
  
  public init(dependency: MainDependency) {
    self.dependency = dependency
  }
  
  public func build() -> ViewControllable {
    let controller = MainController(dependency: self.dependency)
    return MainViewController(controller: controller)
  }
}
