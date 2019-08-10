//
//  BookmarkViewController.swift
//  funjcam
//
//  Created by boxjeon on 2016. 7. 16..
//  Copyright © 2016년 boxjeon. All rights reserved.
//

import AsyncDisplayKit

class BookmarkViewController: FJViewController, ASCollectionDataSource, ASCollectionDelegateFlowLayout, ASCollectionGalleryLayoutPropertiesProviding {
    
    var collectionNode: ASCollectionNode!
    
    var viewModel: SearchViewModel = SearchViewModel()
    
    static func create() -> BookmarkViewController {
        return BookmarkViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigationItem()
        
        self.setupCollectionNode()
        
        self.requestImages()
    }
    
    private func setupNavigationItem() {
        
    }
    
    private func setupCollectionNode() {
        let layoutDelegate = ASCollectionGalleryLayoutDelegate(scrollableDirections: ASScrollDirectionVerticalDirections)
        layoutDelegate.propertiesProvider = self
        self.collectionNode = ASCollectionNode(layoutDelegate: layoutDelegate, layoutFacilitator: nil)
        self.collectionNode.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.collectionNode.backgroundColor = .white
        self.view.addSubnode(self.collectionNode)
        self.collectionNode.frame = self.view.bounds
        self.collectionNode.dataSource = self
        self.collectionNode.delegate = self
    }
    
    private func requestImages() {
        self.viewModel.search()
    }
    
    // MARK: - ASCollectionDataSource
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return 1
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.images.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
        let thumbnail = URL(string: self.viewModel.images[indexPath.item].thumbnailUrl)
        return SearchedImageNode(with: thumbnail)
    }
    
    // MARK: - ASCollectionDelegateFlowLayout
    
    // MARK: - ASCollectionGalleryLayoutPropertiesProviding
    func galleryLayoutDelegate(_ delegate: ASCollectionGalleryLayoutDelegate, sizeForElements elements: ASElementMap) -> CGSize {
        return CGSize(width: 180, height: 90)
    }
    
}

class SearchedImageNode: ASCellNode {
    
    let imageNode: ASNetworkImageNode = ASNetworkImageNode()
    
    init(with URL: URL?) {
        super.init()
        self.imageNode.setURL(URL, resetToDefault: true)
        self.addSubnode(imageNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        var imageRatio: CGFloat = 0.5
        if let image = imageNode.image {
            imageRatio = image.size.height / image.size.width
        }
        let imagePlace = ASRatioLayoutSpec(ratio: imageRatio, child: imageNode)
        let stackLayout = ASStackLayoutSpec.horizontal()
        stackLayout.justifyContent = .start
        stackLayout.alignItems = .start
        stackLayout.style.flexShrink = 1.0
        stackLayout.children = [imagePlace]
        return  ASInsetLayoutSpec(insets: UIEdgeInsets.zero, child: stackLayout)
    }
}
