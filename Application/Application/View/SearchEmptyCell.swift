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
}
