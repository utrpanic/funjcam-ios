public protocol SettingsDependency {
  
}

public protocol SettingsListener: AnyObject {
  
}

public protocol SettingsViewControllable: ViewControllable {
  
}

public final class SettingsController: SettingsControllable, ViewControllerBuildable {
  
  private let dependency: SettingsDependency
  private weak var viewController: SettingsViewControllable?
  weak var listener: SettingsListener?
  
  public init(dependency: SettingsDependency, listener: SettingsListener?) {
    self.dependency = dependency
    self.listener = listener
  }
  
  public func buildViewController() -> ViewControllable {
    return SettingsViewController(controller: self)
  }
  
  public func activate(with viewController: SettingsViewControllable) {
    self.viewController = viewController
  }
}
