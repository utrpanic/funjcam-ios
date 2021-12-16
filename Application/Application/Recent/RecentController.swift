import Entity
import Usecase
import Combine

protocol RecentViewControllable: ViewControllable {
  
}

final class RecentController: RecentControllable {
  
  private let recentImageUsecase: RecentImageUsecase

  private let stateSubject: CurrentValueSubject<RecentState, Never>
  private var state: RecentState {
    get { self.stateSubject.value }
    set { self.stateSubject.send(newValue) }
  }
  let observableState: ObservableState<RecentState>
  private let eventSubject: PassthroughSubject<RecentEvent, Never>
  let observableEvent: ObservableEvent<RecentEvent>
  weak var viewController: RecentViewControllable?
  private weak var listener: RecentListener?
  
  init(dependency: RecentDependency, listener: RecentListener?) {
    self.recentImageUsecase = dependency.recentImageUsecase
    let initialState = RecentState(images: [])
    self.stateSubject = CurrentValueSubject(initialState)
    self.observableState = ObservableState(subject: self.stateSubject)
    self.eventSubject = PassthroughSubject()
    self.observableEvent = ObservableEvent(subject: self.eventSubject)
    self.listener = listener
    self.requestRecentImages()
  }
  
  private func requestRecentImages() {
    do {
      let recentImages = try self.recentImageUsecase.query()
      self.state.images = recentImages
    } catch {
      self.eventSubject.send(.errorRequestRecentImage(error))
    }
  }
  
  func handleSelectImage(at index: Int) {
    
  }
}
