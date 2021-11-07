import UserDefaults

public final class UserDefaultsMock: UserDefaultsProtocol {
  
  private var dictionary: [String: Any?] = [:]
  
  public func string(forKey key: String) -> String? {
    return self.dictionary[key] as? String
  }
  
  public func set(_ value: Any?, forKey key: String) {
    self.dictionary[key] = value
  }
}
