//
//  SearchViewController.swift
//  funjcam
//
//  Created by boxjeon on 2016. 7. 16..
//  Copyright © 2016년 boxjeon. All rights reserved.
//

class SearchViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var searchedImages: Array<SearchedImage>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupCollectionView()
        
        self.requestData()
    }
    
    func setupCollectionView() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.collectionView.registerClassById(SearchedImageGridCell.id)
    }
    
    func requestData() {
        ApiManager.shared.searchImage("태연", resultPage: .None) { (searchedImages) in
            self.searchedImages = searchedImages
            self.collectionView.reloadData()
        }
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

