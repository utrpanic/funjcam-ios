public protocol SettingsDependency {
  
}

public protocol SettingsListener: AnyObject {
  
}

public protocol SettingsViewControllable: ViewControllable {
  
}

public final class SettingsController: SettingsControllable, Buildable {
  
  private weak var viewController: SettingsViewControllable?
  weak var listener: SettingsListener?
  
  public init(dependency: SettingsDependency) {
    
  }
  
  public func createViewController() -> ViewControllable {
    let viewController = SettingsViewController(controller: self)
    self.viewController = viewController
    return viewController
  }
}
