//
//  ResponseNaverImageSearch.swift
//  FunJCam
//
//  Created by boxjeon on 2018. 4. 30..
//  Copyright © 2018년 the42apps. All rights reserved.
//

class ResponseNaverImageSearch: Decodable {
    
    var searchedImages: [SearchedImageByDaum]
    
    
    
    
    
    private enum CodingKeys: String, CodingKey {
        case rss
        case channel
        case items
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.searchedImages = try values.decodeIfPresent([SearchedImageByDaum].self, forKey: .items) ?? []
    }
}
