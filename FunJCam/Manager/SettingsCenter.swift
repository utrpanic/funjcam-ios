//
//  SettingsCenter.swift
//  FunJCam
//
//  Created by boxjeon on 2018. 4. 29..
//  Copyright © 2018년 the42apps. All rights reserved.
//

class SettingsCenter {
    
    static let shared: SettingsCenter = SettingsCenter()
    
    var searchProvider: SearchProvider {
        get { return SearchProvider(string: UserDefaults.standard.string(forKey: "searchProvider")) }
        set { UserDefaults.standard.set(newValue.rawValue, forKey: "searchProvider")}
    }
}
