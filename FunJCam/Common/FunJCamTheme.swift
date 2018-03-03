//
//  FunJCamTheme.swift
//  FunJCam
//
//  Created by boxjeon on 2017. 1. 12..
//  Copyright © 2017년 the42apps. All rights reserved.
//

class FJTheme {
    
    class func setup() {
        UIView.appearance().tintColor = FJColor.primary
        UIButton.appearance().tintColor = FJColor.accent
    }
    
}

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
