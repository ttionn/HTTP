//
//  HTTP.swift
//  HTTP
//
//  Created by TTSY on 2018/9/3.
//  Copyright © 2018 TTSY. All rights reserved.
//

import Foundation

public enum SessionConfig {
    case standard
    case ephemeral
    case background(String)
}

public enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case head = "HEAD"
    case delete = "DELETE"
}

public struct HTTP {
    
    let base: String
    let config: SessionConfig
    
    var isFake = false
    
    public var fakeResponse: HTTPResponse?
    
    public var timeoutForRequest: TimeInterval = 60.0
    public var timeoutForResource: TimeInterval = 7 * 24 * 60.0
    
    /* ✅ */
    public init(base: String, config: SessionConfig = .standard) {
        self.base = base
        self.config = config
    }
    
    // MARK: - HTTP Methods
    
    /* ✅ */
    @discardableResult
    public func get(_ path: String, params: [String: Any]? = nil, headers: [String: String]? = nil, completion: @escaping (HTTPResponse) -> Void) -> HTTPTask {
        guard fakeResponse == nil else {
            completion(fakeResponse!)
            return BlankHTTPTask()
        }
        return dataRequest(path: path, method: .get, params: params, headers: headers).go(completion: completion)
    }
    
    /* ✅ */
    @discardableResult
    public func put(_ path: String, params: [String: Any]? = nil, headers: [String: String]? = nil, completion: @escaping (HTTPResponse) -> Void) -> HTTPTask {
        guard fakeResponse == nil else {
            completion(fakeResponse!)
            return BlankHTTPTask()
        }
        return dataRequest(path: path, method: .put, params: params, headers: headers).go(completion: completion)
    }
    
    /* ✅ */
    @discardableResult
    public func post(_ path: String, headers: [String: String]? = nil, completion: @escaping (HTTPResponse) -> Void) -> HTTPTask {
        guard fakeResponse == nil else {
            completion(fakeResponse!)
            return BlankHTTPTask()
        }
        return dataRequest(path: path, method: .post, headers: headers, bodyData: nil).go(completion: completion)
    }
    
    /* ✅ */
    @discardableResult
    public func post(_ path: String, params: [String: Any]?, headers: [String: String]? = nil, completion: @escaping (HTTPResponse) -> Void) -> HTTPTask {
        guard fakeResponse == nil else {
            completion(fakeResponse!)
            return BlankHTTPTask()
        }
        return dataRequest(path: path, method: .post, params: params, headers: headers).go(completion: completion)
    }
    
    /* ✅ */
    @discardableResult
    public func post(_ path: String, bodyData: Data?, headers: [String: String]? = nil, completion: @escaping (HTTPResponse) -> Void) -> HTTPTask {
        guard fakeResponse == nil else {
            completion(fakeResponse!)
            return BlankHTTPTask()
        }
        return dataRequest(path: path, method: .post, headers: headers, bodyData: bodyData).go(completion: completion)
    }
    
    /* ✅ */
    @discardableResult
    public func delete(_ path: String, params: [String: Any]? = nil, headers: [String: String]? = nil, completion: @escaping (HTTPResponse) -> Void)-> HTTPTask {
        guard fakeResponse == nil else {
            completion(fakeResponse!)
            return BlankHTTPTask()
        }
        return dataRequest(path: path, method: .delete, params: params, headers: headers).go(completion: completion)
    }
    
    // MARK: - Advanced Methods
    
    /* ✅ */
    public func dataRequest(path: String, method: HTTPMethod = .get, params: [String: Any]? = nil, headers: [String: String]? = nil, bodyData: Data? = nil) -> HTTPDataRequest {
        let request: HTTPDataRequest
        if (isFake) {
            request = FakeDataRequest(base: base, path: path, method: method, params: params, headers: headers, sessionConfig: config, bodyData: bodyData)
            return request
        }
        
        request = HTTPDataRequest(base: base, path: path, method: method, params: params, headers: headers, sessionConfig: config, timeoutForRequest: timeoutForRequest, timeoutForResource: timeoutForResource, bodyData: bodyData)
        
        // URLSession dataTasks can not run on background session
        if case .background(_) = config {
            request.httpError = HTTPError.requestError(.dataRequestInBackgroundSession)
        }
        
        // URLRequest httpBody information retrieves from either params or bodyData, but not both.
        if params != nil && bodyData != nil && method != .get {
            request.httpError = HTTPError.requestError(.paramsAndBodyDataUsedTogether(method.rawValue))
        }
        return request
    }
    
    /* ✅ */
    @discardableResult
    public func download(_ path: String, params: [String: Any]? = nil, headers: [String: String]? = nil, completion: @escaping (HTTPResponse) -> Void) -> HTTPTask {
        guard fakeResponse == nil else {
            completion(fakeResponse!)
            return BlankHTTPTask()
        }
        
        let request: HTTPDataRequest
        if (isFake) {
            request = FakeDataRequest(base: base, path: path, method: .get, params: params, headers: headers, sessionConfig: config, taskType: .download)
            return request.go(completion: completion)
        }
        
        request = HTTPDataRequest(base: base, path: path, method: .get, params: params, headers: headers, sessionConfig: config, timeoutForRequest: timeoutForRequest, timeoutForResource: timeoutForResource, taskType: .download)
        
        return request.go(completion: completion)
    }
    
    /* ✅ */
    @discardableResult
    public func upload(_ path: String, content: MultiPartContent, params: [String: Any]? = nil, headers: [String: String]? = nil, completion: @escaping (HTTPResponse) -> Void) -> HTTPTask {
        guard fakeResponse == nil else {
            completion(fakeResponse!)
            return BlankHTTPTask()
        }
        
        let request: HTTPDataRequest
        if (isFake) {
            request = FakeDataRequest(base: base, path: path, method: .post, params: params, headers: headers, sessionConfig: config, taskType: .upload(content))
            return request.go(completion: completion)
        }
        
        request = HTTPDataRequest(base: base, path: path, method: .post, params: params, headers: headers, sessionConfig: config, timeoutForRequest: timeoutForRequest, timeoutForResource: timeoutForResource, taskType: .upload(content))
        
        return request.go(completion: completion)
    }
    
    /* ✅ */
    public func fileRequest(downloadPath: String, method: HTTPMethod = .get, params: [String: Any]? = nil, headers: [String: String]? = nil, progress: ProgressClosure? = nil, completed: @escaping CompletedClosure) -> HTTPFileRequest {
        return HTTPFileRequest(base: base, path: downloadPath, method: method, params: params, headers: headers, sessionConfig: config, taskType: .download, progress: progress, completed: completed)
    }
    
    /* ✅ */
    public func fileRequest(uploadPath: String, method: HTTPMethod = .post, content: MultiPartContent, params: [String: Any]? = nil, headers: [String: String]? = nil, progress: ProgressClosure? = nil, completed: @escaping CompletedClosure) -> HTTPFileRequest {
        return HTTPFileRequest(base: base, path: uploadPath, method: method, params: params, headers: headers, sessionConfig: config, taskType: .upload(content), progress: progress, completed: completed)
    }
    
}
