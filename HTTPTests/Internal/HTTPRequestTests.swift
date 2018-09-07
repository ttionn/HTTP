//
//  HTTPRequestTests.swift
//  HTTPTests
//
//  Created by TTSY on 2018/9/7.
//  Copyright © 2018 TTSY. All rights reserved.
//

import XCTest
@testable import HTTP

class HTTPRequestTests: XCTestCase {
    
    var sut: HTTPRequest!
    
    let fakeBase = "http://www.fake.com"
    let fakePath = "/fake/path"
    
    override func setUp() {
        sut = HTTPRequest(base: fakeBase, path: fakePath, method: .put, params: ["key": "value"], headers: ["key": "value"], sessionConfig: .standard)
    }
    
    func testInit() {
        XCTAssertEqual(sut.base, fakeBase)
        XCTAssertEqual(sut.path, fakePath)
        XCTAssertEqual(sut.method, .put)
        XCTAssertEqual(sut.params!["key"] as! String, "value")
        XCTAssertEqual(sut.headers!["key"], "value")
        XCTAssertEqual(sut.session, URLSessionManager.shared.getSession(with: .standard))
        XCTAssertNotNil(sut.urlRequest)
    }
    
    func testDataRequest() {
        sut = HTTPDataRequest(base: fakeBase, path: fakePath, method: .get, params: ["key": "value"], headers: ["key": "value"], sessionConfig: .standard, bodyData: Data(), taskType: .data)
        XCTAssertEqual((sut as! HTTPDataRequest).bodyData, Data())
        XCTAssertEqual((sut as! HTTPDataRequest).taskType, .data)
        
        sut = HTTPDataRequest(base: fakeBase, path: fakePath, method: .get, params: nil, headers: nil, sessionConfig: .standard, taskType: .download)
        XCTAssertEqual((sut as! HTTPDataRequest).taskType, .download)
        
        let content = MultiPartContent(name: "", fileName: "", type: .png, data: Data())
        sut = HTTPDataRequest(base: fakeBase, path: fakePath, method: .get, params: nil, headers: nil, sessionConfig: .standard, taskType: .upload(content))
        XCTAssertEqual((sut as! HTTPDataRequest).taskType, .upload(content))
    }
    
    func testDataRequestWithTimeout() {
        URLSessionManager.shared.reset()
        sut = HTTPDataRequest(base: fakeBase, path: fakePath, method: .get, params: ["key": "value"], headers: ["key": "value"], sessionConfig: .standard, timeoutForRequest: 15.0, timeoutForResource: 15.0, bodyData: Data(), taskType: .data)
        
        XCTAssertEqual(sut.session.configuration.timeoutIntervalForRequest, 15.0)
        XCTAssertEqual(sut.session.configuration.timeoutIntervalForResource, 15.0)
    }
    
    func testGoForDataRequest() {
        sut = HTTPDataRequest(base: fakeBase, path: fakePath, method: .get, params: nil, headers: nil, sessionConfig: .ephemeral, bodyData: nil)
        
        (sut as! HTTPDataRequest).go(completion: { _ in })
        let httpTask = (sut as! HTTPDataRequest).go(completion: { _ in })
        XCTAssert(httpTask is HTTPDataTask)
    }
    
    func testFakeDataRequest() {
        sut = FakeDataRequest(base: fakeBase, path: fakePath, method: .get, params: ["key": "value"], headers: ["key": "value"], sessionConfig: .standard, bodyData: Data(), taskType: .data)
        XCTAssertEqual(sut.base, fakeBase)
        XCTAssertEqual(sut.path, fakePath)
        XCTAssertEqual(sut.method, .get)
        XCTAssertEqual(sut.params!["key"] as! String, "value")
        XCTAssertEqual(sut.headers!["key"], "value")
        XCTAssertEqual(sut.session, URLSessionManager.shared.getSession(with: .standard))
        XCTAssertEqual((sut as! HTTPDataRequest).bodyData, Data())
        XCTAssertEqual((sut as! HTTPDataRequest).taskType, .data)
    }
    
    func testFileRequest() {
        let progress: ProgressClosure = { _, _, _ in }
        let completed: CompletedClosure = { _, _ in }
        
        sut = HTTPFileRequest(base: fakeBase, path: fakePath, method: .get, params: ["key": "value"], headers: ["key": "value"], sessionConfig: .standard, taskType: .download, progress: progress, completed: completed)
        XCTAssertEqual(sut.base, fakeBase)
        XCTAssertEqual(sut.path, fakePath)
        XCTAssertEqual(sut.method, .get)
        XCTAssertEqual(sut.params!["key"] as! String, "value")
        XCTAssertEqual(sut.headers!["key"], "value")
        XCTAssertEqual(sut.session, URLSessionManager.shared.getSession(with: .standard))
        XCTAssertNotNil(sut.urlRequest)
        XCTAssertEqual((sut as! HTTPFileRequest).taskType, .download)
        XCTAssertNotNil((sut as! HTTPFileRequest).progress)
        XCTAssertNotNil((sut as! HTTPFileRequest).completed)
        XCTAssertEqual((sut as! HTTPFileRequest).sessionManager, URLSessionManager.shared)
        
        let content = MultiPartContent(name: "", fileName: "", type: .png, data: Data())
        sut = HTTPFileRequest(base: fakeBase, path: fakePath, method: .post, params: ["key": "value"], headers: ["key": "value"], sessionConfig: .background("bg"), taskType: .upload(content), progress: progress, completed: completed)
        XCTAssertEqual(sut.method, .post)
        XCTAssertEqual(sut.session, URLSessionManager.shared.getSession(with: .background("bg")))
        XCTAssertEqual((sut as! HTTPFileRequest).taskType, .upload(content))
        XCTAssertNotNil((sut as! HTTPFileRequest).progress)
        XCTAssertNotNil((sut as! HTTPFileRequest).completed)
        XCTAssertEqual((sut as! HTTPFileRequest).sessionManager, URLSessionManager.shared)
    }
    
