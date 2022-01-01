import Combine
import Foundation
import Entity
import Usecase

public protocol ImageViewerDependency {
  var recentImageUsecase: RecentImageUsecase { get }
  func shareBuilder() -> ShareBuildable
  func alertBuilder() -> AlertBuildable
}

public protocol ImageViewerListener: AnyObject {
  
}

protocol ImageViewerViewControllable: ViewControllable {
  
}

final class ImageViewerController: ImageViewerControllable {

  private let dependency: ImageViewerDependency
  private let stateSubject: CurrentValueSubject<ImageViewerState, Never>
  private let eventSubject: PassthroughSubject<ImageViewerEvent, Never>
  private var state: ImageViewerState {
    get { self.stateSubject.value }
    set { self.stateSubject.send(newValue) }
  }
  let observableState: ObservableState<ImageViewerState>
  let observableEvent: ObservableEvent<ImageViewerEvent>
  private weak var listener: ImageViewerListener?
  private weak var viewController: ImageViewerViewControllable?
  
  init(searchedImage: SearchedImage, dependency: ImageViewerDependency, listener: ImageViewerListener?) {
    self.dependency = dependency
    let initialState = ImageViewerState(searchedImage: searchedImage)
    self.stateSubject = CurrentValueSubject(initialState)
    self.eventSubject = PassthroughSubject()
    self.observableState = ObservableState(subject: self.stateSubject)
    self.observableEvent = ObservableEvent(subject: self.eventSubject)
    self.listener = listener
  }
  
  func activate(with viewController: ImageViewerViewControllable) {
    self.viewController = viewController
    try? self.dependency.recentImageUsecase.insert(
      name: self.state.searchedImage.displayName,
      url: self.state.searchedImage.url
    )
  }
  
  func handleShareImage() {
    guard let url = self.state.searchedImage.url, let data = try? Data(contentsOf: url) else {
      let title = Resource.string("imageViewer:error")
      let builder = self.dependency.alertBuilder()
      let target = builder.build(title: title, message: nil)
      self.viewController?.present(viewControllable: target, animated: true, completion: nil)
      return
    }
    let builder = self.dependency.shareBuilder()
    let target = builder.build(data: data)
    self.viewController?.present(viewControllable: target, animated: true, completion: nil)
  }
}
