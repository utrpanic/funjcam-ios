import Foundation

struct Resource {
  static func string(_ key: String, _ args: CVarArg...) -> String {
    let bundle = Bundle.module
    let format = bundle.localizedString(forKey: key, value: nil, table: nil)
    return String(format: format, args)
  }
}
