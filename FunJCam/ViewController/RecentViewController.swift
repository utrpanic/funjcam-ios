//
//  RecentViewController.swift
//  funjcam
//
//  Created by boxjeon on 2016. 7. 16..
//  Copyright © 2016년 boxjeon. All rights reserved.
//
import BoxKit

class RecentViewController: FJViewController, NibLoadable {
    
    static func create() -> Self {
        let viewController = self.create(storyboardName: "Main")!
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

}
