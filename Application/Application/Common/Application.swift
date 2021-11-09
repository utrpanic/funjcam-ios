import UIKit

public struct Application {
  public static func setupAppearance() {
    UIView.appearance().tintColor = Resource.color("primary")
    UIButton.appearance().tintColor = Resource.color("accent")
  }
}
