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
  
  private var cancellables: Set<AnyCancellable>
  
  init(dependency: BookmarkDependency, listener: BookmarkListener?) {
    self.dependency = dependency
    let initialState = BookmarkState(images: [])
    self.stateSubject = CurrentValueSubject(initialState)
    self.eventSubject = PassthroughSubject()
    self.listener = listener
    self.cancellables = Set()
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
    usecase.query()
      .sink { [weak self] completion in
        if case let .failure(error) = completion {
          let title = String(describing: error)
          let message = error.localizedDescription
          self?.routeToAlert(title: title, message: message)
        }
      } receiveValue: { [weak self] images in
        self?.state.images = images
      }
      .store(in: &(self.cancellables))
  }
  
  private func routeToAlert(title: String, message: String) {
    let builder = self.dependency.alertBuilder()
    let viewController = builder.build(title: title, message: message)
    self.viewController?.present(viewControllable: viewController, animated: true)
  }
}
