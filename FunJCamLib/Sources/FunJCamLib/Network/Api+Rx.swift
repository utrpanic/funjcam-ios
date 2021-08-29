import BinaryPackages
import Alamofire
import RxSwift

struct ApiError: Error {
    
    var code: Code
}

extension Api {
    
    func get<T: Decodable>(_ url: String, headers: HTTPHeaders? = nil, parameters: [String: Any]?, printBody: Bool) -> Single<T> {
        return Single.create { event -> Disposable in
            self.get(url, headers: headers, parameters: parameters, completion: { (code: Code, response: T?) in
                if code.isSucceed, let response = response {
                    event(.success(response))
                } else {
                    let error = ApiError(code: code)
                    event(.failure(error))
                }
            }, printBody: printBody)
            return Disposables.create()
        }
    }
}
