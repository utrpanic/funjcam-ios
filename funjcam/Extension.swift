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
        return self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
    }
    
    var trim: String {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
    
    var length: Int {
        return self.characters.count
    }
    
    func substring(from from: Int) -> String {
        return self.substringWithRange(self.startIndex.advancedBy(from) ..< self.endIndex)
    }
    
    func substring(to to: Int) -> String {
        return self.substringWithRange(self.startIndex ..< self.startIndex.advancedBy(to))
    }
    
    func substring(from from: Int, to: Int) -> String {
        return self.substring(to: to).substring(from: from)
    }
    
}

extension UICollectionView {
    
    func registerClassById(id: String) {
        self.registerNib(UINib(nibName: id, bundle: nil), forCellWithReuseIdentifier: id)
    
    }
}

extension UIImageView {
    
    func setImage(url url: String?, placeholder: UIImage?) {
        if let url = url?.urlEncoded {
            self.sd_setImageWithURL(NSURL(string: url)!)
        } else {
            self.image = placeholder
        }
    }
    
}

extension UIView {
    
    class var id: String { return NSStringFromClass(self).componentsSeparatedByString(".").last! }
    
    func drawBorder(color color: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1), width: CGFloat = 0.5) {
        self.layer.borderColor = color.CGColor
        self.layer.borderWidth = width
        self.clipsToBounds = true
    }
    
    var widthConstraint: NSLayoutConstraint? {
        return self.constraints.filter({ (constraint) -> Bool in
            return constraint.firstItem === self && constraint.firstAttribute == .Width && constraint.secondItem == nil
        }).last
    }
    
    var heightConstraint: NSLayoutConstraint? {
        return self.constraints.filter({ (constraint) -> Bool in
            return constraint.firstItem === self && constraint.firstAttribute == .Height && constraint.secondItem == nil
        }).last
    }
    
}