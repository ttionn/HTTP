//
//  HTTPErrorTests.swift
//  HTTPTests
//
//  Created by TTSY on 2018/9/7.
//  Copyright © 2018 TTSY. All rights reserved.
//

import XCTest
@testable import HTTP

class HTTPErrorTests: XCTestCase {
    
    var sut: HTTPError!
    
    func testRequestError() {
        sut = HTTPError.requestError(.paramsAndBodyDataUsedTogether("POST"))
        XCTAssertEqual(sut.localizedDescription, "Params and bodyData should not be used together in POST request")
        
        sut = HTTPError.requestError(.dataRequestInBackgroundSession)
        XCTAssertEqual(sut.localizedDescription, "Data request can't run in background session")
        
        sut = HTTPError.requestError(.emptyURLRequest)
        XCTAssertEqual(sut.localizedDescription, "URLRequest is nil")
    }
    
    func testEncodingError() {
        sut = HTTPError.encodingError(.invalidURL("~!@#$"))
        XCTAssertEqual(sut.localizedDescription, "Invalid url: ~!@#$")
        
        sut = HTTPError.encodingError(.invalidParams(["key": "value"]))
        XCTAssertEqual(sut.localizedDescription, "Invalid params: [\"key\": \"value\"]")
    }
    
    func testStatusCodeError() {
        sut = HTTPError.statusError(HTTPStatus(code: 400))
        XCTAssertEqual(sut.localizedDescription, "HTTP status code: \(400) - Bad Request")
        
        sut = HTTPError.statusError(HTTPStatus(code: 500))
        XCTAssertEqual(sut.localizedDescription, "HTTP status code: \(500) - Internal Server Error")
        
        sut = HTTPError.statusError(HTTPStatus(code: 999))
        XCTAssertEqual(sut.localizedDescription, "HTTP status code: 0 - Unknown")
        
        sut = HTTPError.statusError(HTTPStatus(code: 0))
        XCTAssertEqual(sut.localizedDescription, "HTTP status code: 0 - Unknown")
    }
    
    func testResponseError() {
        let error = NSError(domain: "response", code: 0)
        sut = HTTPError.responseError(error)
        XCTAssertEqual(sut.localizedDescription, "The operation couldn’t be completed. (response error 0.)")
    }
    
}
