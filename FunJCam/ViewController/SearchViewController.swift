//
//  SearchViewController.swift
//  funjcam
//
//  Created by boxjeon on 2016. 7. 16..
//  Copyright © 2016년 boxjeon. All rights reserved.
//

import CHTCollectionViewWaterfallLayout

class SearchViewController: FJViewController, NibLoadable, UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout {
    
    enum Section: Int {
        case image
        case loadMore
        case empty
        static let count = Section.empty.rawValue + 1
    }

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var gifButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var searchKeyword: String {
        if !(self.textField.text?.isEmpty ?? false) {
            return self.textField.text!
        } else if !(self.textField.placeholder?.isEmpty ?? false) {
            return self.textField.placeholder!
        } else {
            return ""
        }
    }
    var searchedImages: [GoogleSearchedImage]? {
        willSet {
            if newValue == nil {
                self.nextPageStartIndex = nil
            }
        }
    }
    var nextPageStartIndex: Int?
    
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
        self.textField.placeholder = "평창 인면조"
        self.textField.becomeFirstResponder()
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
        ApiManager.shared.searchImage(keyword: self.searchKeyword, startIndex: self.nextPageStartIndex) { [weak self] (code, response) in
            if let response = response {
                if self?.searchedImages?.count ?? 0 == 0 {
                    self?.searchedImages = response.searchedImages
                } else {
                    if let searchedImages = response.searchedImages {
                        self?.searchedImages?.append(contentsOf: searchedImages)
                    }
                }
                if let nextPageStartIndex = response.nextPageStartIndex {
                    self?.nextPageStartIndex = nextPageStartIndex
                }
                self?.collectionView.reloadData()
            } else {
                // TODO: 에러처리
            }
        }
    }
    
    @IBAction func didSearchTap(_ sender: UITextField) {
        self.searchedImages = nil
        self.requestImages()
        self.view.endEditing(true)
    }
    
    @IBAction func didGifTap(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    // MARK: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .image:
            return self.searchedImages?.count ?? 0
        case .loadMore:
            return self.nextPageStartIndex != nil ? 1 : 0
        case .empty:
            return self.searchedImages?.count ?? 0 == 0 ? 1 : 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch Section(rawValue: indexPath.section)! {
        case .image:
            let cell = collectionView.dequeueReusableCell(SearchedImageGridCell.self, for: indexPath)
            cell.configure(searchedImage: self.searchedImages?[indexPath.item])
            return cell
        case .loadMore:
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
        case .loadMore:
            if self.nextPageStartIndex != nil {
                self.requestImages()
            }
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, columnCountForSection section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .image:
            return 2
        case .loadMore, .empty:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        switch Section(rawValue: indexPath.section)! {
        case .image:
            let width: CGFloat = (collectionView.frame.width - 8 - 8 - 8) / 2
            let height: CGFloat = {
                if let originalWidth = self.searchedImages?[indexPath.item].originalWidth,
                    let originalHeight = self.searchedImages?[indexPath.item].originalHeight {
                    return width * CGFloat(originalHeight / originalWidth)
                } else {
                    return SearchedImageGridCell.defaultHeight
                }
            }()
            return CGSize(width: width, height: height)
        case .loadMore:
            return CGSize(width: collectionView.frame.width, height: LoadMoreGridCell.defaultHeight)
        case .empty:
            return collectionView.frame.size
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        switch Section(rawValue: section)! {
        case .image:
            return self.searchedImages?.count ?? 0 > 0 ? UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8) : UIEdgeInsets.zero
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
                let viewController = ImageViewerViewController.create(image: image, searchedImage: self.searchedImages?[indexPath.item])
                self.present(viewController, animated: true, completion: nil)
            }
        default:
            // do nothing.
            break
        }
    }

}
