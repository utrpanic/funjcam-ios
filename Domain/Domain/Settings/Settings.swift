import Foundation
import Entity

public class Settings {
  
  public static let shared: Settings = Settings()
  
  public var searchProvider: SearchProvider {
    get { return SearchProvider(rawValue: UserDefaults.standard.string(forKey: "searchProvider") ?? "") ?? .google }
    set { UserDefaults.standard.set(newValue.rawValue, forKey: "searchProvider")}
  }
}
