//
//  StoryboardCenter.swift
//  BoxJeonExtension
//
//  Created by gurren-l-macbook-pro on 2018. 8. 14..
//  Copyright © 2018년 boxjeon. All rights reserved.
//

public class StoryboardCenter {
    
    static let shared: StoryboardCenter = StoryboardCenter()
    
    private var cache: NSCache<NSString, UIStoryboard> = NSCache()
    
    func retrieve(name: String) -> UIStoryboard {
        if let storyboard = self.cache.object(forKey: name.ns) {
            return storyboard
        } else {
            let storyboard = UIStoryboard(name: name, bundle: nil)
            self.cache.setObject(storyboard, forKey: name.ns)
            return storyboard
        }
    }
}
