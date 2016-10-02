//
//  ResponseSearchImage.swift
//  funjcam
//
//  Created by boxjeon on 2016. 7. 23..
//  Copyright © 2016년 boxjeon. All rights reserved.
//

import ObjectMapper

class ResponseSearchImage: Mappable {
    var searchedImages: Array<SearchedImage>?
    var nextPages: Array<NextPage>?
    var nextPageStartIndex: Int? { return self.nextPages?.first?.startIndex }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        searchedImages  <- map["items"]
        nextPages       <- map["queries.nextPage"]
    }
}

class NextPage: Mappable {
    var startIndex: Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        startIndex  <- map["startIndex"]
    }
}
