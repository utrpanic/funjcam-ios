import UIKit

public protocol RecentControllable {
  func activate(with viewController: RecentViewControllable)
}

final class RecentViewController: ViewController, RecentViewControllable {
  
  private let controller: RecentControllable
  
  init(controller: RecentControllable) {
    self.controller = controller
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .systemBackground
    self.controller.activate(with: self)
  }
}
