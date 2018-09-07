//
//  URLEncodingTests.swift
//  HTTPTests
//
//  Created by TTSY on 2018/9/7.
//  Copyright © 2018 TTSY. All rights reserved.
//

import XCTest
@testable import HTTP

class URLEncodingTests: XCTestCase {
    
    func testEncode() {
        let base = "http://www.fake.com"
        let path = "/fake/path"
        let params: [String: Any] = ["data": "2017-12-29"]
        
        let encodedURL = try? URLEncoding.encode(base: base, path: path, method: .get, params: params)
        XCTAssertEqual(encodedURL?.absoluteString, "http://www.fake.com/fake/path?data=2017-12-29&")
    }
    
    func testEncodeWithInvalidURL() {
        let fakeBase = ""
        let fakePath = ""
        let params: [String: Any] = ["data": "2017-12-29", "length": 12345678910]
        
        var encodedURL: URL? = nil
        do {
            encodedURL = try URLEncoding.encode(base: fakeBase, path: fakePath, method: .get, params: params)
        } catch URLEncodingError.invalidURL(let urlString) {
            XCTAssertEqual(fakePath + fakeBase, urlString)
        } catch URLEncodingError.invalidParams(let parameters) {
            XCTAssertEqual(params.count, parameters.count)
        } catch {
            fatalError()
        }
        
        XCTAssertNil(encodedURL)
    }
    
    func testEncodeWithSpaceCharacter() {
        let fakeBase = "https://www.fake.com"
        let fakePath = "/download/image name with space.jpg"
        
        let encodedURL = try? URLEncoding.encode(base: fakeBase, path: fakePath, method: .get, params: nil)
        
        let expectedURL = "https://www.fake.com/download/image%20name%20with%20space.jpg"
        
        XCTAssertEqual(encodedURL?.absoluteString, expectedURL)
    }
    
    func testEncodePathWithQueryString() {
        let base = "http://www.fake.com"
        let path = "/get?env=123"
        let encodedURL = try! URLEncoding.encode(base: base, path: path, method: .get, params: nil)
        
        XCTAssertEqual(encodedURL.absoluteString, "http://www.fake.com/get?env=123")
    }
    
    func testEncodePathWithQueryStringAndParams() {
        let base = "http://www.fake.com"
        let path = "/get?env=123"
        let params = ["email": "123@email.com"]
        let encodedURL = try! URLEncoding.encode(base: base, path: path, method: .get, params: params)
        
        XCTAssertEqual(encodedURL.absoluteString, "http://www.fake.com/get?env=123&email=123@email.com&")
    }
    
    func testEncodeBaseAndPathForDownloadLink() {
        let filePath = "http://www.tutorialspoint.com/swift/swift_tutorial.pdf"
        let encodedURL = try! URLEncoding.encode(base: "", path: filePath, method: .get, params: nil)
        
        XCTAssertEqual(encodedURL.absoluteString, filePath)
    }
    
}
