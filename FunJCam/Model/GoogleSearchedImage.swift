//
//  SearchedImage.swift
//  FunJCam
//
//  Created by gurren-l on 2016. 7. 19..
//  Copyright © 2016년 boxjeon. All rights reserved.
//

extension GoogleSearchedImage: SearchedImage {
    
    var originalUrl: String? { return self.imageUrl }
    var originalWidth: Double? { return self.imageInfo?.width }
    var originalHeight: Double? { return self.imageInfo?.height }
    var thumbnailUrl: String? { return self.imageInfo?.thumbnailUrl }
    
}

class GoogleSearchedImage: Decodable {

    private var imageUrl: String?
    private var imageInfo: GoogleSearchedImageInfo?
    private var mimeType: String?
    private var displayLink: String?
    private var contextLink: String?
    
    private enum CodingKeys: String, CodingKey {
        case link
        case image
        case mime
        case displayLink
        case contextLink
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.imageUrl = try values.decodeIfPresent(String.self, forKey: .link)
        self.imageInfo = try values.decodeIfPresent(GoogleSearchedImageInfo.self, forKey: .image)
        self.mimeType = try values.decodeIfPresent(String.self, forKey: .mime)
        self.displayLink = try values.decodeIfPresent(String.self, forKey: .displayLink)
        self.contextLink = try values.decodeIfPresent(String.self, forKey: .contextLink)
    }
    
}

private class GoogleSearchedImageInfo: Decodable {
    
    var width: Double?
    var height: Double?
    var byteSize: Double?
    var thumbnailUrl: String?
    var thumbnailWidth: Double?
    var thumbnailHeight: Double?
    
    private enum CodingKeys: String, CodingKey {
        case width
        case height
        case byteSize
        case thumbnailLink
        case thumbnailWidth
        case thumbnailHeight
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.width = try values.decodeIfPresent(Double.self, forKey: .width)
        self.height = try values.decodeIfPresent(Double.self, forKey: .height)
        self.byteSize = try values.decodeIfPresent(Double.self, forKey: .byteSize)
        self.thumbnailUrl = try values.decodeIfPresent(String.self, forKey: .thumbnailLink)
        self.thumbnailWidth = try values.decodeIfPresent(Double.self, forKey: .thumbnailWidth)
        self.thumbnailHeight = try values.decodeIfPresent(Double.self, forKey: .thumbnailHeight)
    }
    
}
