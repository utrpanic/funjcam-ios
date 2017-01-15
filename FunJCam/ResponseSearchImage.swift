//
//  ResponseSearchImage.swift
//  FunJCam
//
//  Created by boxjeon on 2016. 7. 23..
//  Copyright © 2016년 boxjeon. All rights reserved.
//

import Mapper

class ResponseSearchImage: Mappable {
    var searchedImages: Array<SearchedImage>?
    var nextPages: Array<NextPage>?
    var nextPageStartIndex: Int? { return self.nextPages?.first?.startIndex }
    
    class func create(json: Dictionary<String, Any>) -> ResponseSearchImage? {
        return ResponseSearchImage.from(json as NSDictionary)
    }
    
    required init(map: Mapper) {
        searchedImages = map.optionalFrom("items")
        nextPages = map.optionalFrom("queries.nextPage")
    }

}

class NextPage: Mappable {
    var startIndex: Int?
    
    required init(map: Mapper) {
        startIndex = map.optionalFrom("startIndex")
    }

}
