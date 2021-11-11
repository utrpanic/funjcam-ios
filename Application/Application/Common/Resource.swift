import UIKit

public struct Resource {
  
  public static func color(_ name: String) -> UIColor? {
    return UIColor(named: name, in: .module, compatibleWith: nil)
  }
  
  public static func image(_ name: String) -> UIImage? {
    return UIImage(named: name, in: .module, compatibleWith: nil)
  }
  
  public static func image(_ name: String, size: CGFloat, weight: UIImage.SymbolWeight) -> UIImage? {
    let configuration = UIImage.SymbolConfiguration(pointSize: size, weight: weight)
    return UIImage(systemName: name, withConfiguration: configuration)
  }
  
  public static func image(color: UIColor?) -> UIImage? {
    guard let color = color else { return nil }
    let size = CGSize(width: 1 / UIScreen.main.scale, height: 1 / UIScreen.main.scale)
    let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
    color.setFill()
    UIRectFill(rect)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
  }
  
  public static func string(_ key: String, _ args: CVarArg...) -> String {
    let bundle = Bundle.module
    let format = bundle.localizedString(forKey: key, value: nil, table: nil)
    return String(format: format, args)
  }
}
