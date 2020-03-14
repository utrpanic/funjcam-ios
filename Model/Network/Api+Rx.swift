import RxSwift

struct ApiError: Error {
    
    var code: Code
}

extension Api {
    
    func get<T: Decodable>(url: String, parameters: [String: Any]?, printBody: Bool) -> Single<T> {
        return Single.create { event -> Disposable in
            self.get(url, parameters: parameters, completion: { (code: Code, response: T?) in
                if code.isSucceed, let response = response {
                    event(.success(response))
                } else {
                    let error = ApiError(code: code)
                    event(.error(error))
                }
            }, printBody: printBody)
            return Disposables.create()
        }
    }
}
