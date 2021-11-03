import UIKit

import Kingfisher

extension UIImage {
  
  class func getImage(color: UIColor) -> UIImage {
    // width, height에 원래는 0.5를 줬었는데, 3x디바이스에서 다른 이미지가 나옴.
    let size = CGSize(width: 1 / UIScreen.main.scale, height: 1 / UIScreen.main.scale)
    let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
    color.setFill()
    UIRectFill(rect)
    let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return image
  }
}

extension UIImageView {
  
  func setImage(url: String?, placeholder: UIImage?, completion: ((UIImage?) -> Void)?) {
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
    self.navigationBar.setBackgroundImage(App.Image.transparent, for: .default)
    self.navigationBar.shadowImage = App.Image.transparent
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
