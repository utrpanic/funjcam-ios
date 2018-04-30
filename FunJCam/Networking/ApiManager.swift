//
//  ApiManager.swift
//  FunJCam
//
//  Created by gurren-l on 2016. 7. 19..
//  Copyright © 2016년 boxjeon. All rights reserved.
//

import Alamofire

typealias RawJSON = [String: Any]
typealias ApiCompletion<T> = (Code, T?) -> Void
typealias ApiSuccess<T> = (T) -> Void
typealias ApiFailure = (Code) -> Void

class ApiManager {
    
    static let shared = ApiManager()
    
    private func getObject<T: Decodable>(url: String, headers: HTTPHeaders? = nil, parameters: [String: Any]?, completion: @escaping ApiCompletion<T>, printBody: Bool) {
        let method: HTTPMethod = .get
        let request = Alamofire.request(url, method: method, parameters: parameters, encoding: URLEncoding.default, headers: headers)
        request.validate().log(printBody)
        request.responseData(completionHandler: { (response) in
                response.log(printBody)
                let code = Code(value: response.response?.statusCode)
                switch response.result {
                case .success(let data):
                    do {
                        let result = try JSONDecoder().decode(T.self, from: data)
                        Log.d("[\(method.rawValue) success] \(url)")
                        completion(code, result)
                        return
                    } catch {
                        Log.d("[\(method.rawValue) failure(\(code))] \(url)")
                        Log.d("Json error message: \(error.localizedDescription)")
                        completion(code, nil)
                    }
                case .failure(_):
                    Log.d("[\(method.rawValue) failure(\(code))] \(url)")
                    completion(code, nil)
                }
            })
    }
    
}

extension Request {
    fileprivate func log(_ on: Bool) {
        #if DEBUG
            if on {
                debugPrint(self)
            }
        #endif
    }
}

extension DataResponse {
    fileprivate var url: String {
        return self.response?.url?.absoluteString ?? "nil"
    }
    
    fileprivate func log(_ on: Bool) {
        #if DEBUG
            if on {
                debugPrint(self)
                if let data = self.result.value as? Data {
                    do {
                        if let dictionary = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                            debugPrint(dictionary)
                        }
                    } catch {
                        // do nothing.
                    }
                }
            }
        #endif
    }
}

extension ApiManager {
    
    func searchDaumImage(keyword: String, next: Int?, completion: @escaping ApiCompletion<ResponseDaumImageSearch>) {
        let url = "https://dapi.kakao.com/v2/search/image"
        let headers: HTTPHeaders = [
            "Authorization": "KakaoAK 3aa0ae0423487ecc4eda2664cc7bc936"
        ]
        let parameters: [String: Any] = [
            "query": keyword,
            "sort": "accuracy", // accuracy or recency
            "page": next ?? 1, // 1 ~ 50
            "size": "20", // 1 ~ 80
        ]
        self.getObject(url: url, headers: headers, parameters: parameters, completion: completion, printBody: false)
    }
    
    func searchNaverImage(keyword: String, next: Int?, completion: @escaping ApiCompletion<ResponseNaverImageSearch>) {
        let url = "https://openapi.naver.com/v1/search/image"
        let headers: HTTPHeaders = [
            "X-Naver-Client-Id": "93Aki4p3ckUPf2L7Lyac",
            "X-Naver-Client-Secret": "wD6dHhbcSs"
        ]
        let parameters: [String: Any] = [
            "query": keyword,
            "sort": "sim", // sim or date
            "start": next ?? 1, // 1 ~ 1000
            "display": "20", // 10 ~ 100
            "filter": "all", // all, large, medium, small
        ]
        self.getObject(url: url, headers: headers, parameters: parameters, completion: completion, printBody: false)
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
    
    func searchGoogleImage(keyword: String, next: Int?, completion: @escaping ApiCompletion<ResponseGoogleImageSearch>) {
        let url = "https://www.googleapis.com/customsearch/v1"
        var parameters: [String: Any] = [
            "q": keyword,
            "key": "AIzaSyCTdQn7PY1xP5d_Otz8O8aTvbCSslU7lBQ",
            "cx": "015032654831495313052:qzljc0expde",
            "searchType": "image",
            "num": 10 // 1~10만 허용.
        ]
        if let startIndex = next {
            parameters["start"] = startIndex
        }
        self.getObject(url: url, parameters: parameters, completion: completion, printBody: false)
    }
    
}
