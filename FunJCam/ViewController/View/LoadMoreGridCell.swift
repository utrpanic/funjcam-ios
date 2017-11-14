//
//  LoadMoreGridCell.swift
//  funjcam
//
//  Created by gurren-l on 2016. 7. 22..
//  Copyright © 2016년 boxjeon. All rights reserved.
//

class LoadMoreGridCell: UICollectionViewCell {
    
    class var defaultHeight: CGFloat { return 44 }
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    func startLoadingAnimation() {
        self.activityIndicatorView.startAnimating()
    }
    
}
