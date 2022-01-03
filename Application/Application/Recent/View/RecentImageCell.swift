import UIKit
import Entity
import TinyConstraints

final class RecentImageCell: UICollectionViewListCell {
  
  private weak var imageView: UIImageView?
  private weak var nameLabel: UILabel?
  private weak var fileNameLabel: UILabel?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupSubview()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    self.setupSubview()
  }
  
  override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
    let preferredHeight = CGFloat(176)
    let targetSize = CGSize(width: layoutAttributes.frame.width, height: preferredHeight)
    layoutAttributes.frame.size = self.contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
    return layoutAttributes
  }
  
  private func setupSubview() {
    let imageView = UIImageView()
    imageView.contentMode = .scaleToFill
    self.contentView.addSubview(imageView)
    imageView.edgesToSuperview(excluding: [.trailing])
    imageView.width(88)
    imageView.height(176)
    self.imageView = imageView
    let containerView = UIView()
    self.contentView.addSubview(containerView)
    containerView.leadingToTrailing(of: imageView, offset: 16)
    containerView.trailingToSuperview(offset: 16)
    containerView.centerYToSuperview()
    let nameLabel = UILabel()
    nameLabel.font = UIFont.preferredFont(forTextStyle: .title1)
    nameLabel.textColor = Resource.color("textPrimary")
    containerView.addSubview(nameLabel)
    nameLabel.edgesToSuperview(excluding: [.bottom])
    self.nameLabel = nameLabel
    let fileNameLabel = UILabel()
    fileNameLabel.font = UIFont.preferredFont(forTextStyle: .title2)
    fileNameLabel.textColor = Resource.color("textSecondary")
    containerView.addSubview(fileNameLabel)
    fileNameLabel.edgesToSuperview(excluding: [.top])
    fileNameLabel.topToBottom(of: nameLabel, offset: 8)
    self.fileNameLabel = fileNameLabel
  }
  
  func configure(with image: RecentImage) {
    self.nameLabel?.text = image.name
    self.fileNameLabel?.text = image.url?.lastPathComponent
    self.imageView?.setImage(url: image.url, placeholder: nil, completion: nil)
  }
}
