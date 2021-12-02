import Combine
import UIKit
import BoxKit
import Entity
import TinyConstraints
import SwiftUI

protocol SearchControllable {
  func activate(with viewController: SearchViewControllable) -> Observable<SearchViewState>
  func handleUpdateQuery(_ query: String?)
  func handleSearch(query: String?)
  func handleSearchMore()
  func handleToggleGIF()
  func handleChangeSearchProvider(to newValue: SearchProvider)
}

final class SearchViewController: ViewController, SearchViewControllable, HasScrollView, UICollectionViewDataSource, UICollectionViewDelegate {
  
  enum Section: Int, CaseIterable {
    case image
    case more
    case empty
  }
  
  private weak var containerView: UIView?
  private weak var textField: UITextField?
  private weak var headerView: UIView?
  private weak var providerButton: UIButton?
  private weak var searchAnimatedGIFButton: UIButton?
  private weak var collectionView: UICollectionView?
  var scrollView: UIScrollView? { self.collectionView }
  private weak var loadingView: UIActivityIndicatorView?
  
  private var state: SearchState
  private let controller: SearchControllable
  private var cancellables: Set<AnyCancellable>
  
  init(initialState: SearchState, controller: SearchControllable) {
    self.state = initialState
    self.controller = controller
    self.cancellables = Set<AnyCancellable>()
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .systemBackground
    self.setupTextField()
    self.setupHeaderView()
    self.setupCollectionView()
    self.setupLoadingView()
    self.observeController()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.textField?.becomeFirstResponder()
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
  
  private func setupHeaderView() {
    guard let upperView = self.containerView else { return }
    let headerView = UIView()
    self.view.addSubview(headerView)
    headerView.topToBottom(of: upperView)
    headerView.leadingToSuperview()
    headerView.trailingToSuperview()
    headerView.height(44)
    self.headerView = headerView
    let providerButton = UIButton(type: .system)
    providerButton.addTarget(self, action: #selector(searchProviderButtonTapped), for: .touchUpInside)
    headerView.addSubview(providerButton)
    providerButton.leadingToSuperview(offset: 8)
    providerButton.centerYToSuperview()
    self.providerButton = providerButton
    let searchAnimatedGIFButton = UIButton(type: .system)
    let gif = Resource.string("search:gif")
    searchAnimatedGIFButton.setTitle(gif, for: .normal)
    searchAnimatedGIFButton.addTarget(self, action: #selector(searchAnimatedGIFButtonTapped), for: .touchUpInside)
    headerView.addSubview(searchAnimatedGIFButton)
    searchAnimatedGIFButton.trailingToSuperview(offset: 8)
    searchAnimatedGIFButton.centerYToSuperview()
    self.searchAnimatedGIFButton = searchAnimatedGIFButton
    self.updateHeaderView()
  }
  
  private func updateHeaderView() {
    self.providerButton?.setTitle(self.state.provider.name, for: .normal)
    self.searchAnimatedGIFButton?.isSelected = self.state.searchAnimatedGIF
  }
  
  private func setupCollectionView() {
    guard let upperView = self.headerView else { return }
    let layout = self.generateCollectionViewLayout()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.registerFromClass(SearchImageCell.self)
    collectionView.registerFromClass(SearchMoreCell.self)
    collectionView.registerFromClass(SearchEmptyCell.self)
    self.view.addSubview(collectionView)
    collectionView.topToBottom(of: upperView)
    collectionView.edgesToSuperview(excluding: [.top])
    self.collectionView = collectionView
  }
  
  private func generateCollectionViewLayout() -> UICollectionViewLayout {
    let configuration = UICollectionViewCompositionalLayoutConfiguration()
    return UICollectionViewCompositionalLayout(
      sectionProvider:  { [weak self] sectionIndex, layoutEnvironment -> NSCollectionLayoutSection? in
        switch Section.allCases[sectionIndex] {
        case .image:
          return self?.generateImageLayoutSection()
        case .more:
          return self?.generateMoreLayoutSection()
        case .empty:
          return self?.generateEmptyLayoutSection()
        }
      },
      configuration: configuration)
  }
  
  private func generateImageLayoutSection() -> NSCollectionLayoutSection {
    let item = NSCollectionLayoutItem(
      layoutSize: NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .fractionalHeight(1.0)
      )
    )
    item.contentInsets = NSDirectionalEdgeInsets(top: 0.5, leading: 0.5, bottom: 0.5, trailing: 0.5)
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .fractionalWidth(0.6)
    )
    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: groupSize,
      subitem: item,
      count: 2
    )
    return NSCollectionLayoutSection(group: group)
  }
  
