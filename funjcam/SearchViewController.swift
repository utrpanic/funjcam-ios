//
//  SearchViewController.swift
//  funjcam
//
//  Created by boxjeon on 2016. 7. 16..
//  Copyright © 2016년 boxjeon. All rights reserved.
//

class SearchViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    enum Section: Int {
        case image
        case loadMore
        case empty
        static let count = Section.empty.rawValue + 1
    }

    @IBOutlet weak var textField: UITextField!
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
    var searchedImages: Array<SearchedImage>? {
        willSet {
            if newValue == nil {
                self.nextPageStartIndex = nil
            }
        }
    }
    var nextPageStartIndex: Int?
    
    class func viewController() -> SearchViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.setupTextField()
        
        self.setupCollectionView()
    }
    
    func setupTextField() {
        self.textField.placeholder = "그럼하지마"
        self.textField.becomeFirstResponder()
    }
    
    func setupCollectionView() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.collectionView.registerClassById(SearchedImageGridCell.id)
        self.collectionView.registerClassById(LoadMoreGridCell.id)
        self.collectionView.registerClassById(EmptySearchGridCell.id)
    }
    
    func requestData() {
        ApiManager.shared.searchImage(keyword: self.searchKeyword, startIndex: self.nextPageStartIndex) { [weak self] (searchedImages, nextPageStartIndex) in
            if self?.searchedImages?.count ?? 0 == 0 {
                self?.searchedImages = searchedImages
            } else {
                if let searchedImages = searchedImages {
                    self?.searchedImages?.append(contentsOf: searchedImages)
                }
            }
            self?.nextPageStartIndex = nextPageStartIndex
            self?.collectionView.reloadData()
        }
    }
    
    @IBAction func onSearchTapped(_ sender: UITextField) {
        self.searchedImages = nil
        self.requestData()
        self.view.endEditing(true)
    }
    
    // Mark: UICollectionViewDataSource
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
        switch Section(rawValue: (indexPath as NSIndexPath).section)! {
        case .image:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchedImageGridCell.id, for: indexPath) as! SearchedImageGridCell
            cell.configureCell(self.searchedImages?[(indexPath as NSIndexPath).item])
            return cell
        case .loadMore:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LoadMoreGridCell.id, for: indexPath) as! LoadMoreGridCell
            return cell
        case .empty:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptySearchGridCell.id, for: indexPath) as! EmptySearchGridCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        switch Section(rawValue: (indexPath as NSIndexPath).section)! {
        case .loadMore:
            if let _ = self.nextPageStartIndex {
                self.requestData()
            }
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch Section(rawValue: (indexPath as NSIndexPath).section)! {
        case .image:
            return CGSize(width: (collectionView.frame.width - 8 - 8 - 8) / 2, height: SearchedImageGridCell.defaultHeight)
        case .loadMore:
            return CGSize(width: collectionView.frame.width, height: LoadMoreGridCell.defaultHeight)
        case .empty:
            return collectionView.frame.size
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch Section(rawValue: section)! {
        case .image:
            return self.searchedImages?.count ?? 0 > 0 ? UIEdgeInsetsMake(8, 8, 8, 8) : UIEdgeInsets.zero
        default:
            return UIEdgeInsets.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
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
        switch Section(rawValue: (indexPath as NSIndexPath).section)! {
        case .image:
            if let image = (collectionView.cellForItem(at: indexPath) as? SearchedImageGridCell)?.imageView.image {
                let viewController = ImageViewerViewController.viewController(image: image, searchedImage: self.searchedImages?[(indexPath as NSIndexPath).item])
                self.present(viewController, animated: true, completion: nil)
            }
        default:
            // do nothing.
            break
        }
    }

}

