import UIKit
import Entity
import TinyConstraints

final class SearchImageCell: UICollectionViewCell {
  
  weak var imageView: UIImageView?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    super.awakeFromNib()
    self.setupImageView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
    
  private func setupImageView() {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.layer.borderColor = UIColor.black.withAlphaComponent(0.3).cgColor
    imageView.layer.borderWidth = 0.5
    self.contentView.addSubview(imageView)
    imageView.edgesToSuperview()
    self.imageView = imageView
  }
  
  func configure(with image: SearchedImage?) {
    self.imageView?.setImage(url: image?.thumbnailURL, placeholder: nil, completion: nil)
  }
}
