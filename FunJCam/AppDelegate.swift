import UIKit
import Application

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    self.setupApplication()
    self.startApplication()
    return true
  }
  
  func setupApplication() {
    Application.setupAppearance()
  }
  
  func startApplication() {
    self.window = UIWindow(frame: UIScreen.main.bounds)
    let controller = MainController(dependency: AppComponent())
    self.window?.rootViewController = controller.createViewController().ui
    self.window?.makeKeyAndVisible()
  }
}
