//
//  SearchViewController.swift
//  funjcam
//
//  Created by boxjeon on 2016. 7. 16..
//  Copyright © 2016년 boxjeon. All rights reserved.
//

import CHTCollectionViewWaterfallLayout

class SearchViewController: FJViewController, NibLoadable, HasScrollView, UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout, SearchHeaderGridCellDelegate {
    
    enum Section: Int {
        case header
        case image
        case more
        case empty
        static var all: [Section] { return [.header, .image, .more, .empty]}
    }

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    var scrollView: UIScrollView { return self.collectionView }
    
    var searchKeyword: String {
        if !(self.textField.text?.isEmpty ?? false) {
            return self.textField.text!
        } else if !(self.textField.placeholder?.isEmpty ?? false) {
            return self.textField.placeholder!
        } else {
            return ""
        }
    }
    var isGifOn: Bool = false
    var manager: SearchManager = SearchManager()
    
    static func create() -> Self {
        let viewController = self.create(storyboardName: "Main")!
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.setupTextField()
        
        self.setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setupTextField() {
        self.textField.placeholder = "효리네민박"
    }
    
    func setupCollectionView() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.collectionViewLayout = CHTCollectionViewWaterfallLayout()
        
        self.collectionView.registerFromNib(SearchedImageGridCell.self)
        self.collectionView.registerFromNib(LoadMoreGridCell.self)
        self.collectionView.registerFromNib(EmptySearchGridCell.self)
    }
    
    func requestImages() {
        self.manager.search(keyword: self.searchKeyword, gif: self.isGifOn) { [weak self] (code) in
            self?.collectionView.reloadData()
            self?.collectionView.contentOffset = .zero
        }
    }
    
    func requestMoreImages() {
        self.manager.searchMore { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    @IBAction func didSearchTap(_ sender: UITextField) {
        self.requestImages()
        self.view.endEditing(true)
    }
    
    // MARK: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.all.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .header:
            return 1
        case .image:
            return self.manager.images.count
        case .more:
            return self.manager.hasMore ? 1 : 0
        case .empty:
            return self.manager.images.count == 0 ? 1 : 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch Section(rawValue: indexPath.section)! {
        case .header:
            let cell = collectionView.dequeueReusableCell(SearchHeaderGridCell.self, for: indexPath)
            cell.configure(isGifOn: self.isGifOn)
            cell.delegate = self
            return cell
        case .image:
            let cell = collectionView.dequeueReusableCell(SearchedImageGridCell.self, for: indexPath)
            cell.configure(searchedImage: self.manager.images[indexPath.item])
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
            if self.manager.hasMore {
                self.requestMoreImages()
            }
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
                let pixelWidth = CGFloat(self.manager.images[indexPath.item].pixelWidth)
                let pixelHeight = CGFloat(self.manager.images[indexPath.item].pixelHeight)
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
            return self.manager.images.count > 0 ? UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8) : UIEdgeInsets.zero
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
                let viewController = ImageViewerViewController.create(image: image, searchedImage: self.manager.images[indexPath.item])
                self.present(viewController, animated: true, completion: nil)
            }
        default:
            // do nothing.
            break
        }
    }
    
    // MARK: - SearchHeaderGridCellDelegate
    func didSearchProviderButtonTap() {
        let alertController = UIAlertController(title: "provider:searchProvider".localized(), message: nil, preferredStyle: .actionSheet)
        SearchProvider.all.forEach({
            let provider = $0
            alertController.addAction(UIAlertAction(title: provider.name, style: .default, handler: { (action) in
                SettingsCenter.shared.searchProvider = provider
                self.requestImages()
            }))
        })
        alertController.addAction(UIAlertAction(title: "common:cancel".localized(), style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func didGifSelectionChange() {
        self.isGifOn.toggle()
        self.requestImages()
    }
}

protocol SearchHeaderGridCellDelegate: class {
    func didSearchProviderButtonTap()
    func didGifSelectionChange()
}

class SearchHeaderGridCell: UICollectionViewCell, NibLoadable {
    
    static var height: CGFloat { return 44 }
    
    @IBOutlet weak var providerButton: UIButton!
    @IBOutlet weak var gifButton: UIButton!
    
    weak var delegate: SearchHeaderGridCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(isGifOn: Bool) {
        let provider = SettingsCenter.shared.searchProvider
        self.providerButton.setTitle(provider.name, for: .normal)
        self.gifButton.isSelected = isGifOn
    }
    
    @IBAction func providerButtonDidTap(_ sender: UIButton) {
        self.delegate?.didSearchProviderButtonTap()
    }
    
    @IBAction func gifButtonDidTap(_ sender: UIButton) {
        self.delegate?.didGifSelectionChange()
    }
}
