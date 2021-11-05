import UIKit

public struct App {
  public static func setupAppearance() {
    UIView.appearance().tintColor = Color.primary
    UIButton.appearance().tintColor = Color.accent
  }
}

extension App {
  public struct Color {
    static var primary: UIColor { return UIColor(hex: "#3f51b5")! }
    static var primaryDark: UIColor { return UIColor(hex: "#303f9f")! }
    static var accent: UIColor { return UIColor(hex: "#ff4081")! }
    static var titleText: UIColor { return UIColor(hex: "#333333")! }
    static var subtitleText: UIColor { return UIColor(hex: "#959595")! }
  }
}

extension App {
  public struct Image {
    static let transparent = UIImage.getImage(color: .clear)
  }
}
