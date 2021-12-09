import Combine
import Foundation
import Entity
import Usecase

protocol ImageViewerViewControllable: ViewControllable {
  
}

final class ImageViewerController: ImageViewerControllable {

  private var state: ImageViewerState {
    didSet { self.viewState.send(.stateArrived(self.state)) }
  }
  private let viewState: CurrentValueSubject<ImageViewerViewState, Never>
  
  private let recentImageUsecase: RecentImageUsecase
  private let shareBuilder: ShareBuildable
  private let alertBuilder: AlertBuildable
  
  private weak var viewController: ImageViewerViewControllable?
  private weak var listener: ImageViewerListener?
  
  init(searchedImage: SearchedImage, dependency: ImageViewerDependency, listener: ImageViewerListener?) {
    self.state = ImageViewerState(searchedImage: searchedImage)
    self.recentImageUsecase = dependency.recentImageUsecase
    self.shareBuilder = dependency.shareBuilder()
    self.alertBuilder = dependency.alertBuilder()
    self.viewState = CurrentValueSubject<ImageViewerViewState, Never>(.stateArrived(self.state))
    self.listener = listener
  }
  
  func activate(with viewController: ImageViewerViewControllable) -> Observable<ImageViewerViewState> {
    defer {
      self.didBecomActive()
    }
    self.viewController = viewController
    return self.viewState.eraseToAnyPublisher()
  }
  
  private func didBecomActive() {
    try? self.recentImageUsecase.insert(
      name: self.state.searchedImage.displayName,
      url: self.state.searchedImage.url
    )
  }
  
  func handleShareImage() {
    guard let url = self.state.searchedImage.url, let data = try? Data(contentsOf: url) else {
      let title = Resource.string("imageViewer:error")
      let target = self.alertBuilder.build(title: title, message: nil)
      self.viewController?.present(viewControllable: target, animated: true, completion: nil)
      return
    }
    let target = self.shareBuilder.build(data: data)
    self.viewController?.present(viewControllable: target, animated: true, completion: nil)
  }
}
