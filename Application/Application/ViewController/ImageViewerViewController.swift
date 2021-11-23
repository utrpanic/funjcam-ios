import UIKit
import BoxKit
import Entity

final class ImageViewerViewController: ViewController {
  
  private weak var imageView: UIImageView?
  
  var thumbnail: UIImage?
  var searchedImage: SearchedImage
  
  init(thumbnail: UIImage?, searchedImage: SearchedImage) {
    self.thumbnail = thumbnail
    self.searchedImage = searchedImage
    super.init(nibName: nil, bundle: nil)
    self.view.backgroundColor = .systemBackground
    self.setupNavigation()
    self.setupImageViewer()
    self.updateImageViewer()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
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
    imageView.image = self.thumbnail
    self.view.addSubview(imageView)
    imageView.edgesToSuperview()
    self.imageView = imageView
  }
  
  private func updateImageViewer() {
    self.imageView?.setImage(url: self.searchedImage.url) { [weak self] (image) -> Void in
      if let url = self?.searchedImage.url, image == nil {
        Log.e("Image Download Failure: \(url)")
      }
    }
  }
  
  @objc private func closeButtonDidTap() {
    self.dismiss(animated: true, completion: nil)
  }
  
  @objc private func shareButtonDidTap() {
    guard let url = self.searchedImage.url, let data = try? Data(contentsOf: url) else {
      let error = Resource.string("imageViewer:error")
      self.showOkAlert(title: error, message: nil, onOk: nil)
      return
    }
    let viewController = UIActivityViewController(activityItems: [data], applicationActivities: nil)
    self.present(viewController, animated: true, completion: nil)
  }
}
