//
//  FunJCamExtension.swift
//  FunJCam
//
//  Created by boxjeon on 2017. 1. 12..
//  Copyright © 2017년 the42apps. All rights reserved.
//

extension UINavigationController {
    
    func updateNavigationBarAsTransparent() {
        self.navigationBar.setBackgroundImage(FJImage.transparent, for: .default)
        self.navigationBar.shadowImage = FJImage.transparent
    }
}

extension UIViewController {
    
    func showOkAlert(title: String?, message: String?, okText: String = "Ok", onOk: (() -> Void)?) {
        let viewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okText, style: .default, handler: { (action) in
            onOk?()
        })
        viewController.addAction(okAction)
        self.present(viewController, animated: true, completion: nil)
    }
}

public extension NibLoadable where Self: UIViewController {
    
    static func create(storyboardName: String) -> Self? {
        let storyboard = StoryboardCenter.shared.retrieve(name: storyboardName)
        return storyboard.instantiateViewController(withIdentifier: self.className) as? Self
    }
}
