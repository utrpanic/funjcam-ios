//
//  NextPage.swift
//  funjcam
//
//  Created by boxjeon on 2016. 7. 23..
//  Copyright © 2016년 boxjeon. All rights reserved.
//

import ObjectMapper

class NextPage: Mappable {
    
    var startIndex: Int?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        startIndex   <- map["startIndex"]
    }
}
