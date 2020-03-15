import RxSwift

@testable import Model

class SearchApiMock: SearchApiProtocol {
    
    var json: String?
    
    func searchDaumImage(with query: String, pivot: Int) -> Single<ResponseDaumImageSearch> {
        return .never()
    }
    
    func searchNaverImage(with query: String, pivot: Int) -> Single<ResponseNaverImageSearch> {
        return .never()
    }
    
    func searchGoogleImage(with query: String, pivot: Int?) -> Single<ResponseGoogleImageSearch> {
        return .never()
    }
}
