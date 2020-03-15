import UIKit

import BoxKit

class LoadMoreGridCell: UICollectionViewCell, NibLoadable {
    
    class var defaultHeight: CGFloat { return 44 }
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    func startLoadingAnimation() {
        self.activityIndicatorView.startAnimating()
    }
    
}
