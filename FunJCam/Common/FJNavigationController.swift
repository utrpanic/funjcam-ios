//
//  FJNavigationController.swift
//  FunJCam
//
//  Created by gurren-l on 2017. 11. 14..
//  Copyright © 2017년 the42apps. All rights reserved.
//

class FJNavigationController: UINavigationController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.topViewController?.preferredStatusBarStyle ?? .default
    }
    
    override var prefersStatusBarHidden: Bool {
        return self.topViewController?.prefersStatusBarHidden ?? false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
