import Alamofire
import BoxKit

typealias RawJSON = [String: AnyDecodable]
typealias ApiCompletion<T> = (Code, T?) -> Void

class Api {
    
    static let shared = Api()
    
    func get<T: Decodable>(_ url: String, headers: HTTPHeaders? = nil, parameters: [String: Any]?, completion: @escaping ApiCompletion<T>, printBody: Bool) {
        let method: HTTPMethod = .get
        let encoding: ParameterEncoding = URLEncoding.queryString
        let request = AF.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
        request.validate().log(printBody)
        request.responseData(completionHandler: { (response) in
            let code = Code(value: response.response?.statusCode)
            switch response.result {
            case .success(let data):
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    Log.i("[\(method.rawValue)] \(url)")
                    completion(code, result)
                    return
                } catch {
                    Log.e("[\(method.rawValue) failure(\(code))] \(url)")
                    if let error = error as? DecodingError {
                        Log.e("[Decoding Error]: \(error.debugDescription)")
                    } else {
                        Log.e("[Error]: \(error.localizedDescription)")
                    }
                    completion(code, nil)
                }
            case .failure(let error):
                Log.e("[\(method.rawValue) failure(\(code))] \(url)")
                Log.e("[Error]: \(error.localizedDescription)")
                completion(code, nil)
            }
            response.log(printBody)
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
            if let data = self.data {
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
