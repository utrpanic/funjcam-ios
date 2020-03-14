//
//  BookmarkViewController.swift
//  funjcam
//
//  Created by boxjeon on 2016. 7. 16..
//  Copyright © 2016년 boxjeon. All rights reserved.
//

class BookmarkViewController: FJViewController {
    
    var viewModel: SearchViewModel = SearchViewModel()
    
    static func create() -> BookmarkViewController {
        return BookmarkViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigationItem()
        
//        self.requestImages()
    }
    
    private func setupNavigationItem() {
        
    }
    
    private func requestImages() {
        self.viewModel.search()
    }
}
