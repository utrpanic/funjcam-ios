//
//  FunJCamExtension.swift
//  FunJCam
//
//  Created by boxjeon on 2017. 1. 12..
//  Copyright © 2017년 the42apps. All rights reserved.
//

import SDWebImage

extension UIImageView {
    
    func setImage(url: String?, placeholder: UIImage?, completion: ((UIImage?) -> Void)?) {
        self.image = placeholder
        self.sd_cancelCurrentImageLoad()
        self.alpha = 0
        guard let url = URL(string: url?.urlEncoded ?? ""), url.absoluteString.trimmed.length > 0 else {
            return
        }
        self.sd_setImage(with: url, placeholderImage: placeholder, options: [], completed: { (image, error, type, url) in
            if type == .none {
                UIView.animate(withDuration: 0.2, animations: {
                    self.alpha = 1
                })
            } else {
                self.alpha = 1
            }
            
            if let image = image {
                completion?(image)
            } else {
                Log.d("Load image fail. [\((error as? NSError)?.code ?? -1)] \(url)")
                completion?(nil)
            }
        })
    }
    
}
