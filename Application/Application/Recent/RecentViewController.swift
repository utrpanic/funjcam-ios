import Combine
import UIKit
import Entity

protocol RecentControllable {
  func activate(with viewController: RecentViewControllable) -> Observable<RecentState>
  func handleSelectImage(at index: Int)
}

final class RecentViewController: ViewController, RecentViewControllable, UICollectionViewDataSource, UICollectionViewDelegate {
  
  enum Section: Int, CaseIterable {
    case image
    case empty
  }
  
  private weak var collectinView: UICollectionView?
  
  private let controller: RecentControllable
  private var cancellables: Set<AnyCancellable>
  private var images: [RecentImage]
  
  init(controller: RecentControllable) {
    self.controller = controller
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
    self.setupCollectionView()
    self.observeController()
  }
  
  private func setupCollectionView() {
    var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
    configuration.separatorConfiguration.bottomSeparatorInsets = .zero
    let layout = UICollectionViewCompositionalLayout.list(using: configuration)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.registerFromClass(RecentImageCell.self)
    self.view.addSubview(collectionView)
    collectionView.edgesToSuperview(excluding: [.top])
    collectionView.topToSuperview(usingSafeArea: true)
    self.collectinView = collectionView
  }
  
  private func observeController() {
    self.controller.activate(with: self)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] state in
        switch state {
        case let .state(recentImages):
          self?.images = recentImages
          self?.collectinView?.reloadData()
        }
      }
      .store(in: &(self.cancellables))
  }
  
  // MARK: - UICollectionViewDataSource
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return Section.allCases.count
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch Section.allCases[section] {
    case .image: return self.images.count
    case .empty: return self.images.isEmpty ? 1 : 0
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    switch Section.allCases[indexPath.section] {
    case .image:
      let cell = collectionView.dequeueReusableCell(RecentImageCell.self, for: indexPath)
      cell.configure(with: self.images[indexPath.item])
      return cell
    case .empty:
      return collectionView.dequeueReusableCell(RecentEmptyCell.self, for: indexPath)
    }
  }
  
  // MARK: - UICollectionViewDelegate
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    switch Section.allCases[indexPath.section] {
    case .image:
      self.controller.handleSelectImage(at: indexPath.item)
    case .empty:
      break
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
    return false
  }
}
