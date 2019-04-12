//
//  HttpStatusCode.swift
//  BoxJeonExtension
//
//  Created by boxjeon on 2018. 5. 3..
//  Copyright © 2018년 boxjeon. All rights reserved.
//

// https://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html
open class HttpStatusCode: Equatable, CustomStringConvertible {
    
    // Informational 1xx
    static var `continue`: HttpStatusCode { return HttpStatusCode(value: 100) }
    static var switchingProtocol: HttpStatusCode { return HttpStatusCode(value: 101) }
    
    // Successful 2xx
    static var ok: HttpStatusCode { return HttpStatusCode(value: 200) }
    static var created: HttpStatusCode { return HttpStatusCode(value: 201) }
    static var accepted: HttpStatusCode { return HttpStatusCode(value: 202) }
    static var nonAuthoritativeInformation: HttpStatusCode { return HttpStatusCode(value: 203) }
    static var noContent: HttpStatusCode { return HttpStatusCode(value: 204) }
    static var resetContent: HttpStatusCode { return HttpStatusCode(value: 205) }
    static var partialContent: HttpStatusCode { return HttpStatusCode(value: 206) }
    
    // Redirection 3xx
    static var multipleChoices: HttpStatusCode { return HttpStatusCode(value: 300) }
    static var movedPermanently: HttpStatusCode { return HttpStatusCode(value: 301) }
    static var found: HttpStatusCode { return HttpStatusCode(value: 302) }
    static var seeOther: HttpStatusCode { return HttpStatusCode(value: 303) }
    static var notModified: HttpStatusCode { return HttpStatusCode(value: 304) }
    static var useProxy: HttpStatusCode { return HttpStatusCode(value: 305) }
    static var temporaryRedirect: HttpStatusCode { return HttpStatusCode(value: 307) }
    
    // Client Error 4xx
    static var badRequest: HttpStatusCode { return HttpStatusCode(value: 400) }
    static var unauthorized: HttpStatusCode { return HttpStatusCode(value: 401) }
    static var paymentRequired: HttpStatusCode { return HttpStatusCode(value: 402) }
    static var forbidden: HttpStatusCode { return HttpStatusCode(value: 403) }
    static var notFound: HttpStatusCode { return HttpStatusCode(value: 404) }
    static var methodNotAllowed: HttpStatusCode { return HttpStatusCode(value: 405) }
    static var notAcceptable: HttpStatusCode { return HttpStatusCode(value: 406) }
    static var proxyAuthenticationRequired: HttpStatusCode { return HttpStatusCode(value: 407) }
    static var requestTimeout: HttpStatusCode { return HttpStatusCode(value: 408) }
    static var conflict: HttpStatusCode { return HttpStatusCode(value: 409) }
    static var gone: HttpStatusCode { return HttpStatusCode(value: 410) }
    static var lengthRequired: HttpStatusCode { return HttpStatusCode(value: 411) }
    static var preconditionFailed: HttpStatusCode { return HttpStatusCode(value: 412) }
    static var requestEntityTooLarge: HttpStatusCode { return HttpStatusCode(value: 413) }
    static var requestUriTooLong: HttpStatusCode { return HttpStatusCode(value: 414) }
    static var unsupportedMediaType: HttpStatusCode { return HttpStatusCode(value: 415) }
    static var requestedRangeNotSatisfiable: HttpStatusCode { return HttpStatusCode(value: 416) }
    static var expectationFailed: HttpStatusCode { return HttpStatusCode(value: 417) }
    
    // Server Error 5xx
    static var internalServerError: HttpStatusCode { return HttpStatusCode(value: 500) }
    static var notImplemented: HttpStatusCode { return HttpStatusCode(value: 501) }
    static var badGateway: HttpStatusCode { return HttpStatusCode(value: 502) }
    static var ServiceUnavailable: HttpStatusCode { return HttpStatusCode(value: 503) }
    static var gatewayTimeout: HttpStatusCode { return HttpStatusCode(value: 504) }
    static var httpVersionNotSupported: HttpStatusCode { return HttpStatusCode(value: 505) }
    
    private let value: Int
    private let message: String
    
    public var isSucceed: Bool {
        return 200 <= self.value && self.value < 300
    }
    
    public init(value: Int?, message: String? = nil) {
        self.value = value ?? 0
        self.message = message ?? ""
    }
    
    // MARK: - Equatable
    public static func == (lhs: HttpStatusCode, rhs: HttpStatusCode) -> Bool {
        return lhs.value == rhs.value
    }
    
    // MARK: - CustomStringConvertible
    public var description: String {
        if self.message.isEmpty {
            return "[\(self.value)]"
        } else {
            return "[\(self.value): \(self.message)]"
        }
    }
}
