//
//  SearchedImage.swift
//  FunJCam
//
//  Created by gurren-l on 2017. 11. 14..
//  Copyright © 2017년 the42apps. All rights reserved.
//

protocol SearchedImage {
    
    var originalUrl: String? { get }
    var originalWidth: Double? { get }
    var originalHeight: Double? { get }
    var thumbnailUrl: String? { get }
    
    var isAnimatedGif: Bool { get }
}