  private func generateMoreLayoutSection() -> NSCollectionLayoutSection {
    let item = NSCollectionLayoutItem(
      layoutSize: NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .fractionalHeight(1.0)
      )
    )
    let group = NSCollectionLayoutGroup.vertical(
      layoutSize: NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .estimated(44.0)
      ),
      subitems: [item]
    )
    return NSCollectionLayoutSection(group: group)
  }
  
  private func generateEmptyLayoutSection() -> NSCollectionLayoutSection {
    let item = NSCollectionLayoutItem(
      layoutSize: NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .fractionalHeight(1.0)
      )
    )
    let group = NSCollectionLayoutGroup.vertical(
      layoutSize: NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .fractionalHeight(1.0)
      ),
      subitems: [item]
    )
    return NSCollectionLayoutSection(group: group)
  }
  
  private func setupLoadingView() {
    guard let upperView = self.headerView else { return }
    let loadingView = UIActivityIndicatorView(style: .medium)
    loadingView.backgroundColor = .systemBackground
    loadingView.alpha = 0
    loadingView.isHidden = true
    self.view.addSubview(loadingView)
    loadingView.edgesToSuperview(excluding: [.top])
    loadingView.topToBottom(of: upperView)
    self.loadingView = loadingView
  }
  
  private func updateLoadingView(loading: Bool) {
    if loading {
      self.loadingView?.isHidden = false
      self.loadingView?.startAnimating()
      UIView.animate(withDuration: 0.2) { [weak self] in
        self?.loadingView?.alpha = 1
      }
    } else {
      UIView.animate(withDuration: 0.2) { [weak self] in
        self?.loadingView?.alpha = 0
      } completion: { [weak self] _ in
        self?.loadingView?.stopAnimating()
        self?.loadingView?.isHidden = true
      }
    }
  }
  
  private func observeController() {
    self.controller.activate(with: self)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] viewState in
        switch viewState {
        case let .loading(loading):
          self?.updateLoadingView(loading: loading)
        case let .stateArrived(state):
          self?.state = state
          self?.updateViews()
        case let .errorArrived(error):
          self?.handleError(error)
        }
      }.store(in: &self.cancellables)
  }
  
  private func updateViews() {
    self.updateHeaderView()
    self.collectionView?.reloadData()
  }
  
  private func handleError(_ error: SearchError) {
    switch error {
    case .search:
      self.showOkAlert(title: "이미지 검색에 실패했습니다.", message: nil, onOk: nil)
    case .searchMore:
      self.showOkAlert(title: "이미지 더 불러오기에 실패했습니다.", message: nil, onOk: nil)
    }
  }
  
  @objc private func searchQueryChanged() {
    let query = self.textField?.text
    self.controller.handleUpdateQuery(query)
  }
  
  @objc private func searchButtonTapped() {
    self.view.endEditing(true)
    let query = self.textField?.text
    self.controller.handleSearch(query: query)
  }
  
  @objc private func searchProviderButtonTapped() {
    let alertController = UIAlertController(title: Resource.string("provider:searchProvider"), message: nil, preferredStyle: .actionSheet)
    SearchProvider.allCases.forEach { provider in
      alertController.addAction(UIAlertAction(title: provider.name, style: .default, handler: { [weak self] (action) in
        self?.controller.handleChangeSearchProvider(to: provider)
      }))
    }
    alertController.addAction(UIAlertAction(title: Resource.string("common:cancel"), style: .cancel, handler: nil))
    self.present(alertController, animated: true, completion: nil)
  }
  
  @objc private func searchAnimatedGIFButtonTapped() {
    self.controller.handleToggleGIF()
  }
  
  // MARK: - UICollectionViewDataSource
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return Section.allCases.count
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch Section.allCases[section] {
    case .image:
      return self.state.images.count
    case .more:
      return self.state.hasMore ? 1 : 0
    case .empty:
      return self.state.images.isEmpty ? 1 : 0
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    switch Section.allCases[indexPath.section] {
    case .image:
      let cell = collectionView.dequeueReusableCell(SearchImageCell.self, for: indexPath)
      cell.configure(with: self.state.images[indexPath.item])
      return cell
    case .more:
      let cell = collectionView.dequeueReusableCell(SearchMoreCell.self, for: indexPath)
      cell.startLoadingAnimation()
      return cell
    case .empty:
      let cell = collectionView.dequeueReusableCell(SearchEmptyCell.self, for: indexPath)
      return cell
    }
  }
  
  // MARK: - UICollectionViewDelegate
  
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    switch Section.allCases[indexPath.section] {
    case .more:
      self.controller.handleSearchMore()
    default:
      break
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    switch Section(rawValue: indexPath.section)! {
    case .image:
      if let image = (collectionView.cellForItem(at: indexPath) as? SearchImageCell)?.imageView?.image {
        let viewController = ImageViewerViewController(thumbnail: image, searchedImage: self.state.images[indexPath.item])
        let navigationController = NavigationController(rootViewController: viewController)
        self.present(navigationController, animated: true, completion: nil)
      }
    default:
      // Do nothing.
      break
    }
  }
}

extension SearchedImage {
  var proportionalHeight: CGFloat {
    return CGFloat(self.pixelHeight) / CGFloat(self.pixelWidth)
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
