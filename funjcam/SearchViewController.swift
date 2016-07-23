//
//  SearchViewController.swift
//  funjcam
//
//  Created by boxjeon on 2016. 7. 16..
//  Copyright © 2016년 boxjeon. All rights reserved.
//

class SearchViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    enum Section: Int {
        case Image
        case LoadMore
        case Empty
        static let count = Section.Empty.rawValue + 1
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
        let viewController = storyboard.instantiateViewControllerWithIdentifier("SearchViewController") as! SearchViewController
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
                    self?.searchedImages?.appendContentsOf(searchedImages)
                }
            }
            self?.nextPageStartIndex = nextPageStartIndex
            self?.collectionView.reloadData()
        }
    }
    
    @IBAction func onSearchTapped(sender: UITextField) {
        self.searchedImages = nil
        self.requestData()
        self.view.endEditing(true)
    }
    
    // Mark: UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return Section.count
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .Image:
            return self.searchedImages?.count ?? 0
        case .LoadMore:
            return self.nextPageStartIndex != nil ? 1 : 0
        case .Empty:
            return self.searchedImages?.count ?? 0 == 0 ? 1 : 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        switch Section(rawValue: indexPath.section)! {
        case .Image:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(SearchedImageGridCell.id, forIndexPath: indexPath) as! SearchedImageGridCell
            cell.configureCell(self.searchedImages?[indexPath.item])
            return cell
        case .LoadMore:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(LoadMoreGridCell.id, forIndexPath: indexPath) as! LoadMoreGridCell
            return cell
        case .Empty:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(EmptySearchGridCell.id, forIndexPath: indexPath) as! EmptySearchGridCell
            return cell
        }
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        switch Section(rawValue: indexPath.section)! {
        case .LoadMore:
            if let _ = self.nextPageStartIndex {
                self.requestData()
            }
        default:
            break
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        switch Section(rawValue: indexPath.section)! {
        case .Image:
            return CGSizeMake((collectionView.frame.width - 8 - 8 - 8) / 2, SearchedImageGridCell.defaultHeight)
        case .LoadMore:
            return CGSizeMake(collectionView.frame.width, LoadMoreGridCell.defaultHeight)
        case .Empty:
            return collectionView.frame.size
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        switch Section(rawValue: section)! {
        case .Image:
            return self.searchedImages?.count ?? 0 > 0 ? UIEdgeInsetsMake(8, 8, 8, 8) : UIEdgeInsetsZero
        default:
            return UIEdgeInsetsZero
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        switch Section(rawValue: section)! {
        case .Image:
            return 8
        default:
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        switch Section(rawValue: section)! {
        case .Image:
            return 8
        default:
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        switch Section(rawValue: indexPath.section)! {
        case .Image:
            if let imageToShare = (collectionView.cellForItemAtIndexPath(indexPath) as? SearchedImageGridCell)?.imageView.image {
                let viewController = UIActivityViewController(activityItems: [imageToShare], applicationActivities: nil)
                self.presentViewController(viewController, animated: true, completion: nil)
            }
        default:
            // do nothing.
            break
        }
    }

}

