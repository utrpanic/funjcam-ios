import UIKit
import Kingfisher

extension UIImageView {
  
  func setImage(url: String?, placeholder: UIImage? = nil, completion: ((UIImage?) -> Void)?) {
    let safeURL = URL.safeVersion(from: url)
    self.kf.setImage(with: safeURL, placeholder: placeholder, options: [.transition(.fade(0.2))], progressBlock: nil) { result in
      switch result {
      case .success(let value):
        completion?(value.image)
      case .failure(_):
        completion?(nil)
      }
    }
  }
}

extension UINavigationController {
  func updateNavigationBarAsTransparent() {
    let transparentImage = Resource.image(color: .clear)
    self.navigationBar.setBackgroundImage(transparentImage, for: .default)
    self.navigationBar.shadowImage = transparentImage
  }
}

extension UIViewController {
  func showOkAlert(title: String?, message: String?, okText: String = "Ok", onOk: (() -> Void)?) {
    let viewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: okText, style: .default, handler: { (action) in
      onOk?()
    })
    viewController.addAction(okAction)
    self.present(viewController, animated: true, completion: nil)
  }
}
