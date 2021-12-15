import Usecase

public protocol SettingsDependency {
  
}

public protocol SettingsListener: AnyObject {
  
}

public protocol SettingsBuildable {
  func build() -> ViewControllable
}

public final class SettingsBuilder: SettingsBuildable {
  
  private let dependency: SettingsDependency
  private weak var listener: SettingsListener?
  
  public init(dependency: SettingsDependency, listener: SettingsListener?) {
    self.dependency = dependency
    self.listener = listener
  }
  
  public func build() -> ViewControllable {
    let controller = SettingsController(dependency: self.dependency, listener: self.listener)
    let viewController = SettingsViewController(controller: controller)
    controller.viewController = viewController
    return viewController
  }
}
