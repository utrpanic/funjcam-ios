//
//  HasScrollView.swift
//  FunJCam
//
//  Created by boxjeon on 2018. 5. 2..
//  Copyright © 2018년 the42apps. All rights reserved.
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
