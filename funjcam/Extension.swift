//
//  Extension.swift
//  funjcam
//
//  Created by gurren-l on 2016. 7. 19..
//  Copyright © 2016년 boxjeon. All rights reserved.
//

import SDWebImage

extension String {
    
    var urlEncoded: String? {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
    }
    
    var trim: String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    var length: Int {
        return self.characters.count
    }
    
    func substring(from: Int) -> String {
        return self.substring(with: self.characters.index(self.startIndex, offsetBy: from) ..< self.endIndex)
    }
    
    func substring(to: Int) -> String {
        return self.substring(with: self.startIndex ..< self.characters.index(self.startIndex, offsetBy: to))
    }
    
    func substring(from: Int, to: Int) -> String {
        return self.substring(to: to).substring(from: from)
    }
    
}

extension UICollectionView {
    
    func registerClassById(_ id: String) {
        self.register(UINib(nibName: id, bundle: nil), forCellWithReuseIdentifier: id)
    
    }
}

extension UIImageView {
    
    func setImage(url: String?, placeholder: UIImage?) {
        if let url = url?.urlEncoded {
            self.sd_setImage(with: URL(string: url)!)
        } else {
            self.image = placeholder
        }
    }
    
}

extension UIView {
    
    class var id: String { return NSStringFromClass(self).components(separatedBy: ".").last! }
    
    func drawBorder(color: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1), width: CGFloat = 0.5) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
        self.clipsToBounds = true
    }
    
    var widthConstraint: NSLayoutConstraint? {
        return self.constraints.filter({ (constraint) -> Bool in
            return constraint.firstItem === self && constraint.firstAttribute == .width && constraint.secondItem == nil
        }).last
    }
    
    var heightConstraint: NSLayoutConstraint? {
        return self.constraints.filter({ (constraint) -> Bool in
            return constraint.firstItem === self && constraint.firstAttribute == .height && constraint.secondItem == nil
        }).last
    }
    
}
