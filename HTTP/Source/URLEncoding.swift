//
//  URLEncoding.swift
//  HTTP
//
//  Created by TTSY on 2018/9/3.
//  Copyright © 2018 TTSY. All rights reserved.
//

import Foundation

struct URLEncoding {
    
    static func encode(base: String, path: String, method: HTTPMethod, params: [String: Any]?) throws -> URL {
        
        var urlString = base + path
        
        if urlString.contains(" ") {
            if let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                urlString = encodedString
            }
        }
        
        guard let url = URL(string: urlString) else {
            throw URLEncodingError.invalidURL(base + path)
        }
        
        guard let urlComponents = URLComponents(string: urlString) else {
            throw URLEncodingError.invalidURL(base + path)
        }
        
        if case .get = method, let parameters = params {
            let queryString = composeQuery(urlComponents, with: parameters)
            guard let encodedQueryString = queryString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                throw URLEncodingError.invalidParams(parameters)
            }
            
            guard let encodedURL = URL(string: url.absoluteString + encodedQueryString) else {
                throw URLEncodingError.invalidURL(url.absoluteString + queryString)
            }
            return encodedURL
        }
        
        return url
    }
    
    private static func composeQuery(_ urlComponents: URLComponents, with params: [String: Any]) -> String {
        var queryString = "?"
        
        if let query = urlComponents.query {
            queryString = query.hasSuffix("&") ? "" : "&"
        }
        
        for (key, value) in params {
            queryString += "\(key)=\(value)&"
        }
        return queryString
    }
    
}
