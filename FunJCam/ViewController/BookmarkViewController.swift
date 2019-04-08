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
    
    static func create() -> BookmarkViewController {
        return BookmarkViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigationItem()
        
        self.setupCollectionNode()
        
        self.requestData()
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
    
    private func requestData() {
        
    }
    
    // MARK: - ASCollectionDataSource
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return 1
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
        let text = "으아아"
        let cell = ItemNode()
        cell.text = text
        return cell
    }
    
    // MARK: - ASCollectionDelegateFlowLayout
    
    // MARK: - ASCollectionGalleryLayoutPropertiesProviding
    func galleryLayoutDelegate(_ delegate: ASCollectionGalleryLayoutDelegate, sizeForElements elements: ASElementMap) -> CGSize {
        return CGSize(width: 180, height: 90)
    }
    
}

class ItemNode: ASTextCellNode {

}
