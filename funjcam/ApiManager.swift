//
//  ApiManager.swift
//  funjcam
//
//  Created by gurren-l on 2016. 7. 19..
//  Copyright © 2016년 boxjeon. All rights reserved.
//

import Alamofire
import ObjectMapper

class ApiManager {
    
    static let shared = ApiManager()
    
    fileprivate let googleCustomSearchUrl = "https://www.googleapis.com/customsearch/v1"
    fileprivate let queryParameters: Dictionary<String, AnyObject> = [
        "key": "AIzaSyCTdQn7PY1xP5d_Otz8O8aTvbCSslU7lBQ" as AnyObject,
        "cx": "015032654831495313052:qzljc0expde" as AnyObject,
        "searchType": "image" as AnyObject,
        ]
    
    func searchImage(keyword: String, startIndex: Int?, completion: @escaping (Array<SearchedImage>?, Int?) -> Void) {
        var parameters = self.queryParameters
        parameters["num"] = 10 as AnyObject? // 1~10만 허용.
        parameters["q"] = keyword as AnyObject?
        if let startIndex = startIndex {
            parameters["start"] = startIndex as AnyObject?
        }
        
        Alamofire.request(self.googleCustomSearchUrl, parameters: parameters).responseJSON { (response) in
            Log?.d(response.result.value)
            if let json = response.result.value as? Dictionary<String, AnyObject> {
                let responseSearchImage = Mapper<ResponseSearchImage>().map(JSON: json)
                completion(responseSearchImage?.searchedImages, responseSearchImage?.nextPageStartIndex)
            }
        }
    }
}
//https://developers.google.com/custom-search/json-api/v1/reference/cse/list
//template = "https://www.googleapis.com/customsearch/v1?
//q={searchTerms}&
//num={count?}&
//start={startIndex?}&
//lr={language?}&
//safe={safe?}&
//cx={cx?}&
//cref={cref?}&
//sort={sort?}&
//filter={filter?}&
//gl={gl?}&
//cr={cr?}&
//googlehost={googleHost?}&
//c2coff={disableCnTwTranslation?}&
//hq={hq?}&
//hl={hl?}&
//siteSearch={siteSearch?}&
//siteSearchFilter={siteSearchFilter?}&
//exactTerms={exactTerms?}&
//excludeTerms={excludeTerms?}&
//linkSite={linkSite?}&
//orTerms={orTerms?}&
//relatedSite={relatedSite?}&
//dateRestrict={dateRestrict?}&
//lowRange={lowRange?}&
//highRange={highRange?}&
//searchType={searchType}&
//fileType={fileType?}&
//rights={rights?}&
//imgSize={imgSize?}&
//imgType={imgType?}&
//imgColorType={imgColorType?}&
//imgDominantColor={imgDominantColor?}&
//alt=json";
