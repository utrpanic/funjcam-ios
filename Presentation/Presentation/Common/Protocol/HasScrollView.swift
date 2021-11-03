//
//  HasScrollView.swift
//  FunJCam
//
//  Created by box-jeon on 2018. 5. 2..
//  Copyright © 2018년 box-jeon. All rights reserved.
//
import UIKit

protocol HasScrollView {
  var scrollView: UIScrollView { get }
}

extension HasScrollView {
  func scrollToTop(animated: Bool) {
    self.scrollView.setContentOffset(.zero, animated: animated)
  }
}
