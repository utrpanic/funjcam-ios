import UIKit

protocol HasScrollView {
  var scrollView: UIScrollView? { get }
}

extension HasScrollView {
  func scrollToTop(animated: Bool) {
    self.scrollView?.setContentOffset(.zero, animated: animated)
  }
}
