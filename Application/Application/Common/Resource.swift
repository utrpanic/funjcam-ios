import UIKit

struct Resource {
  
  static func color(_ name: String) -> UIColor? {
    return UIColor(named: name, in: .module, compatibleWith: nil)
  }
  
  static func image(_ name: String) -> UIImage? {
    return UIImage(named: name, in: .module, compatibleWith: nil)
  }
  
  static func image(_ name: String, size: CGFloat, weight: UIImage.SymbolWeight) -> UIImage? {
    let configuration = UIImage.SymbolConfiguration(pointSize: size, weight: weight)
    return UIImage(systemName: name, withConfiguration: configuration)
  }
  
  static func string(_ key: String, _ args: CVarArg...) -> String {
    let bundle = Bundle.module
    let format = bundle.localizedString(forKey: key, value: nil, table: nil)
    return String(format: format, args)
  }
}