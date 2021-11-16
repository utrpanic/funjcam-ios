import Combine
import UIKit
import BoxKit
import CHTCollectionViewWaterfallLayout
import Domain
import Entity
import ReactorKit
import RxSwift
import TinyConstraints

protocol SearchControllable {
  func activate(with viewController: SearchViewControllable) -> Observable<SearchState>
  func searchTapped()
  func searchProviderChanged(to newValue: SearchProvider)
}

final class SearchViewController: ViewController, SearchViewControllable, HasScrollView, UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout, SearchHeaderCellDelegate {
  
  enum Section: Int, CaseIterable {
    case header
    case image
    case more
    case empty
  }
  
  private weak var containerView: UIView?
  private weak var textField: UITextField?
  private weak var collectionView: UICollectionView?
  var scrollView: UIScrollView? { self.collectionView }
  
  private let reactor: SearchReactor
  private var state: SearchReactor.State { self.reactor.currentState }
  private var disposeBag: DisposeBag
  
  private let controller: SearchControllable
  private var cancellables: Set<AnyCancellable>
  private var images: [SearchedImage]
  
  init(controller: SearchControllable) {
    self.controller = controller
    self.reactor = SearchReactor()
    self.disposeBag = DisposeBag()
    self.cancellables = Set<AnyCancellable>()
    self.images = []
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .systemBackground
    self.setupTextField()
    self.setupCollectionView()
    self.observeController()
  }
  
  private func setupTextField() {
    let containerView = UIView()
    self.view.addSubview(containerView)
    containerView.topToSuperview(usingSafeArea: true)
    containerView.leadingToSuperview()
    containerView.trailingToSuperview()
    containerView.height(44)
    self.containerView = containerView
    let textField = UITextField()
    textField.autocapitalizationType = .none
    textField.autocorrectionType = .no
    textField.placeholder = self.state.query
    containerView.addSubview(textField)
    let insets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    textField.edgesToSuperview(insets: insets)
    textField.addTarget(self, action: #selector(searchQueryChanged), for: .editingChanged)
    textField.addTarget(self, action: #selector(searchButtonTapped), for: .primaryActionTriggered)
    self.textField = textField
  }
  
  private func setupCollectionView() {
    guard let containerView = self.containerView else { return }
    let layout = CHTCollectionViewWaterfallLayout()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.registerFromClass(SearchHeaderCell.self)
    collectionView.registerFromClass(SearchResultCell.self)
    collectionView.registerFromClass(LoadMoreCell.self)
    collectionView.registerFromClass(SearchEmptyCell.self)
    self.view.addSubview(collectionView)
    collectionView.topToBottom(of: containerView)
    collectionView.edgesToSuperview(excluding: [.top])
    self.collectionView = collectionView
  }
  
  private func observeController() {
    self.controller.activate(with: self)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] state in
        self?.images = state.images
        self?.refreshViews()
      }.store(in: &self.cancellables)
    self.reactor.state.subscribe(onNext: { [weak self] (state) in
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
    self.collectionView?.reloadData()
  }
  
  @objc private func searchQueryChanged() {
    let query = self.textField?.text ?? ""
    self.reactor.action.onNext(.searchQueryUpdated(query))
  }
  
  @objc private func searchButtonTapped() {
    self.view.endEditing(true)
    self.controller.searchTapped()
  }
  
  // MARK: - UICollectionViewDataSource
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return Section.allCases.count
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    switch Section(rawValue: indexPath.section)! {
    case .header:
      let cell = collectionView.dequeueReusableCell(SearchHeaderCell.self, for: indexPath)
      let provider = Settings.shared.searchProvider.name
      cell.configure(with: provider, searchingGif: self.state.searchingGif)
      cell.delegate = self
      return cell
    case .image:
      let cell = collectionView.dequeueReusableCell(SearchResultCell.self, for: indexPath)
      cell.configure(searchedImage: self.images[indexPath.item])
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
  
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    switch Section(rawValue: indexPath.section)! {
    case .more:
      if self.state.hasMore {
        self.reactor.action.onNext(.searchMore)
      }
    default:
      break
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, columnCountFor section: Int) -> Int {
    switch Section(rawValue: section)! {
    case .header:
      return 1
    case .image:
      return 2
    case .more, .empty:
      return 1
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    switch Section(rawValue: indexPath.section)! {
    case .header:
      return CGSize(width: collectionView.frame.width, height: SearchHeaderCell.height)
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
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingFor section: Int) -> CGFloat {
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
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    switch Section(rawValue: indexPath.section)! {
    case .image:
      if let image = (collectionView.cellForItem(at: indexPath) as? SearchResultCell)?.imageView?.image {
        let viewController = ImageViewerViewController(thumbnail: image, searchedImage: self.state.images[indexPath.item])
        let navigationController = NavigationController(rootViewController: viewController)
        self.present(navigationController, animated: true, completion: nil)
      }
    default:
      // do nothing.
      break
    }
  }
  
  // MARK: - SearchHeaderGridCellDelegate
  func searchProviderButtonDidTap() {
    let alertController = UIAlertController(title: Resource.string("provider:searchProvider"), message: nil, preferredStyle: .actionSheet)
    SearchProvider.allCases.forEach { provider in
      alertController.addAction(UIAlertAction(title: provider.name, style: .default, handler: { [weak self] (action) in
        self?.controller.searchProviderChanged(to: provider)
      }))
    }
    alertController.addAction(UIAlertAction(title: Resource.string("common:cancel"), style: .cancel, handler: nil))
    self.present(alertController, animated: true, completion: nil)
  }
  
  func searchingGifButtonDidTap() {
    self.reactor.action.onNext(.toggleGif)
    self.reactor.action.onNext(.search)
  }
}

extension SearchProvider {
  var name: String {
    switch self {
    case .daum: return Resource.string("provider:daum")
    case .naver: return Resource.string("provider:naver")
    case .google: return Resource.string("provider:google")
    }
  }
}