    func testGoForFileRequest() {
        sut = HTTPFileRequest(base: fakeBase, path: fakePath, method:.get, params: nil, headers: nil, sessionConfig: .background("bg"), taskType: .download, completed: nil)
        
        (sut as! HTTPFileRequest).go()
        let task = (sut as! HTTPFileRequest).go()
        XCTAssert(task is HTTPFileTask)
        
        let sessionManager = URLSessionManager.shared
        let fileTask = task as! HTTPFileTask
        let savedTask: HTTPTask = sessionManager[fileTask.sessionTask]!
        XCTAssertNotNil(savedTask)
    }
    
    func testRequestGroup() {
        let fileRequest = HTTPFileRequest(base: fakeBase, path: fakePath, method: .get, params: nil, headers: nil, sessionConfig: .standard, taskType: .download, completed: nil)
        let fileRequest2 = HTTPFileRequest(base: fakeBase, path: fakePath, method: .get, params: nil, headers: nil, sessionConfig: .standard, taskType: .download, completed: nil)
        let fileRequest3 = HTTPFileRequest(base: fakeBase, path: fakePath, method: .get, params: nil, headers: nil, sessionConfig: .standard, taskType: .download, completed: nil)
        
        let group = HTTPRequestGroup(lhs: fileRequest, rhs: fileRequest2, type: .sequential)
        XCTAssertFalse(group.isEmpty)
        XCTAssertEqual(group.type, .sequential)
        
        _ = group.append(fileRequest3)
        XCTAssertFalse(group.isEmpty)
        
        let tasks = group.go()
        XCTAssertEqual(tasks.count, 3)
    }
    
    func testGoForSequentialRequestGroup() {
        let file = HTTPFileRequest(base: fakeBase, path: fakePath, method: .get, params: nil, headers: nil, sessionConfig: .standard, taskType: .download, completed: nil)
        let file2 = HTTPFileRequest(base: fakeBase, path: fakePath, method: .get, params: nil, headers: nil, sessionConfig: .standard, taskType: .download, completed: nil)
        let file3 = HTTPFileRequest(base: fakeBase, path: fakePath, method: .get, params: nil, headers: nil, sessionConfig: .standard, taskType: .download, completed: nil)
        
        let tasks = (file --> file2 --> file3).go()
        
        XCTAssertEqual(tasks.count, 3)
        XCTAssertEqual((tasks[0] as! HTTPFileTask).state, .running)
        XCTAssertEqual((tasks[1] as! HTTPFileTask).state, .suspended)
        XCTAssertEqual((tasks[2] as! HTTPFileTask).state, .suspended)
    }
    
    func testGoForConcurrentRequestGroup() {
        let file = HTTPFileRequest(base: fakeBase, path: fakePath, method: .get, params: nil, headers: nil, sessionConfig: .standard, taskType: .download, completed: nil)
        let file2 = HTTPFileRequest(base: fakeBase, path: fakePath, method: .get, params: nil, headers: nil, sessionConfig: .standard, taskType: .download, completed: nil)
        let file3 = HTTPFileRequest(base: fakeBase, path: fakePath, method: .get, params: nil, headers: nil, sessionConfig: .standard, taskType: .download, completed: nil)
        
        let tasks = (file ||| file2 ||| file3).go()
        
        XCTAssertEqual(tasks.count, 3)
        XCTAssertEqual((tasks[0] as! HTTPFileTask).state, .running)
        XCTAssertEqual((tasks[1] as! HTTPFileTask).state, .running)
        XCTAssertEqual((tasks[2] as! HTTPFileTask).state, .running)
    }
    
    func testSessionTaskDidComplete() {
        let file = HTTPFileRequest(base: fakeBase, path: fakePath, method: .get, params: nil, headers: nil, sessionConfig: .standard, taskType: .download, completed: nil)
        let file2 = HTTPFileRequest(base: fakeBase, path: fakePath, method: .get, params: nil, headers: nil, sessionConfig: .standard, taskType: .download, completed: nil)
        let file3 = HTTPFileRequest(base: fakeBase, path: fakePath, method: .get, params: nil, headers: nil, sessionConfig: .standard, taskType: .download, completed: nil)
        
        let group = file --> file2 --> file3
        let tasks = group.go()
        
        XCTAssertEqual(tasks.count, 3)
        XCTAssertEqual((tasks[0] as! HTTPFileTask).state, .running)
        XCTAssertEqual((tasks[1] as! HTTPFileTask).state, .suspended)
        XCTAssertEqual((tasks[2] as! HTTPFileTask).state, .suspended)
        
        group.nextTask()
        XCTAssertEqual((tasks[1] as! HTTPFileTask).state, .running)
        XCTAssertEqual((tasks[2] as! HTTPFileTask).state, .suspended)
        
        group.nextTask()
        XCTAssertEqual((tasks[2] as! HTTPFileTask).state, .running)
    }
    
    func testSetAuthorizationWithUsernameAndPassword() {
        let loginString = "username:password"
        let loginData = loginString.data(using: .utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        _ = sut.setAuthorization(username: "username", password: "password")
        
        XCTAssertEqual(sut.urlRequest?.value(forHTTPHeaderField: "Authorization"), "Basic \(base64LoginString)")
    }
    
    func testSetAuthorizationWithBasicToken() {
        _ = sut.setAuthorization(basicToken: "ABC")
        
        XCTAssertEqual(sut.urlRequest?.value(forHTTPHeaderField: "Authorization"), "Basic ABC")
    }
    
}
