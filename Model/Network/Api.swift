import Alamofire
import AnyCodable
import BoxKit

typealias RawJSON = [String: AnyDecodable]
typealias ApiCompletion<T> = (Code, T?) -> Void

class Api {
    
    static let shared = Api()
    
    func get<T: Decodable>(_ url: String, headers: HTTPHeaders? = nil, parameters: [String: Any]?, completion: @escaping ApiCompletion<T>, printBody: Bool) {
        let method: HTTPMethod = .get
        let encoding: ParameterEncoding = URLEncoding.queryString
        self.request(url, method: method, headers: headers, encoding: encoding, parameters: parameters, completion: completion, printBody: printBody)
    }
    
    private func request<T: Decodable>(_ url: String, method: HTTPMethod, headers: HTTPHeaders?, encoding: ParameterEncoding, parameters: [String: Any]?, completion: @escaping ApiCompletion<T>, printBody: Bool) {
        let request = AF.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
        request.validate().log(printBody)
        request.responseData(completionHandler: { (response) in
            let decodedUrl = response.decodedUrl
            let code = Code(value: response.response?.statusCode)
            switch response.result {
            case .success(let data):
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    Log.i("[\(method.rawValue)] \(decodedUrl)")
                    completion(code, result)
                    return
                } catch {
                    Log.e("[\(method.rawValue) failure(\(code))] \(decodedUrl)")
                    if let error = error as? DecodingError {
                        Log.e("[Decoding Error]: \(error.debugDescription)")
                    } else {
                        Log.e("[Error]: \(error.localizedDescription)")
                    }
                    completion(code, nil)
                }
            case .failure(let error):
                Log.e("[\(method.rawValue) failure(\(code))] \(decodedUrl)")
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
    
    fileprivate var decodedUrl: String {
        return (self.response?.url?.absoluteString ?? "[EMPTY URL]").urlDecoded
    }
    
    fileprivate func log(_ on: Bool) {
        #if DEBUG
        if on {
            debugPrint(self)
            guard let data = self.data else { return }
            guard let json = try? JSONSerialization.jsonObject(with: data) else { return }
            debugPrint(json)
        }
        #endif
    }
}
