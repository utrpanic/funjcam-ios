import Alamofire
import RxSwift

protocol SearchApiProtocol {
    func searchDaumImage(with query: String, pivot: Int) -> Single<ResponseDaumImageSearch>
    func searchNaverImage(with query: String, pivot: Int) -> Single<ResponseNaverImageSearch>
    func searchGoogleImage(with query: String, pivot: Int?) -> Single<ResponseGoogleImageSearch>
}

extension Api: SearchApiProtocol {
    
    func searchDaumImage(with query: String, pivot: Int) -> Single<ResponseDaumImageSearch> {
        let url = "https://dapi.kakao.com/v2/search/image"
        let headers: HTTPHeaders = [
            "Authorization": "KakaoAK 3aa0ae0423487ecc4eda2664cc7bc936"
        ]
        let parameters: [String: Any] = [
            "query": query,
            "sort": "accuracy", // accuracy or recency
            "page": pivot, // 1 ~ 50
            "size": "20" // 1 ~ 80
        ]
        return self.get(url, headers: headers, parameters: parameters, printBody: false)
    }
    
    func searchNaverImage(with query: String, pivot: Int) -> Single<ResponseNaverImageSearch> {
        let url = "https://openapi.naver.com/v1/search/image"
        let headers: HTTPHeaders = [
            "X-Naver-Client-Id": "93Aki4p3ckUPf2L7Lyac",
            "X-Naver-Client-Secret": "wD6dHhbcSs"
        ]
        let parameters: [String: Any] = [
            "query": query,
            "sort": "sim", // sim or date
            "start": pivot, // 1 ~ 1000
            "display": "20", // 10 ~ 100
            "filter": "all" // all, large, medium, small
        ]
        return self.get(url, headers: headers, parameters: parameters, printBody: false)
    }
    
    // https://developers.google.com/custom-search/json-api/v1/reference/cse/list
    // template = "https://www.googleapis.com/customsearch/v1?
    // q={searchTerms}&
    // num={count?}&
    // start={startIndex?}&
    // lr={language?}&
    // safe={safe?}&
    // cx={cx?}&
    // cref={cref?}&
    // sort={sort?}&
    // filter={filter?}&
    // gl={gl?}&
    // cr={cr?}&
    // googlehost={googleHost?}&
    // c2coff={disableCnTwTranslation?}&
    // hq={hq?}&
    // hl={hl?}&
    // siteSearch={siteSearch?}&
    // siteSearchFilter={siteSearchFilter?}&
    // exactTerms={exactTerms?}&
    // excludeTerms={excludeTerms?}&
    // linkSite={linkSite?}&
    // orTerms={orTerms?}&
    // relatedSite={relatedSite?}&
    // dateRestrict={dateRestrict?}&
    // lowRange={lowRange?}&
    // highRange={highRange?}&
    // searchType={searchType}&
    // fileType={fileType?}&
    // rights={rights?}&
    // imgSize={imgSize?}&
    // imgType={imgType?}&
    // imgColorType={imgColorType?}&
    // imgDominantColor={imgDominantColor?}&
    // alt=json";
    func searchGoogleImage(with query: String, pivot: Int?) -> Single<ResponseGoogleImageSearch> {
        let url = "https://www.googleapis.com/customsearch/v1"
        var parameters: [String: Any] = [
            "q": query,
            "key": "AIzaSyCTdQn7PY1xP5d_Otz8O8aTvbCSslU7lBQ",
            "cx": "015032654831495313052:qzljc0expde",
            "searchType": "image",
            "num": 10 // 1~10만 허용.
        ]
        if let startIndex = pivot {
            parameters["start"] = startIndex
        }
        return self.get(url, parameters: parameters, printBody: false)
    }
}
