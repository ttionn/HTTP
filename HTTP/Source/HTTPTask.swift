//
//  HTTPTask.swift
//  HTTP
//
//  Created by TTSY on 2018/9/3.
//  Copyright © 2018 TTSY. All rights reserved.
//

import Foundation

enum TaskType {
    case data
    case download
    case upload(MultiPartContent)
}

public enum TaskState {
    case running
    case suspended
    case canceling
    case completed
    
    init(_ sessionTask: URLSessionTask) {
        switch sessionTask.state {
        case .running:
            self = .running
        case .suspended:
            self = .suspended
        case .canceling:
            self = .canceling
        case .completed:
            self = .completed
        }
    }
}

public protocol HTTPTask {
    var state: TaskState { get }
    
    func suspend()
    func resume()
    func cancel()
}

class HTTPDataTask: HTTPTask {
    
    let sessionTask: URLSessionTask
    
    var state: TaskState {
        return TaskState(sessionTask)
    }
    
    /* ✅ */
    init(request: URLRequest, session: URLSession, taskType: TaskType = .data, completion: @escaping (HTTPResponse) -> Void) {
        
        switch taskType {
        case .data:
            sessionTask = session.dataTask(with: request) { (data, response, error) in
                let httpResponse = HTTPResponse(data: data, response: response, error: error)
                completion(httpResponse)
            }
        case .download:
            sessionTask = session.downloadTask(with: request) { (url, response, error) in
                let httpResponse = HTTPResponse(url: url, response: response, error: error)
                completion(httpResponse)
            }
        case .upload(let content):
            if let url = content.url {
                sessionTask = session.uploadTask(with: request, fromFile: url) { (data, response, error) in
                    let httpResponse = HTTPResponse(data: data, response: response, error: error)
                    completion(httpResponse)
                }
            } else {
                sessionTask = session.uploadTask(with: request, from: request.httpBody) { (data, response, error) in
                    let httpResponse = HTTPResponse(data: data, response: response, error: error)
                    completion(httpResponse)
                }
            }
        }
    }
    
    func suspend() {
        sessionTask.suspend()
    }
    
    func resume() {
        sessionTask.resume()
    }
    
    func cancel() {
        sessionTask.cancel()
    }
    
}

extension HTTPFileTask: Hashable {
    var hashValue: Int {
        return sessionTask.taskIdentifier
    }
    
    static func ==(lhs: HTTPFileTask, rhs: HTTPFileTask) -> Bool {
        return lhs.sessionTask == rhs.sessionTask
    }
}

class HTTPFileTask: HTTPTask {
    
    let sessionTask: URLSessionTask
    
    let taskType: TaskType
    let progress: ProgressClosure?
    let completed: CompletedClosure?
    
    var state: TaskState {
        return TaskState(sessionTask)
    }
    
    /* ✅ */
    init(request: URLRequest, session: URLSession, taskType: TaskType, progress: ProgressClosure?, completed:  CompletedClosure?) {
        self.taskType = taskType
        self.progress = progress
        self.completed = completed
        
        switch taskType {
        case .data:
            // No need for data taskType
            fatalError("HttpFileTask only could be initialized by download or upload tsakType")
        case .download:
            sessionTask = session.downloadTask(with: request)
        case .upload(let content):
            if let url = content.url {
                sessionTask = session.uploadTask(with: request, fromFile: url)
            } else {
                guard let bodyData = request.httpBody else {
                    fatalError("Upload task from bodyData needs request's httpBody")
                }
                sessionTask = session.uploadTask(with: request, from: bodyData)
            }
        }
    }
    
    func suspend() {
        sessionTask.suspend()
    }
    
    func resume() {
        sessionTask.resume()
    }
    
    func cancel() {
        sessionTask.cancel()
    }
    
}

class BlankHTTPTask: HTTPTask {
    var state: TaskState {
        return .suspended
    }
    
    func suspend() {}
    func resume() {}
    func cancel() {}
}
