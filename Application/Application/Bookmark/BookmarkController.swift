import Combine
import Usecase

public protocol BookmarkDependency {
  var bookmarkImageUsecase: BookmarkImageUsecase { get }
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
  let observableState: ObservableState<BookmarkState>
  let observableEvent: ObservableEvent<BookmarkEvent>
  weak var viewController: BookmarkViewControllable?
  weak var listener: BookmarkListener?
  
  init(dependency: BookmarkDependency) {
    self.dependency = dependency
    let initialState = BookmarkState()
    self.stateSubject = CurrentValueSubject(initialState)
    self.eventSubject = PassthroughSubject()
    self.observableState = ObservableState(subject: self.stateSubject)
    self.observableEvent = ObservableEvent(subject: self.eventSubject)
  }
}
