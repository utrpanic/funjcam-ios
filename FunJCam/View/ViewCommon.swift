//
//  ViewCommon.swift
//  FunJCam
//
//  Created by BoxJeon on 07/04/2019.
//  Copyright © 2019 the42apps. All rights reserved.
//

import Kingfisher

struct FJColor {
    
    static var primary: UIColor { return UIColor(hex: "#3f51b5")! }
    static var primaryDark: UIColor { return UIColor(hex: "#303f9f")! }
    static var accent: UIColor { return UIColor(hex: "#ff4081")! }
    
    static var titleText: UIColor { return UIColor(hex: "#333333")! }
    static var subtitleText: UIColor { return UIColor(hex: "#959595")! }
}

struct FJImage {
    
    static let transparent = UIImage.getImage(color: .clear)
}

extension UIImage {
    
    class func getImage(color: UIColor) -> UIImage {
        // width, height에 원래는 0.5를 줬었는데, 3x디바이스에서 다른 이미지가 나옴.
        let size = CGSize(width: 1 / UIScreen.main.scale, height: 1 / UIScreen.main.scale)
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

extension UIImageView {
    
    func setImage(url: String?, placeholder: UIImage?, completion: ((UIImage?) -> Void)?) {
        let safeURL = URL.safeVersion(from: url)
        self.kf.setImage(with: safeURL, placeholder: placeholder, options: [.transition(.fade(0.2))], progressBlock: nil) { result in
            switch result {
            case .success(let value):
                completion?(value.image)
            case .failure(_):
                completion?(nil)
            }
        }
    }
}
