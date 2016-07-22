//
//  SearchViewController.swift
//  funjcam
//
//  Created by boxjeon on 2016. 7. 16..
//  Copyright © 2016년 boxjeon. All rights reserved.
//

class SearchViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

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
    var searchedImages: Array<SearchedImage>?
    
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
    }
    
    func requestData() {
        ApiManager.shared.searchImage(keyword: self.searchKeyword, startIndex: (self.searchedImages?.count ?? 0) + 1, resultPage: .None) { [weak self] (searchedImages) in
            if self?.searchedImages?.count ?? 0 == 0 {
                self?.searchedImages = searchedImages
            } else {
                if let searchedImages = searchedImages {
                    self?.searchedImages?.appendContentsOf(searchedImages)
                }
            }
            self?.collectionView.reloadData()
        }
    }
    
    @IBAction func onSearchTapped(sender: UITextField) {
        self.searchedImages = nil
        self.requestData()
        self.view.endEditing(true)
    }
    
    // Mark: UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.searchedImages?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(SearchedImageGridCell.id, forIndexPath: indexPath) as! SearchedImageGridCell
        cell.configureCell(self.searchedImages?[indexPath.item])
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake((collectionView.frame.width - 8 - 8 - 8) / 2, 96)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(8, 8, 8, 8)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let imageToShare = (collectionView.cellForItemAtIndexPath(indexPath) as? SearchedImageGridCell)?.imageView.image {
            let viewController = UIActivityViewController(activityItems: [imageToShare], applicationActivities: nil)
            self.presentViewController(viewController, animated: true, completion: nil)
        }
    }

}

