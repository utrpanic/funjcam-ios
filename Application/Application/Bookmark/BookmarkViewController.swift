import UIKit

protocol BookmarkControllable {
  var observableState: ObservableState<BookmarkState> { get }
  var observableEvent: ObservableEvent<BookmarkEvent> { get }
}

final class BookmarkViewController: ViewController, BookmarkViewControllable {
  
  private let controller: BookmarkControllable
  
  init(controller: BookmarkControllable) {
    self.controller = controller
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .systemBackground
  }
}
