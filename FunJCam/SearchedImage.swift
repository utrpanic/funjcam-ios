//
//  SearchedImage.swift
//  FunJCam
//
//  Created by gurren-l on 2016. 7. 19..
//  Copyright © 2016년 boxjeon. All rights reserved.
//

import RealmSwift
import Mapper

class SearchedImage: Mappable {
    var thumbnailLink: String?
    var link: String?
    var width: Int?
    var height: Int?
    var byteSize: Int?
    
    var contextLink: String?
    
    required init(map: Mapper) throws {
        thumbnailLink = map.optionalFrom("image.thumbnailLink")
        link = map.optionalFrom("link")
        width = map.optionalFrom("image.width")
        height = map.optionalFrom("image.height")
        byteSize = map.optionalFrom("image.byteSize")
        contextLink = map.optionalFrom("image.contextLink")
    }
    
}
