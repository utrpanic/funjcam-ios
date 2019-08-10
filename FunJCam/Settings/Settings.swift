//
//  SettingsCenter.swift
//  FunJCam
//
//  Created by boxjeon on 2018. 4. 29..
//  Copyright © 2018년 the42apps. All rights reserved.
//

public class Settings {
    
    public static let shared: Settings = Settings()
    
    public var searchProvider: SearchProvider {
        get { return SearchProvider(string: UserDefaults.standard.string(forKey: "searchProvider")) }
        set { UserDefaults.standard.set(newValue.rawValue, forKey: "searchProvider")}
    }
}
