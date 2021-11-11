import UIKit

public protocol SettingsControllable {
  
}

final class SettingsViewController: ViewController, SettingsViewControllable {
  
  private let controller: SettingsController
  
  init(controller: SettingsController) {
    self.controller = controller
    super.init(nibName: nil, bundle: nil)
    self.view.backgroundColor = .systemBackground
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
