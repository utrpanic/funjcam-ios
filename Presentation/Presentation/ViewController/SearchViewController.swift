import UIKit
import BoxKit
import CHTCollectionViewWaterfallLayout
import Domain
import ReactorKit
import RxSwift


extension SearchProvider {
  var name: String {
    switch self {
    case .daum: return Resource.string("provider:daum")
    case .naver: return Resource.string("provider:naver")
    case .google: return Resource.string("provider:google")
    }
  }
}

public final class SearchViewController: ViewController, NibLoadable, StoryboardView, HasScrollView, UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout, SearchHeaderGridCellDelegate {
  
  enum Section: Int, CaseIterable {
    case header
    case image
    case more
    case empty
  }
  
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var collectionView: UICollectionView!
  var scrollView: UIScrollView { return self.collectionView }
  
  public typealias Reactor = SearchReactor
  var state: SearchReactor.State! {
    return self.reactor!.currentState
  }
  public var disposeBag: DisposeBag = DisposeBag()
  
  public static func create() -> Self {
    let viewController = self.createFromStoryboard(name: "Main")
    viewController.reactor = SearchReactor()
    return viewController
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()

    self.setupTextField()

    self.setupCollectionView()
  }
  
  private func setupTextField() {
    self.textField.placeholder = self.state.query
  }
  
  private func setupCollectionView() {
    self.collectionView.dataSource = self
    self.collectionView.delegate = self
    self.collectionView.collectionViewLayout = CHTCollectionViewWaterfallLayout()
    self.collectionView.registerFromClass(SearchResultCell.self)
    self.collectionView.registerFromClass(LoadMoreCell.self)
    self.collectionView.registerFromClass(SearchEmptyCell.self)
  }
  
  @IBAction func searchQueryDidChange(_ sender: UITextField) {
    let query = sender.text ?? ""
    self.reactor?.action.onNext(.searchQueryUpdated(query))
  }
  
  @IBAction func searchDidTap(_ sender: UITextField) {
    self.reactor?.action.onNext(.search)
    self.view.endEditing(true)
  }
  
  public func bind(reactor: Reactor) {
    reactor.state.subscribe(onNext: { [weak self] (state) in
      guard let `self` = self else { return }
      switch state.viewAction {
      case .none:
        break
      case .refresh:
        self.refreshViews()
      case .searchBegin:
        break
      case let .searchError(code):
        self.showOkAlert(title: "이미지 검색에 실패했습니다.", message: "Code: \(code)", onOk: nil)
      case .searchEnd:
        break
      case .searchMoreBegin:
        break
      case let .searchMoreError(code):
        self.showOkAlert(title: "이미지 더 불러오기에 실패했습니다.", message: "Code: \(code)", onOk: nil)
      case .searchMoreEnd:
        break
      }
    }).disposed(by: self.disposeBag)
  }
  
  private func refreshViews() {
    self.collectionView.reloadData()
  }
  
