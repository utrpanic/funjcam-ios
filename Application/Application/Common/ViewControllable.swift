import UIKit

public protocol ViewControllable: AnyObject {
  var ui: UIViewController { get }
}

extension ViewControllable where Self: UIViewController {
  var ui: UIViewController { self }
}

extension ViewControllable {
  
  func present(viewControllable: ViewControllable, animated: Bool, completion: (() -> Void)? = nil) {
    let presenting = self.ui
    let viewController = viewControllable.ui
    presenting.present(viewController, animated: animated, completion: completion)
  }
  
  func presentWithNavigation(viewControllable: ViewControllable, animated: Bool, completion: (() -> Void)? = nil) {
    let presenting = self.ui
    let viewController = NavigationController(rootViewController: viewControllable.ui)
    presenting.present(viewController, animated: animated, completion: completion)
  }
  
  func push(viewControllable: ViewControllable, animated: Bool) {
    guard let navigation = self.ui.navigationController else { return }
    let viewController = viewControllable.ui
    navigation.pushViewController(viewController, animated: animated)
  }
}
