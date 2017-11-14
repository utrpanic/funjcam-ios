//
//  ResponseSearchImage.swift
//  FunJCam
//
//  Created by boxjeon on 2016. 7. 23..
//  Copyright © 2016년 boxjeon. All rights reserved.
//

class ResponseSearchImage: Decodable {
    
    var searchedImages: Array<SearchedImage>?
    var nextPages: Array<NextPage>?
    var nextPageStartIndex: Int? { return self.nextPages?.first?.startIndex }
    
    private enum CodingKeys: String, CodingKey {
        case items
        case nextPage = "queries.nextPage"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.searchedImages = try values.decodeIfPresent(Array<SearchedImage>.self, forKey: .items)
        self.nextPages = try values.decodeIfPresent(Array<NextPage>.self, forKey: .nextPage)
    }

}

class NextPage: Decodable {
    
    var startIndex: Int = 0
    
    private enum CodingKeys: String, CodingKey {
        case startIndex
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        if let startIndex = try values.decodeIfPresent(Int.self, forKey: .startIndex) {
            self.startIndex = startIndex
        }
    }

}

