import UIKit

public class ViewController: UIViewController {

  static func createFromStoryboard(name: String) -> Self {
    let storyboard = UIStoryboard(name: name, bundle: .module)
    return storyboard.instantiateViewController(identifier: self.typeName)
  }
}
