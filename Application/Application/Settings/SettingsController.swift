protocol SettingsViewControllable: ViewControllable {
  
}

final class SettingsController: SettingsControllable {
  
  weak var viewController: SettingsViewControllable?
  weak var listener: SettingsListener?
  
  init(dependency: SettingsDependency, listener: SettingsListener?) {
    self.listener = listener
  }
}
