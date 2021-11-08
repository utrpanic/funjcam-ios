import UIKit

public protocol RecentControllable {
  func createViewController() -> ViewControllable
  func activate(with viewController: RecentViewControllable)
}

final class RecentViewController: ViewController, RecentViewControllable {
  
  private let controller: RecentControllable
  
  init(controller: RecentControllable) {
    self.controller = controller
    super.init(nibName: nil, bundle: nil)
    self.view.backgroundColor = .systemBackground
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
