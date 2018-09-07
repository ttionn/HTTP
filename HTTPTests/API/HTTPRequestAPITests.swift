//
//  HTTPRequestAPITests.swift
//  HTTPTests
//
//  Created by TTSY on 2018/9/7.
//  Copyright © 2018 TTSY. All rights reserved.
//

import XCTest
import HTTP

class HTTPRequestAPITests: XCTestCase {
    
    var sut: HTTPRequest!
    var http: HTTP!
    
    let fakeBase = "http://www.fake.com"
    let fakePath = "/fake/path"
    
    override func setUp() {
        super.setUp()
        
        http = HTTP(base: fakeBase)
        sut = http.dataRequest(path: fakePath)
    }
    
    func testGoForDataRequest() {
        let task = (sut as! HTTPDataRequest).go(completion: { _ in })
        XCTAssertNotNil(task)
    }
    
    func testGoForDataRequestWithParamsAndBodyData() {
        sut = http.dataRequest(path: fakePath, method: .post, params: ["key": "value"], headers: ["key": "value"], bodyData: Data())
        XCTAssertNotNil(sut)
        
        let task = (sut as! HTTPDataRequest).go { response in
            XCTAssertNotNil(response.error)
            XCTAssertEqual(response.error?.localizedDescription, "Params and bodyData should not be used together in POST request")
        }
        XCTAssertNotNil(task)
    }
    
    func testGoForFileRequest() {
        sut = http.fileRequest(downloadPath: fakePath, completed: { _, _ in })
        let task = (sut as! HTTPFileRequest).go()
        XCTAssertNotNil(task)
    }
    
    func testHttpRequestGroup() {
        let file = http.fileRequest(downloadPath: fakePath, completed: { _, _ in })
        let file2 = http.fileRequest(downloadPath: fakePath, completed: { _, _ in })
        let file3 = http.fileRequest(downloadPath: fakePath, completed: { _, _ in })
        
        var sequentialGroup = file --> file2
        XCTAssertNotNil(sequentialGroup)
        
        sequentialGroup = sequentialGroup --> file3
        XCTAssertNotNil(sequentialGroup)
        
        var concurrentGroup = file ||| file2
        XCTAssertNotNil(concurrentGroup)
        
        concurrentGroup = concurrentGroup ||| file3
        XCTAssertNotNil(concurrentGroup)
        
        // Other operators for request group
        sequentialGroup = file && file2 && file3
        XCTAssertNotNil(sequentialGroup)
        
        concurrentGroup = file || file2 || file3
        XCTAssertNotNil(concurrentGroup)
    }
    
    func testGoForRequestGroup() {
        let file = http.fileRequest(downloadPath: fakePath, completed: { _, _ in })
        let file2 = http.fileRequest(downloadPath: fakePath, completed: { _, _ in })
        let file3 = http.fileRequest(downloadPath: fakePath, completed: { _, _ in })
        
        let sequentialTasks = (file --> file2 --> file3).go()
        let concurrentTasks = (file ||| file2 ||| file3).go()
        XCTAssertEqual(sequentialTasks.count, 3)
        XCTAssertEqual(concurrentTasks.count, 3)
    }
    
    func testSetAuthorizationWithUsernameAndPassword() {
        sut = sut.setAuthorization(username: "username", password: "password")
        XCTAssertNotNil(sut)
    }
    
    func testSetAuthorizationWithBasicToken() {
        sut = sut.setAuthorization(basicToken: "Basic ABCDEFG")
        XCTAssertNotNil(sut)
    }
    
}
