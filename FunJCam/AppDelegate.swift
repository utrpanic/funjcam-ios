import UIKit
import Presentation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    self.setupApplication()
    self.startApplication()
    return true
  }
  
  func setupApplication() {
    App.setupAppearance()
  }
  
  func startApplication() {
    self.window = UIWindow(frame: UIScreen.main.bounds)
    self.window?.rootViewController = MainViewController()
    self.window?.makeKeyAndVisible()
  }
}