  // MARK: - UICollectionViewDataSource
  public func numberOfSections(in collectionView: UICollectionView) -> Int {
    return Section.allCases.count
  }
  
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch Section(rawValue: section)! {
    case .header:
      return 1
    case .image:
      return self.state.images.count
    case .more:
      return self.state.hasMore ? 1 : 0
    case .empty:
      return self.state.images.isEmpty ? 1 : 0
    }
  }
  
  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    switch Section(rawValue: indexPath.section)! {
    case .header:
      let cell = collectionView.dequeueReusableCell(SearchHeaderGridCell.self, for: indexPath)
      let provider = Settings.shared.searchProvider.name
      cell.configure(with: provider, searchingGif: self.state.searchingGif)
      cell.delegate = self
      return cell
    case .image:
      let cell = collectionView.dequeueReusableCell(SearchResultCell.self, for: indexPath)
      cell.configure(searchedImage: self.state.images[indexPath.item])
      return cell
    case .more:
      let cell = collectionView.dequeueReusableCell(LoadMoreCell.self, for: indexPath)
      cell.startLoadingAnimation()
      return cell
    case .empty:
      let cell = collectionView.dequeueReusableCell(SearchEmptyCell.self, for: indexPath)
      return cell
    }
  }
  
  public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    switch Section(rawValue: indexPath.section)! {
    case .more:
      if self.state.hasMore {
        self.reactor?.action.onNext(.searchMore)
      }
    default:
      break
    }
  }
  
  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, columnCountFor section: Int) -> Int {
    switch Section(rawValue: section)! {
    case .header:
      return 1
    case .image:
      return 2
    case .more, .empty:
      return 1
    }
  }
  
  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    switch Section(rawValue: indexPath.section)! {
    case .header:
      return CGSize(width: collectionView.frame.width, height: SearchHeaderGridCell.height)
    case .image:
      let width: CGFloat = (collectionView.frame.width - 8 - 8 - 8) / 2
      let height: CGFloat = {
        let pixelWidth = CGFloat(self.state.images[indexPath.item].pixelWidth)
        let pixelHeight = CGFloat(self.state.images[indexPath.item].pixelHeight)
        return width * (pixelHeight / pixelWidth)
      }()
      return CGSize(width: width, height: height)
    case .more:
      return CGSize(width: collectionView.frame.width, height: LoadMoreCell.defaultHeight)
    case .empty:
      return collectionView.frame.size
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    switch Section(rawValue: section)! {
    case .image:
      return self.state.images.count > 0 ? UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8) : UIEdgeInsets.zero
    default:
      return UIEdgeInsets.zero
    }
  }
  
  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingFor section: Int) -> CGFloat {
    switch Section(rawValue: section)! {
    case .image:
      return 8
    default:
      return 0
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    switch Section(rawValue: section)! {
    case .image:
      return 8
    default:
      return 0
    }
  }
  
  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    switch Section(rawValue: indexPath.section)! {
    case .image:
      if let image = (collectionView.cellForItem(at: indexPath) as? SearchResultCell)?.imageView?.image {
        let viewController = ImageViewerViewController.create(image: image, searchedImage: self.state.images[indexPath.item])
        self.present(viewController, animated: true, completion: nil)
      }
    default:
      // do nothing.
      break
    }
  }
  
  // MARK: - SearchHeaderGridCellDelegate
  func searchProviderButtonDidTap() {
    let alertController = UIAlertController(title: Resource.string("provider:searchProvider"), message: nil, preferredStyle: .actionSheet)
    SearchProvider.all.forEach({
      let provider = $0
      alertController.addAction(UIAlertAction(title: provider.name, style: .default, handler: { [weak self] (action) in
        self?.reactor?.action.onNext(.setSearchProvider(provider))
        self?.reactor?.action.onNext(.search)
      }))
    })
    alertController.addAction(UIAlertAction(title: Resource.string("common:cancel"), style: .cancel, handler: nil))
    self.present(alertController, animated: true, completion: nil)
  }
  
  func searchingGifButtonDidTap() {
    self.reactor?.action.onNext(.toggleGif)
    self.reactor?.action.onNext(.search)
  }
}

protocol SearchHeaderGridCellDelegate: AnyObject {
  func searchProviderButtonDidTap()
  func searchingGifButtonDidTap()
}

class SearchHeaderGridCell: UICollectionViewCell, NibLoadable {
  
  static var height: CGFloat { return 44 }
  
  @IBOutlet weak var providerButton: UIButton!
  @IBOutlet weak var gifButton: UIButton!
  
  weak var delegate: SearchHeaderGridCellDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  func configure(with name: String, searchingGif: Bool) {
    self.providerButton.setTitle(name, for: .normal)
    self.gifButton.isSelected = searchingGif
  }
  
  @IBAction func providerButtonDidTap(_ sender: UIButton) {
    self.delegate?.searchProviderButtonDidTap()
  }
  
  @IBAction func gifButtonDidTap(_ sender: UIButton) {
    self.delegate?.searchingGifButtonDidTap()
  }
}
