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
        UITextField.appearance().tintColor = FJColor.accent
    }
    
}

struct FJColor {
    
    static let primary = UIColor(hex: "#3F51B5")
    static let primaryDark = UIColor(hex: "#303F9F")
    static let accent = UIColor(hex: "#FF4081")
    
    static let normalText = UIColor.black
    
}

struct FJImage {
    
}

