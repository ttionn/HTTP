//
//  HTTPStatus.swift
//  HTTP
//
//  Created by TTSY on 2018/9/3.
//  Copyright © 2018 TTSY. All rights reserved.
//

import Foundation

public enum HTTPStatus: Int {
    
    // Informational
    case `continue` = 100,
    switchingProtocols = 101
    
    // Successful
    case ok = 200,
    created = 201,
    accepted = 202,
    nonAuthoritativeInformation = 203,
    noContent = 204,
    resetContent = 205,
    partialContent = 206
    
    // Redirection
    case multipleChoices = 300,
    movedPermanently = 301,
    found = 302, seeOther = 303,
    notModified = 304,
    useProxy = 305,
    temporaryRedirect = 307
    
    // Client Error
    case badRequest = 400,
    unauthorized = 401,
    paymentRequired = 402,
    forbidden = 403,
    notFound = 404,
    methodNotAllowed = 405,
    notAcceptable = 406,
    proxyAuthenticationRequired = 407,
    requestTimeout = 408,
    conflict = 409,
    gone = 410,
    lengthRequired = 411,
    preconditionFailed = 412,
    requestEntityTooLarge = 413,
    requestUrlTooLong = 414,
    unsupportedMediaType = 415,
    requestedRangeNotSatisfiable = 416,
    expectationFailed = 417
    
    // Server Error
    case internalServerError = 500,
    notImplemented = 501,
    badGateway = 502,
    serviceUnavailable = 503,
    gatewayTimeout = 504,
    httpVersionNotSupported = 505
    
    // Unknown
    case unknown = 0
    
    init(code: Int) {
        self = HTTPStatus(rawValue: code) ?? .unknown
    }
    
    var isSuccessful: Bool {
        return rawValue >= 200 && rawValue < 300
    }
    
}

extension HTTPStatus: CustomStringConvertible {
    
    public var description: String {
        let meaning: String
        switch self {
        case .continue:
            meaning = "Continue"
        case .switchingProtocols:
            meaning = "Switching Protocols"
        case .ok:
            meaning = "OK"
        case .created:
            meaning = "Created"
        case .accepted:
            meaning = "Accepted"
        case .nonAuthoritativeInformation:
            meaning = "Non-Authoritative Information"
        case .noContent:
            meaning = "No Content"
        case .resetContent:
            meaning = "Reset Content"
        case .partialContent:
            meaning = "Partial Content"
        case .multipleChoices:
            meaning = "Multiple Choices"
        case .movedPermanently:
            meaning = "Moved Permanently"
        case .found:
            meaning = "Found"
        case .seeOther:
            meaning = "See Other"
        case .notModified:
            meaning = "Not Modified"
        case .useProxy:
            meaning = "Use Proxy"
        case .temporaryRedirect:
            meaning = "Temporary Redirect"
        case .badRequest:
            meaning = "Bad Request"
        case .unauthorized:
            meaning = "Unauthorized"
        case .paymentRequired:
            meaning = "Payment Required"
        case .forbidden:
            meaning = "Forbidden"
        case .notFound:
            meaning = "Not Found"
        case .methodNotAllowed:
            meaning = "Method Not Allowed"
        case .notAcceptable:
            meaning = "Not Acceptable"
        case .proxyAuthenticationRequired:
            meaning = "Proxy Authentication Required"
        case .requestTimeout:
            meaning = "Request Timeout"
        case .conflict:
            meaning = "Conflict"
        case .gone:
            meaning = "Gone"
        case .lengthRequired:
            meaning = "Length Required"
        case .preconditionFailed:
            meaning = "Precondition Failed"
        case .requestEntityTooLarge:
            meaning = "Request Entity Too Large"
        case .requestUrlTooLong:
            meaning = "Request-URL Too Long"
        case .unsupportedMediaType:
            meaning = "Unsupported Media Type"
        case .requestedRangeNotSatisfiable:
            meaning = "Requested Range Not Satisfiable"
        case .expectationFailed:
            meaning = "Expectation Failed"
        case .internalServerError:
            meaning = "Internal Server Error"
        case .notImplemented:
            meaning = "Not Implemented"
        case .badGateway:
            meaning = "Bad Gateway"
        case .serviceUnavailable:
            meaning = "Service Unavailable"
        case .gatewayTimeout:
            meaning = "Gateway Timeout"
        case .httpVersionNotSupported:
            meaning = "HTTP Version Not Supported"
        case .unknown:
            meaning = "Unknown"
        }
        return "\(self.rawValue) - " + meaning
    }
    
}
