//
//  RecentViewController.swift
//  funjcam
//
//  Created by boxjeon on 2016. 7. 16..
//  Copyright © 2016년 boxjeon. All rights reserved.
//

class RecentViewController: BaseViewController {
    
    class func create() -> RecentViewController {
        let viewController = self.create(storyboardName: "Main") as! RecentViewController
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}

