//
//  SettingsViewController.swift
//  FunJCam
//
//  Created by boxjeon on 2018. 4. 29..
//  Copyright © 2018년 the42apps. All rights reserved.
//
import BoxKit

class SettingsViewController: FJViewController, NibLoadable {
    
    static func create() -> Self {
        let viewController = self.create(storyboardName: "Main")!
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
