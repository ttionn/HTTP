//
//  HTTPResponseAPITests.swift
//  HTTPTests
//
//  Created by TTSY on 2018/9/7.
//  Copyright © 2018 TTSY. All rights reserved.
//

import XCTest
import HTTP

class HTTPResponseAPITests: XCTestCase {
    
    var sut: HTTPResponse!
    
    func testInit() {
        sut = HTTPResponse()
        
        XCTAssertNil(sut.data)
        XCTAssertNil(sut.urlResponse)
        XCTAssertNil(sut.error)
        XCTAssertNil(sut.url)
        XCTAssertNil(sut.json)
        XCTAssertNil(sut.jsonArray)
        XCTAssertEqual(sut.status.description, "0 - Unknown")
    }
    
    func testInitWithData() {
        sut = HTTPResponse(data: "some".data(using: .utf8), response: URLResponse(), error: nil)
        
        XCTAssertEqual(sut.data, "some".data(using: .utf8))
        XCTAssertNotNil(sut.urlResponse)
        XCTAssertNil(sut.error)
    }
    
    func testInitWithURL() {
        let url = URL(string: "/download/path")
        sut = HTTPResponse(url: url, response: URLResponse(), error: nil)
        
        XCTAssertEqual(sut.url, url)
        XCTAssertNotNil(sut.urlResponse)
        XCTAssertNil(sut.error)
    }
    
}
