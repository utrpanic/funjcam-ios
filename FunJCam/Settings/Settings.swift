
public class Settings {
    
    public static let shared: Settings = Settings()
    
    public var searchProvider: SearchProvider {
        get { return SearchProvider(string: UserDefaults.standard.string(forKey: "searchProvider")) }
        set { UserDefaults.standard.set(newValue.rawValue, forKey: "searchProvider")}
    }
}
