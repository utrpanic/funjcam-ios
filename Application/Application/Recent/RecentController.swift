import Entity
import Usecase
import Combine

public protocol RecentDependency {
  var recentImageUsecase: RecentImageUsecase { get }
  func alertBuilder() -> AlertBuildable
}

public protocol RecentListener: AnyObject {
  
}

protocol RecentViewControllable: ViewControllable {
  
}

final class RecentController: RecentControllable {

  private let dependency: RecentDependency
  private let stateSubject: CurrentValueSubject<RecentState, Never>
  private let eventSubject: PassthroughSubject<RecentEvent, Never>
  private var state: RecentState {
    get { self.stateSubject.value }
    set { self.stateSubject.send(newValue) }
  }
  let observableState: ObservableState<RecentState>
  let observableEvent: ObservableEvent<RecentEvent>
  private weak var listener: RecentListener?
  private weak var viewController: RecentViewControllable?
  
  init(dependency: RecentDependency, listener: RecentListener?) {
    self.dependency = dependency
    let initialState = RecentState(images: [])
    self.stateSubject = CurrentValueSubject(initialState)
    self.eventSubject = PassthroughSubject()
    self.observableState = ObservableState(subject: self.stateSubject)
    self.observableEvent = ObservableEvent(subject: self.eventSubject)
    self.listener = listener
  }
  
  private func routeToAlert(title: String, message: String?) {
    let builder = self.dependency.alertBuilder()
    let alert = builder.build(title: title, message: message)
    self.viewController?.present(viewControllable: alert, animated: true)
  }
  
  func activate(with viewController: RecentViewControllable) {
    self.viewController = viewController
    self.requestRecentImages()
  }
  
  private func requestRecentImages() {
    do {
      let usecase = self.dependency.recentImageUsecase
      let recentImages = try usecase.query()
      self.state = RecentState(images: recentImages)
    } catch {
      self.routeToAlert(
        title: "Request Recent Images",
        message: error.localizedDescription
      )
    }
  }
  
  func handleSelectImage(at index: Int) {
    
  }
}
