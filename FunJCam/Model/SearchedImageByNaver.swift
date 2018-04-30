//
//  SearchedImageByNaver.swift
//  FunJCam
//
//  Created by boxjeon on 2018. 5. 1..
//  Copyright © 2018년 the42apps. All rights reserved.
//

class SearchedImageByNaver: Decodable, SearchedImage {
    
    var url: String
    var pixelWidth: Int
    var pixelHeight: Int
    var thumbnailUrl: String
    
    private enum CodingKeys: String, CodingKey {
        case link
        case sizewidth
        case sizeheight
        case thumbnail
        case title
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.url = try values.decodeIfPresent(String.self, forKey: .link) ?? ""
        let widthString = try values.decodeIfPresent(String.self, forKey: .sizewidth)
        self.pixelWidth = Int(widthString ?? "") ?? 0
        let heightString = try values.decodeIfPresent(String.self, forKey: .sizeheight)
        self.pixelHeight = Int(heightString ?? "") ?? 0
        self.thumbnailUrl = try values.decodeIfPresent(String.self, forKey: .thumbnail) ?? ""
    }
}
