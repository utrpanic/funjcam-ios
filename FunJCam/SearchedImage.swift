//
//  SearchedImage.swift
//  FunJCam
//
//  Created by gurren-l on 2016. 7. 19..
//  Copyright © 2016년 boxjeon. All rights reserved.
//

import RealmSwift
import Mapper

class SearchedImage: Decodable {
    var thumbnailLink: String = ""
    var link: String = ""
    var width: Int?
    var height: Int?
    var byteSize: Int?
    
    var contextLink: String?
    
    private enum CodingKeys: String, CodingKey {
        case thumbnailLink = "image.thumbnailLink"
        case link = "link"
        case width = "image.width"
        case height = "image.height"
        case byteSize = "image.byteSize"
        case contextLink = "image.contextLink"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.thumbnailLink = try values.decodeIfPresent(String.self, forKey: .thumbnailLink) ?? ""
        self.link = try values.decodeIfPresent(String.self, forKey: .link) ?? ""
        self.width = try values.decodeIfPresent(Int.self, forKey: .width)
        self.height = try values.decodeIfPresent(Int.self, forKey: .height)
        self.byteSize = try values.decodeIfPresent(Int.self, forKey: .byteSize)
        self.contextLink = try values.decodeIfPresent(String.self, forKey: .contextLink)
    }
    
}
