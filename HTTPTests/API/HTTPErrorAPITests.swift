//
//  HTTPErrorAPITests.swift
//  HTTPTests
//
//  Created by TTSY on 2018/9/7.
//  Copyright © 2018 TTSY. All rights reserved.
//

import XCTest
import HTTP

class HTTPErrorAPITests: XCTestCase {
    
    var sut: HTTP!
    
    let fakeBase = "http://www.fake.com"
    let fakePath = "/fake/path"
    
    override func setUp() {
        super.setUp()
        
        sut = HTTP(base: fakeBase)
    }
    
    func testInvalidURL() {
        sut = HTTP(base: "")
        sut.get("") { response in
            XCTAssertEqual(response.error?.localizedDescription, "Invalid url: ")
        }
    }
    
    func testDataRequestInBackgroundSession() {
        sut = HTTP(base: fakeBase, config: .background("bg"))
        sut.get(fakePath) { response in
            XCTAssertEqual(response.error?.localizedDescription, "Data request can't run in background session")
        }
    }
    
    func testDataRequestWithParamsAndBodyDataUsingPostMethod() {
        let request = sut.dataRequest(path: fakePath, method: .post, params: ["paramKey": "paramValue"], bodyData: Data())
        request.go { response in
            XCTAssertEqual(response.error?.localizedDescription, "Params and bodyData should not be used together in POST request")
        }
    }
    
    func testDateRequestWithParamsAndBodyDataUsingGetMethod() {
        let request = sut.dataRequest(path: fakePath, method: .get, params: ["paramKey": "paramValue"], bodyData: Data())
        
        let task = request.go { _ in }
        XCTAssertNotNil(task)
    }
    
}
