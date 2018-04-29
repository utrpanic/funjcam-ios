//
//  SearchedImageByDaum.swift
//  FunJCam
//
//  Created by boxjeon on 2018. 4. 29..
//  Copyright © 2018년 the42apps. All rights reserved.
//

class SearchedImageByDaum: Decodable, SearchedImage {
    
    var url: String
    var pixelWidth: Double
    var pixelHeight: Double
    var thumbnailUrl: String
    
    private enum CodingKeys: String, CodingKey {
        case image_url
        case width
        case height
        case thumbnail_url
        case collection
        case display_sitename
        case doc_url
        case datetime
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.url = try values.decodeIfPresent(String.self, forKey: .image_url) ?? ""
        self.pixelWidth = try values.decodeIfPresent(Double.self, forKey: .width) ?? 0
        self.pixelHeight = try values.decodeIfPresent(Double.self, forKey: .height) ?? 0
        self.thumbnailUrl = try values.decodeIfPresent(String.self, forKey: .thumbnail_url) ?? ""
    }
}
