import Combine
import Usecase

public protocol BookmarkDependency {
  var bookmarkImageUsecase: BookmarkImageUsecase { get }
  func alertBuilder() -> AlertBuildable
}

public protocol BookmarkListener: AnyObject {
  
}

protocol BookmarkViewControllable: ViewControllable {
  
}

final class BookmarkController: BookmarkControllable {
  
  private let dependency: BookmarkDependency
  private let stateSubject: CurrentValueSubject<BookmarkState, Never>
  private let eventSubject: PassthroughSubject<BookmarkEvent, Never>
  private var state: BookmarkState {
    get { self.stateSubject.value }
    set { self.stateSubject.send(newValue) }
  }
  private weak var listener: BookmarkListener?
  private weak var viewController: BookmarkViewControllable?
  
  init(dependency: BookmarkDependency, listener: BookmarkListener?) {
    self.dependency = dependency
    let initialState = BookmarkState(images: [])
    self.stateSubject = CurrentValueSubject(initialState)
    self.eventSubject = PassthroughSubject()
    self.listener = listener
  }
  
  // MARK: - BookmarkControllable
  
  lazy var observableState: ObservableState<BookmarkState> = {
    return ObservableState(subject: self.stateSubject)
  }()
  
  lazy var observableEvent: ObservableEvent<BookmarkEvent> = {
    return ObservableEvent(subject: self.eventSubject)
  }()
  
  func activate(with viewController: BookmarkViewControllable) {
    self.viewController = viewController
    self.requestBookmarks()
  }
  
  private func requestBookmarks() {
    let usecase = self.dependency.bookmarkImageUsecase
    do {
      self.state.images = try usecase.query()
    } catch {
      let builder = self.dependency.alertBuilder()
      let viewController = builder.build(title: "", message: "")
      self.viewController?.present(viewControllable: viewController, animated: true)
    }
  }
}
