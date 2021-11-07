public protocol UserDefaultsProtocol {
  func string(forKey key: String) -> String?
  func set(_ value: Any?, forKey key: String)
}
