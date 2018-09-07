//
//  URLSessionManagerTests.swift
//  HTTPTests
//
//  Created by TTSY on 2018/9/7.
//  Copyright © 2018 TTSY. All rights reserved.
//

import XCTest
@testable import HTTP

class URLSessionManagerTests: XCTestCase {
    
    var sut: URLSessionManager!
    
    let fakeBase = "http://www.fake.com"
    let fakePath = "/fake/path"
    let fakeURL = URL(string: "www.file.com")!
    let session = URLSession.shared
    
    override func setUp() {
        super.setUp()
        
        sut = URLSessionManager.shared
    }
    
    func testShared() {
        XCTAssertNotNil(sut)
    }
    
    func testGetSessionForStandard() {
        let standard = sut.getSession(with: .standard)
        let standard2 = sut.getSession(with: .standard)
        
        XCTAssertEqual(standard, standard2)
    }
    
    func testGetSessionForEphmeral() {
        let ephemeral = sut.getSession(with: .ephemeral)
        let ephemeral2 = sut.getSession(with: .ephemeral)
        
        XCTAssertEqual(ephemeral, ephemeral2)
    }
    
    func testGetSessionForBackground() {
        let background = sut.getSession(with: .background("background"))
        let background2 = sut.getSession(with: .background("background"))
        let background3 = sut.getSession(with: .background("background3"))
        
        XCTAssertEqual(background, background2)
        XCTAssertNotEqual(background, background3)
    }
    
    func testSubscriptForSessionTasks() {
        let sessionTask = URLSessionTask()
        let httpTask = HTTPFileTask(request: URLRequest(url: fakeURL), session: session, taskType: .download, progress: nil, completed: nil)
        
        sut[sessionTask] = httpTask
        
        XCTAssertNotNil(sut[sessionTask])
    }
    
    func testSubscriptForRequestGroup() {
        let fileRequest = HTTPFileRequest(base: fakeBase, path: fakePath, method: .get, params: nil, headers: nil, sessionConfig: .standard, taskType: .download, completed: nil)
        let fileRequest2 = HTTPFileRequest(base: fakeBase, path: fakePath, method: .get, params: nil, headers: nil, sessionConfig: .standard, taskType: .download, completed: nil)
        let requestGroup = HTTPRequestGroup(lhs: fileRequest, rhs: fileRequest2, type: .concurrent)
        
        let fileTask = HTTPFileTask(request: URLRequest(url: fakeURL), session: session, taskType: .download, progress: nil, completed: nil)
        sut[fileTask] = requestGroup
        
        XCTAssertNotNil(sut[fileTask])
    }
    
    func testReset() {
        let session = sut.getSession(with: .standard)
        sut.reset()
        let newSession = sut.getSession(with: .standard)
        
        XCTAssertNotEqual(session, newSession)
    }
    
    func testSessionTimeout() {
        sut.reset()
        var session = sut.getSession(with: .standard, timeoutForRequest: 15.0, timeoutForResource: 15.0)
        XCTAssertEqual(session.configuration.timeoutIntervalForRequest, 15.0)
        XCTAssertEqual(session.configuration.timeoutIntervalForResource, 15.0)
        
        session = sut.getSession(with: .ephemeral, timeoutForRequest: 15.0, timeoutForResource: 15.0)
        XCTAssertEqual(session.configuration.timeoutIntervalForRequest, 15.0)
        XCTAssertEqual(session.configuration.timeoutIntervalForResource, 15.0)
    }
    
    func testBackgroundSessionTimeout() {
        sut.reset()
        let session = sut.getSession(with: .background("background"), timeoutForRequest: 15.0, timeoutForResource: 15.0)
        XCTAssertEqual(session.configuration.timeoutIntervalForRequest, 15.0)
        XCTAssertEqual(session.configuration.timeoutIntervalForResource, 15.0)
    }
    
}
