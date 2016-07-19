//
//  SearchedImage.swift
//  funjcam
//
//  Created by gurren-l on 2016. 7. 19..
//  Copyright © 2016년 boxjeon. All rights reserved.
//

import ObjectMapper

class SearchedImage: Mappable {
    var thumbnailLink: String?
    var link: String?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        thumbnailLink   <- map["image.thumbnailLink"]
        link            <- map["link"]
    }
}
