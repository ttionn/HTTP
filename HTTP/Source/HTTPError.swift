//
//  HTTPError.swift
//  HTTP
//
//  Created by TTSY on 2018/9/3.
//  Copyright © 2018 TTSY. All rights reserved.
//

import Foundation

public enum HTTPError: Error {
    case requestError(HTTPRequestError)
    case encodingError(URLEncodingError)
    case statusError(HTTPStatus)
    case responseError(Error)
}

public enum HTTPRequestError {
    case paramsAndBodyDataUsedTogether(String)
    case dataRequestInBackgroundSession
    case emptyURLRequest
}

public enum URLEncodingError: Error {
    case invalidURL(String)
    case invalidParams([String: Any])
}

extension HTTPError: LocalizedError, CustomStringConvertible {
    
    public var localizedDescription: String {
        switch self {
        case .requestError(let error):
            return error.localizedDescription
        case .encodingError(let error):
            return error.localizedDescription
        case .responseError(let error):
            return error.localizedDescription
        case .statusError(let statusCode):
            return "HTTP status code: \(statusCode)"
        }
    }
    
    public var description: String {
        return localizedDescription
    }
    
}

extension HTTPRequestError: LocalizedError, CustomStringConvertible {
    
    public var localizedDescription: String {
        switch self {
        case .paramsAndBodyDataUsedTogether(let method):
            return "Params and bodyData should not be used together in \(method) request"
        case .dataRequestInBackgroundSession:
            return "Data request can't run in background session"
        case .emptyURLRequest:
            return "URLRequest is nil"
        }
    }
    
    public var description: String {
        return localizedDescription
    }
    
}

extension URLEncodingError: LocalizedError, CustomStringConvertible {
    
    public var localizedDescription: String {
        switch self {
        case .invalidURL(let urlString):
            return "Invalid url: \(urlString)"
        case .invalidParams(let params):
            return "Invalid params: \(params)"
        }
    }
    
    public var description: String {
        return localizedDescription
    }
    
}
