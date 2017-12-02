//
//  FunJCamExtension.swift
//  FunJCam
//
//  Created by boxjeon on 2017. 1. 12..
//  Copyright © 2017년 the42apps. All rights reserved.
//

import SDWebImage

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
    
    func clearImage() {
        self.sd_cancelCurrentImageLoad()
        self.image = nil
    }
    
    func setImage(url: String?, placeholder: UIImage?, completion: ((UIImage?) -> Void)?) {
        self.clearImage()
        self.image = placeholder
        guard let url = URL(string: url ?? "") else {
            completion?(nil)
            return
        }
        self.sd_setImage(with: url, placeholderImage: placeholder, options: [], completed: { (image, error, cacheType, url) in
            if let image = image {
                completion?(image)
            } else {
                Log.d("Load image fail. [\((error as NSError?)?.code ?? -1)] \(url?.absoluteString ?? "")")
                completion?(nil)
            }
            if cacheType == .none {
                self.alpha = 0
                UIView.animate(withDuration: 0.2, animations: {
                    self.alpha = 1
                })
            }
        })
    }
    
}

extension UINavigationController {
    
}
