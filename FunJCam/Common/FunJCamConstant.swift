//
//  FunJCamConstant.swift
//  FunJCam
//
//  Created by gurren-l on 2017. 11. 14..
//  Copyright © 2017년 the42apps. All rights reserved.
//

struct FJConstant {
    
    struct device {
        static var isPhone: Bool { return UIDevice.current.userInterfaceIdiom == .phone }
        static var isPad: Bool { return UIDevice.current.userInterfaceIdiom == .pad }
        static var hasNotch: Bool {
            return self.notchHeight > 0
        }
        static var notchHeight: CGFloat {
            if #available(iOS 11.0, *) {
                return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0
            } else {
                return 0
            }
        }
    }
    
}
