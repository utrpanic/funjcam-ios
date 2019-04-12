//
//  UIExtension.swift
//  BoxJeonExtension
//
//  Created by boxjeon on 2017. 10. 21..
//  Copyright © 2017년 boxjeon. All rights reserved.
//

public protocol HasClassName: class {}

public extension HasClassName {
    
    static var className: String { return NSStringFromClass(self).components(separatedBy: ".").last! }
}

extension UIView: HasClassName {}

extension UIViewController: HasClassName {}

public protocol NibLoadable {}

public extension NibLoadable where Self: UIView {
    
    static func createFromNib() -> Self? {
        let bundle = Bundle(for: self)
        let views = bundle.loadNibNamed(self.className, owner: nil, options: nil)
        for index in 0 ..< (views?.count ?? 0) {
            if let view = views?[index] as? Self {
                view.translatesAutoresizingMaskIntoConstraints = false
                return view
            }
        }
        return nil
    }
}

public extension NibLoadable where Self: UIViewController {
    
    static func create(storyboardName: String) -> Self? {
        let storyboard = StoryboardCenter.shared.retrieve(name: storyboardName)
        return storyboard.instantiateViewController(withIdentifier: self.className) as? Self
    }
}

public extension UICollectionView {
    
    func registeFromClass<T: UICollectionViewCell>(_ cellClass: T.Type) {
        self.register(cellClass, forCellWithReuseIdentifier: T.className)
    }
    
    func registerFromNib<T: UICollectionViewCell>(_ cellClass: T.Type) where T: NibLoadable {
        self.register(UINib(nibName: T.className, bundle: nil), forCellWithReuseIdentifier: T.className)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(_ cellClass: T.Type, for indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withReuseIdentifier: T.className, for: indexPath) as! T
    }
}

public extension UIColor {
    
    var hex: String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return String(format: "%02x%02x%02x", Int(red * 255), Int(green * 255), Int(blue * 255))
    }
    
    convenience init?(hex: String?) {
        guard let hex = hex?.replacingOccurrences(of: "#", with: ""), hex.count == 6 else {
            return nil
        }
        var rgb: UInt32 = 0
        let scanner = Scanner(string: hex)
        scanner.scanHexInt32(&rgb)
        self.init(red: CGFloat((rgb & 0xff0000) >> 16) / 255.0, green: CGFloat((rgb & 0x00ff00) >> 8) / 255.0, blue: CGFloat(rgb & 0x0000ff) / 255.0, alpha: 1)
    }
}

public extension UIImage {
    
    var original: UIImage { return self.withRenderingMode(.alwaysOriginal) }
    var template: UIImage { return self.withRenderingMode(.alwaysTemplate) }
}

public extension UITableView {
    
    func registerFromClass<T: UITableViewCell>(_ cellClass: T.Type) {
        self.register(cellClass, forCellReuseIdentifier: T.className)
    }
    
    func registerFromNib<T: UITableViewCell>(_ cellClass: T.Type) where T: NibLoadable {
        self.register(UINib(nibName: T.className, bundle: nil), forCellReuseIdentifier: T.className)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(_ cellClass: T.Type, for indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: T.className, for: indexPath) as! T
    }
}

public extension UIView {
    
    func addSubviewAsMatchParent(_ view: UIView) {
        self.addSubview(view)
        let leading = self.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let top = self.topAnchor.constraint(equalTo: view.topAnchor)
        let trailing = self.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let bottom = self.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        NSLayoutConstraint.activate([leading, top, trailing, bottom])
    }
}
