import CHTCollectionViewWaterfallLayout
import RxSwift

class SearchViewController: FJViewController, NibLoadable, HasScrollView, UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout, SearchHeaderGridCellDelegate {
    
    enum Section: Int, CaseIterable {
        case header
        case image
        case more
        case empty
    }

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    var scrollView: UIScrollView { return self.collectionView }
    
    private var viewModel: SearchViewModel = SearchViewModel()
    private var disposeBag: DisposeBag = DisposeBag()
    
    static func create() -> Self {
        let viewController = self.create(storyboardName: "Main")!
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.setupTextField()
        
        self.setupCollectionView()
        
        self.observeViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setupTextField() {
        self.textField.placeholder = self.viewModel.query
    }
    
    private func setupCollectionView() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.collectionViewLayout = CHTCollectionViewWaterfallLayout()
        
        self.collectionView.registerFromNib(SearchedImageGridCell.self)
        self.collectionView.registerFromNib(LoadMoreGridCell.self)
        self.collectionView.registerFromNib(EmptySearchGridCell.self)
    }
    
    private func observeViewModel() {
        self.viewModel.updateStream.subscribe(onNext: { (code) in
            if code.isSucceed {
                self.collectionView.reloadData()
            } else {
                self.showOkAlert(title: "이미지 검색에 실패했습니다.", message: "Code: \(code)", onOk: nil)
            }
        }).disposed(by: self.disposeBag)
    }
    
    @IBAction func searchQueryDidChange(_ sender: UITextField) {
        self.viewModel.updateQuery(sender.text ?? "")
    }
    
    @IBAction func searchDidTap(_ sender: UITextField) {
        self.viewModel.search()
        self.view.endEditing(true)
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
            return self.viewModel.images.count
        case .more:
            return self.viewModel.hasMore ? 1 : 0
        case .empty:
            return self.viewModel.images.isEmpty ? 1 : 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch Section(rawValue: indexPath.section)! {
        case .header:
            let cell = collectionView.dequeueReusableCell(SearchHeaderGridCell.self, for: indexPath)
            let provider = Settings.shared.searchProvider.name
            cell.configure(with: provider, searchingGIF: self.viewModel.searchingGIF)
            cell.delegate = self
            return cell
        case .image:
            let cell = collectionView.dequeueReusableCell(SearchedImageGridCell.self, for: indexPath)
            cell.configure(searchedImage: self.viewModel.images[indexPath.item])
            return cell
        case .more:
            let cell = collectionView.dequeueReusableCell(LoadMoreGridCell.self, for: indexPath)
            cell.startLoadingAnimation()
            return cell
        case .empty:
            let cell = collectionView.dequeueReusableCell(EmptySearchGridCell.self, for: indexPath)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        switch Section(rawValue: indexPath.section)! {
        case .more:
            self.viewModel.searchMore()
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, columnCountForSection section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .header:
            return 1
        case .image:
            return 2
        case .more, .empty:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        switch Section(rawValue: indexPath.section)! {
        case .header:
            return CGSize(width: collectionView.frame.width, height: SearchHeaderGridCell.height)
        case .image:
            let width: CGFloat = (collectionView.frame.width - 8 - 8 - 8) / 2
            let height: CGFloat = {
                let pixelWidth = CGFloat(self.viewModel.images[indexPath.item].pixelWidth)
                let pixelHeight = CGFloat(self.viewModel.images[indexPath.item].pixelHeight)
                return width * (pixelHeight / pixelWidth)
            }()
            return CGSize(width: width, height: height)
        case .more:
            return CGSize(width: collectionView.frame.width, height: LoadMoreGridCell.defaultHeight)
        case .empty:
            return collectionView.frame.size
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        switch Section(rawValue: section)! {
        case .image:
            return self.viewModel.images.count > 0 ? UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8) : UIEdgeInsets.zero
        default:
            return UIEdgeInsets.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
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
            if let image = (collectionView.cellForItem(at: indexPath) as? SearchedImageGridCell)?.imageView.image {
                let viewController = ImageViewerViewController.create(image: image, searchedImage: self.viewModel.images[indexPath.item])
                self.present(viewController, animated: true, completion: nil)
            }
        default:
            // do nothing.
            break
        }
    }
    
    // MARK: - SearchHeaderGridCellDelegate
    func searchProviderButtonDidTap() {
        let alertController = UIAlertController(title: "provider:searchProvider".localized(), message: nil, preferredStyle: .actionSheet)
        SearchProvider.all.forEach({
            let provider = $0
            alertController.addAction(UIAlertAction(title: provider.name, style: .default, handler: { (action) in
                Settings.shared.searchProvider = provider
                self.viewModel.search()
            }))
        })
        alertController.addAction(UIAlertAction(title: "common:cancel".localized(), style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func searchingGIFButtonDidTap() {
        self.viewModel.toggleSearchingGIF()
        self.viewModel.search()
    }
}

protocol SearchHeaderGridCellDelegate: class {
    func searchProviderButtonDidTap()
    func searchingGIFButtonDidTap()
}

class SearchHeaderGridCell: UICollectionViewCell, NibLoadable {
    
    static var height: CGFloat { return 44 }
    
    @IBOutlet weak var providerButton: UIButton!
    @IBOutlet weak var gifButton: UIButton!
    
    weak var delegate: SearchHeaderGridCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with name: String, searchingGIF: Bool) {
        self.providerButton.setTitle(name, for: .normal)
        self.gifButton.isSelected = searchingGIF
    }
    
    @IBAction func providerButtonDidTap(_ sender: UIButton) {
        self.delegate?.searchProviderButtonDidTap()
    }
    
    @IBAction func gifButtonDidTap(_ sender: UIButton) {
        self.delegate?.searchingGIFButtonDidTap()
    }
}
