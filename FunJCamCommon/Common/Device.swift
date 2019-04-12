//
//  Device.swift
//  BoxJeonExtension
//
//  Created by BoxJeon on 07/04/2019.
//  Copyright © 2019 boxjeon. All rights reserved.
//

public struct Device {
    
    static var isPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    static var isPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    static var safeAreaTopInset: CGFloat {
        return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0
    }
    static var safeAreaBottomInset: CGFloat {
        return UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0
    }
}

