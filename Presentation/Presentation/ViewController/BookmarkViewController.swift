//
//  BookmarkViewController.swift
//  funjcam
//
//  Created by box-jeon on 2016. 7. 16..
//  Copyright © 2016년 box-jeon. All rights reserved.
//
import Domain

public final class BookmarkViewController: ViewController {
  
  //    var viewModel: SearchViewModel = SearchViewModel()
  
  public static func create() -> BookmarkViewController {
    return BookmarkViewController()
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    self.setupNavigationItem()
    
    //        self.requestImages()
  }
  
  private func setupNavigationItem() {
    
  }
  
  //    private func requestImages() {
  //        self.viewModel.search()
  //    }
}
