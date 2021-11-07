import UIKit
import TinyConstraints

protocol SearchHeaderCellDelegate: AnyObject {
  func searchProviderButtonDidTap()
  func searchingGifButtonDidTap()
}

class SearchHeaderCell: UICollectionViewCell {
  
  static var height: CGFloat { return 44 }
  
  private weak var providerButton: UIButton!
  private weak var gifButton: UIButton!
  
  weak var delegate: SearchHeaderCellDelegate?

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupProviderButton()
    self.setupGIFButton()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupProviderButton() {
    let providerButton = UIButton(type: .system)
    providerButton.addTarget(self, action: #selector(providerButtonDidTap), for: .touchUpInside)
    self.contentView.addSubview(providerButton)
    providerButton.leadingToSuperview(offset: 8)
    providerButton.centerYToSuperview()
    self.providerButton = providerButton
  }
  
  private func setupGIFButton() {
    let gifButton = UIButton(type: .system)
    let gif = Resource.string("search:gif")
    gifButton.setTitle(gif, for: .normal)
    gifButton.addTarget(self, action: #selector(gifButtonDidTap), for: .touchUpInside)
    self.contentView.addSubview(gifButton)
    gifButton.trailingToSuperview(offset: 8)
    gifButton.centerYToSuperview()
    self.gifButton = gifButton
  }
  
  func configure(with name: String, searchingGif: Bool) {
    self.providerButton?.setTitle(name, for: .normal)
    self.gifButton?.isSelected = searchingGif
  }
  
  @objc private func providerButtonDidTap() {
    self.delegate?.searchProviderButtonDidTap()
  }
  
  @objc private func gifButtonDidTap() {
    self.delegate?.searchingGifButtonDidTap()
  }
}
