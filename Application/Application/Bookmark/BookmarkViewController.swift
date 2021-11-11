import UIKit

public protocol BookmarkControllable {
  
}

final class BookmarkViewController: ViewController, BookmarkViewControllable {
  
  private let controller: BookmarkControllable
  
  init(controller: BookmarkControllable) {
    self.controller = controller
    super.init(nibName: nil, bundle: nil)
    self.view.backgroundColor = .systemBackground
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
