import Combine
import UIKit
import BoxKit
import Entity

protocol ImageViewerControllable {
  func activate(with viewController: ImageViewerViewControllable) -> Observable<ImageViewerViewState>
  func handleShareImage()
}

final class ImageViewerViewController: ViewController, ImageViewerViewControllable {
  
  private weak var imageView: UIImageView?
  
  private var controller: ImageViewerControllable
  private var cancellables: Set<AnyCancellable>
  
  init(controller: ImageViewerControllable) {
    self.controller = controller
    self.cancellables = Set<AnyCancellable>()
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .systemBackground
    self.setupNavigation()
    self.setupImageViewer()
    self.observeController()
  }
  
  private func setupNavigation() {
    let close = Resource.string("common:close")
    let closeButton = UIBarButtonItem(title: close, style: .plain, target: self, action: #selector(closeButtonDidTap))
    self.navigationItem.leftBarButtonItem = closeButton
    
    let share = Resource.string("imageViewer:share")
    let shareButton = UIBarButtonItem(title: share, style: .plain, target: self, action: #selector(shareButtonDidTap))
    self.navigationItem.rightBarButtonItem = shareButton
  }
  
  private func setupImageViewer() {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    self.view.addSubview(imageView)
    imageView.edgesToSuperview()
    self.imageView = imageView
  }
  
  private func observeController() {
    self.controller.activate(with: self)
      .sink { [weak self] viewState in
        switch viewState {
        case let .stateArrived(state):
          self?.updateImageViewer(imageURL: state.searchedImage.url)
        case .errorArrived(_):
          break
        case .loading(_):
          break
        }
      }
      .store(in: &(self.cancellables))
  }
  
  private func updateImageViewer(imageURL: URL?) {
    self.imageView?.setImage(url: imageURL) { (image) -> Void in
      if let url = imageURL, image == nil {
        Log.e("Image Download Failure: \(url)")
      }
    }
  }
  
  @objc private func closeButtonDidTap() {
    self.dismiss(animated: true, completion: nil)
  }
  
  @objc private func shareButtonDidTap() {
    self.controller.handleShareImage()
  }
}
