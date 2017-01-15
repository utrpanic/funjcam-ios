//
//  FunJCamExtension.swift
//  FunJCam
//
//  Created by boxjeon on 2017. 1. 12..
//  Copyright © 2017년 the42apps. All rights reserved.
//

import WebImage

extension String {
    
    var urlEncoded: String? {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
    }
    
    var trimmed: String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    var length: Int {
        return self.characters.count
    }
    
    func localized(_ args: CVarArg...) -> String {
        let format = NSLocalizedString(self, comment: "")
        if args.count == 0 {
            return format
        } else {
            return String(format: format, arguments: args)
        }
    }
    
}

extension UICollectionView {
    
    func registerNib<T: UICollectionViewCell>(type: T.Type) {
        self.register(UINib(nibName: type.id, bundle: nil), forCellWithReuseIdentifier: type.id)
    }
    
}

extension UIColor {
    
    convenience init(hex: String?, alpha: CGFloat = 1.0) {
        if let hex = hex, hex.hasPrefix("#"), hex.length == 7 {
            var rgb: UInt32 = 0
            let scanner = Scanner(string: hex)
            scanner.scanLocation = 1
            scanner.scanHexInt32(&rgb)
            self.init(red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0, blue: CGFloat(rgb & 0x0000FF) / 255.0, alpha: alpha)
        } else {
            assertionFailure("Wrong color: \(hex)")
            self.init()
        }
    }
    
}

extension UIImageView {
    
    func setImage(url: String?, placeholder: UIImage?, completion: ((UIImage?) -> Void)?) {
        self.image = placeholder
        self.sd_cancelCurrentImageLoad()
        self.alpha = 0
        guard let url = URL(string: url ?? ""), url.absoluteString.trimmed.length > 0 else {
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

extension UITableView {
    
    func registerNib<T: UITableViewCell>(type: T.Type) {
        self.register(UINib(nibName: type.id, bundle: nil), forCellReuseIdentifier: type.id)
    }
    
}

extension UIView {
    
    class var id: String { return NSStringFromClass(self).components(separatedBy: ".").last! }
    
    func drawBorder(color: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1), width: CGFloat = 0.5) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
        self.clipsToBounds = true
    }
    
}

extension UIViewController {
    
    class var id: String { return NSStringFromClass(self).components(separatedBy: ".").last! }
    
    class func create(storyboardName: String) -> UIViewController? {
        return UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: self.id)
    }
    
}
