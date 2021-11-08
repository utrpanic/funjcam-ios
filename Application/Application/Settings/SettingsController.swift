public protocol SettingsDependency {
  
}

public protocol SettingsListener: AnyObject {
  
}

public protocol SettingsViewControllable: ViewControllable {
  
}

public final class SettingsController: SettingsControllable {
  
  private let dependency: SettingsDependency
  private weak var viewController: SettingsViewControllable?
  weak var listener: SettingsListener?
  
  public init(dependency: SettingsDependency) {
    self.dependency = dependency
  }
  
  public func createViewController() -> ViewControllable {
    let viewController = SettingsViewController(controller: self)
    self.viewController = viewController
    return viewController
  }
  
  public func activate(with viewController: SettingsViewControllable) {
    self.viewController = viewController
  }
}
