import UIKit
import TinyConstraints

final class LoadMoreCell: UICollectionViewCell {
  
  static var defaultHeight: CGFloat { return 44 }
  
  private weak var activityIndicatorView: UIActivityIndicatorView?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    let activityIndicatorView = UIActivityIndicatorView(style: .medium)
    self.contentView.addSubview(activityIndicatorView)
    self.activityIndicatorView = activityIndicatorView
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func startLoadingAnimation() {
    self.activityIndicatorView?.startAnimating()
  }
}
