import UIKit

public protocol BookmarkControllable {
  func createViewController() -> ViewControllable
  func activate(with viewController: BookmarkViewControllable)
}

final class BookmarkViewController: ViewController, BookmarkViewControllable {
  
  private let controller: BookmarkControllable
  
  init(controller: BookmarkControllable) {
    self.controller = controller
    super.init(nibName: nil, bundle: nil)
    self.view.backgroundColor = .systemBackground
    self.controller.activate(with: self)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
