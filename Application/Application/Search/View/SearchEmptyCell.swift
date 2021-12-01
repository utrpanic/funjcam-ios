import UIKit
import TinyConstraints

final class SearchEmptyCell: UICollectionViewCell {
  
  private weak var emptyLabel: UILabel?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    let emptyLabel = UILabel()
    emptyLabel.text = Resource.string("search:noResult")
    self.contentView.addSubview(emptyLabel)
    emptyLabel.centerInSuperview()
    self.emptyLabel = emptyLabel
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
    if let superViewSize = self.superview?.frame.size {
      let targetSize = superViewSize
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
}
