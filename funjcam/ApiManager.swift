//
//  ApiManager.swift
//  funjcam
//
//  Created by gurren-l on 2016. 7. 19..
//  Copyright © 2016년 boxjeon. All rights reserved.
//

import Alamofire
import ObjectMapper

enum SearchResultPage {
    case None
    case Previous
    case Next
}

class ApiManager {
    
    static let shared = ApiManager()
    
    private let googleCustomSearchUrl = "https://www.googleapis.com/customsearch/v1"
    private let queryParameters = [
        "key": "AIzaSyCTdQn7PY1xP5d_Otz8O8aTvbCSslU7lBQ",
        "cx": "015032654831495313052:qzljc0expde",
        "searchType": "image",
        ]
    
    func searchImage(query: String, resultPage: SearchResultPage, completion: (Array<SearchedImage>?) -> Void) {
        var parameters = self.queryParameters
        parameters["q"] = query
        Alamofire.request(.GET, self.googleCustomSearchUrl, parameters: parameters).responseJSON { (response) in
            Log?.d(response.result.value)
            if let json = response.result.value as? Dictionary<String, AnyObject> {
                completion(Mapper<SearchedImage>().mapArray(json["items"]))
            }
        }
    }
}
