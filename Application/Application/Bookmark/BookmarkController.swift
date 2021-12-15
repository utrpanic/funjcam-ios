protocol BookmarkViewControllable: ViewControllable {
  
}

final class BookmarkController: BookmarkControllable {
  
  weak var viewController: BookmarkViewControllable?
  weak var listener: BookmarkListener?
  
  init(dependency: BookmarkDependency, listener: BookmarkListener?) {
    self.listener = listener
  }
}
