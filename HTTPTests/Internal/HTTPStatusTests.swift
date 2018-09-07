//
//  HTTPStatusTests.swift
//  HTTPTests
//
//  Created by TTSY on 2018/9/7.
//  Copyright © 2018 TTSY. All rights reserved.
//

import XCTest
@testable import HTTP

class HTTPStatusTests: XCTestCase {
    
    var sut: HTTPStatus!
    
    func testInit() {
        sut = HTTPStatus(code: 100)
        XCTAssertEqual(sut, .continue)
        XCTAssertEqual(sut.description, "100 - Continue")
        
        sut = HTTPStatus(code: 101)
        XCTAssertEqual(sut, .switchingProtocols)
        XCTAssertEqual(sut.description, "101 - Switching Protocols")
        
        sut = HTTPStatus(code: 200)
        XCTAssertEqual(sut, .ok)
        XCTAssertEqual(sut.description, "200 - OK")
        
        sut = HTTPStatus(code: 201)
        XCTAssertEqual(sut, .created)
        XCTAssertEqual(sut.description, "201 - Created")
        
        sut = HTTPStatus(code: 202)
        XCTAssertEqual(sut, .accepted)
        XCTAssertEqual(sut.description, "202 - Accepted")
        
        sut = HTTPStatus(code: 203)
        XCTAssertEqual(sut, .nonAuthoritativeInformation)
        XCTAssertEqual(sut.description, "203 - Non-Authoritative Information")
        
        sut = HTTPStatus(code: 204)
        XCTAssertEqual(sut, .noContent)
        XCTAssertEqual(sut.description, "204 - No Content")
        
        sut = HTTPStatus(code: 205)
        XCTAssertEqual(sut, .resetContent)
        XCTAssertEqual(sut.description, "205 - Reset Content")
        
        sut = HTTPStatus(code: 206)
        XCTAssertEqual(sut, .partialContent)
        XCTAssertEqual(sut.description, "206 - Partial Content")
        
        sut = HTTPStatus(code: 300)
        XCTAssertEqual(sut, .multipleChoices)
        XCTAssertEqual(sut.description, "300 - Multiple Choices")
        
        sut = HTTPStatus(code: 301)
        XCTAssertEqual(sut, .movedPermanently)
        XCTAssertEqual(sut.description, "301 - Moved Permanently")
        
        sut = HTTPStatus(code: 302)
        XCTAssertEqual(sut, .found)
        XCTAssertEqual(sut.description, "302 - Found")
        
        sut = HTTPStatus(code: 303)
        XCTAssertEqual(sut, .seeOther)
        XCTAssertEqual(sut.description, "303 - See Other")
        
        sut = HTTPStatus(code: 304)
        XCTAssertEqual(sut, .notModified)
        XCTAssertEqual(sut.description, "304 - Not Modified")
        
        sut = HTTPStatus(code: 305)
        XCTAssertEqual(sut, .useProxy)
        XCTAssertEqual(sut.description, "305 - Use Proxy")
        
        sut = HTTPStatus(code: 307)
        XCTAssertEqual(sut, .temporaryRedirect)
        XCTAssertEqual(sut.description, "307 - Temporary Redirect")
        
        sut = HTTPStatus(code: 400)
        XCTAssertEqual(sut, .badRequest)
        XCTAssertEqual(sut.description, "400 - Bad Request")
        
        sut = HTTPStatus(code: 401)
        XCTAssertEqual(sut, .unauthorized)
        XCTAssertEqual(sut.description, "401 - Unauthorized")
        
        sut = HTTPStatus(code: 402)
        XCTAssertEqual(sut, .paymentRequired)
        XCTAssertEqual(sut.description, "402 - Payment Required")
        
        sut = HTTPStatus(code: 403)
        XCTAssertEqual(sut, .forbidden)
        XCTAssertEqual(sut.description, "403 - Forbidden")
        
        sut = HTTPStatus(code: 404)
        XCTAssertEqual(sut, .notFound)
        XCTAssertEqual(sut.description, "404 - Not Found")
        
        sut = HTTPStatus(code: 405)
        XCTAssertEqual(sut, .methodNotAllowed)
        XCTAssertEqual(sut.description, "405 - Method Not Allowed")
        
        sut = HTTPStatus(code: 406)
        XCTAssertEqual(sut, .notAcceptable)
        XCTAssertEqual(sut.description, "406 - Not Acceptable")
        
        sut = HTTPStatus(code: 407)
        XCTAssertEqual(sut, .proxyAuthenticationRequired)
        XCTAssertEqual(sut.description, "407 - Proxy Authentication Required")
        
        sut = HTTPStatus(code: 408)
        XCTAssertEqual(sut, .requestTimeout)
        XCTAssertEqual(sut.description, "408 - Request Timeout")
        
        sut = HTTPStatus(code: 409)
        XCTAssertEqual(sut, .conflict)
        XCTAssertEqual(sut.description, "409 - Conflict")
        
        sut = HTTPStatus(code: 410)
        XCTAssertEqual(sut, .gone)
        XCTAssertEqual(sut.description, "410 - Gone")
        
        sut = HTTPStatus(code: 411)
        XCTAssertEqual(sut, .lengthRequired)
        XCTAssertEqual(sut.description, "411 - Length Required")
        
        sut = HTTPStatus(code: 412)
        XCTAssertEqual(sut, .preconditionFailed)
        XCTAssertEqual(sut.description, "412 - Precondition Failed")
        
        sut = HTTPStatus(code: 413)
        XCTAssertEqual(sut, .requestEntityTooLarge)
        XCTAssertEqual(sut.description, "413 - Request Entity Too Large")
        
        sut = HTTPStatus(code: 414)
        XCTAssertEqual(sut, .requestUrlTooLong)
        XCTAssertEqual(sut.description, "414 - Request-URL Too Long")
        
        sut = HTTPStatus(code: 415)
        XCTAssertEqual(sut, .unsupportedMediaType)
        XCTAssertEqual(sut.description, "415 - Unsupported Media Type")
        
        sut = HTTPStatus(code: 416)
        XCTAssertEqual(sut, .requestedRangeNotSatisfiable)
        XCTAssertEqual(sut.description, "416 - Requested Range Not Satisfiable")
        
        sut = HTTPStatus(code: 417)
        XCTAssertEqual(sut, .expectationFailed)
        XCTAssertEqual(sut.description, "417 - Expectation Failed")
        
        sut = HTTPStatus(code: 500)
        XCTAssertEqual(sut, .internalServerError)
        XCTAssertEqual(sut.description, "500 - Internal Server Error")
        
        sut = HTTPStatus(code: 501)
        XCTAssertEqual(sut, .notImplemented)
        XCTAssertEqual(sut.description, "501 - Not Implemented")
        
        sut = HTTPStatus(code: 502)
        XCTAssertEqual(sut, .badGateway)
        XCTAssertEqual(sut.description, "502 - Bad Gateway")
        
        sut = HTTPStatus(code: 503)
        XCTAssertEqual(sut, .serviceUnavailable)
        XCTAssertEqual(sut.description, "503 - Service Unavailable")
        
        sut = HTTPStatus(code: 504)
        XCTAssertEqual(sut, .gatewayTimeout)
        XCTAssertEqual(sut.description, "504 - Gateway Timeout")
        
        sut = HTTPStatus(code: 505)
        XCTAssertEqual(sut, .httpVersionNotSupported)
        XCTAssertEqual(sut.description, "505 - HTTP Version Not Supported")
        
        sut = HTTPStatus(code: 999)
        XCTAssertEqual(sut, .unknown)
        XCTAssertEqual(sut.description, "0 - Unknown")
    }
    
    func testIsSuccessful() {
        sut = HTTPStatus(code: 199)
        XCTAssertFalse(sut.isSuccessful)
        
        sut = HTTPStatus(code: 200)
        XCTAssert(sut.isSuccessful)
        
        sut = HTTPStatus(code: 299)
        XCTAssertFalse(sut.isSuccessful)
        
        sut = HTTPStatus(code: 300)
        XCTAssertFalse(sut.isSuccessful)
        
        sut = HTTPStatus(code: 400)
        XCTAssertFalse(sut.isSuccessful)
        
        sut = HTTPStatus(code: 500)
        XCTAssertFalse(sut.isSuccessful)
    }
    
}
