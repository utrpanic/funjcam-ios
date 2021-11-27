import UIKit
import TinyConstraints

final class SearchMoreCell: UICollectionViewCell {
  
  private weak var activityIndicatorView: UIActivityIndicatorView?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    let activityIndicatorView = UIActivityIndicatorView(style: .medium)
    self.contentView.addSubview(activityIndicatorView)
    activityIndicatorView.centerInSuperview()
    self.activityIndicatorView = activityIndicatorView
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
    if let superViewSize = self.superview?.frame.size {
      let targetSize = CGSize(width: superViewSize.width, height: 44)
      layoutAttributes.frame.size = self.contentView.systemLayoutSizeFitting(
        targetSize,
        withHorizontalFittingPriority: .required,
        verticalFittingPriority: .fittingSizeLevel
      )
      return layoutAttributes
    } else {
      return super.preferredLayoutAttributesFitting(layoutAttributes)
    }
  }
  
  func startLoadingAnimation() {
    self.activityIndicatorView?.startAnimating()
  }
}
