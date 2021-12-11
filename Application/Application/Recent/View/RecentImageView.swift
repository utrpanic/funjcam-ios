import UIKit
import Entity
import TinyConstraints

final class RecentImageCell: UICollectionViewCell {
  
  private weak var imageView: UIImageView?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
    if let superViewSize = self.superview?.frame.size {
      let targetSize = CGSize(width: superViewSize.width, height: 176)
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
  
  private func setupView() {
    let imageView = UIImageView()
    imageView.contentMode = .scaleToFill
    self.contentView.addSubview(imageView)
    imageView.edgesToSuperview(excluding: [.trailing])
    imageView.width(88)
    self.imageView = imageView
  }
  
  func configure(with image: RecentImage) {
    self.imageView?.setImage(url: image.url, placeholder: nil, completion: nil)
  }
}
