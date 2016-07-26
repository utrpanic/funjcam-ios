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
}

extension UICollectionView {
    func registerClassById(id: String) {
        self.registerNib(UINib(nibName: id, bundle: nil), forCellWithReuseIdentifier: id)
    }
}

extension UICollectionViewCell {
    class var id: String { return NSStringFromClass(self).componentsSeparatedByString(".").last! }
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

extension UITableViewCell {
    class var id: String { return NSStringFromClass(self).componentsSeparatedByString(".").last! }
}

extension UIView {
    func drawBorder(color color: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1), width: CGFloat = 0.5) {
        self.layer.borderColor = color.CGColor
        self.layer.borderWidth = width
        self.clipsToBounds = true
    }
}
