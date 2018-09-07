//
//  BinTests.swift
//  HTTPTests
//
//  Created by TTSY on 2018/9/7.
//  Copyright © 2018 TTSY. All rights reserved.
//

import XCTest
import HTTP

class BinTests: XCTestCase {
    
    var sut: HTTP!
    var async: XCTestExpectation!
    
    override func setUp() {
        super.setUp()
        
        sut = HTTP(base: "https://httpbin.org")
        async = expectation(description: "async")
    }
    
    func testGet() {
        sut.get("/get") { response in
            XCTAssertNil(response.error)
            XCTAssertNotNil(response.data)
            
            self.async.fulfill()
        }
        
        wait(for: [async], timeout: 10)
    }
    
    func testGetWithHeaders() {
        sut.get("/headers", headers: ["Content-Type": "text/html; charset=utf-8"]) { response in
            XCTAssertNil(response.error)
            XCTAssertNotNil(response.data)
            
            let headers = response.json!["headers"] as! [String: String]
            XCTAssertEqual(headers["Host"], "httpbin.org")
            XCTAssertEqual(headers["Content-Type"], "text/html; charset=utf-8")
            
            self.async.fulfill()
        }
        
        wait(for: [async], timeout: 10)
    }
    
    func testDataRequestWithHeaders() {
        sut.dataRequest(path: "/headers", headers: ["Content-Type": "text/html; charset=utf-8"]).go { response in
            XCTAssertNil(response.error)
            XCTAssertNotNil(response.data)
            
            let headers = response.json!["headers"] as! [String: String]
            XCTAssertEqual(headers["Host"], "httpbin.org")
            XCTAssertEqual(headers["Content-Type"], "text/html; charset=utf-8")
            
            self.async.fulfill()
        }
        
        wait(for: [async], timeout: 10)
    }
    
    func testPostWithParams() {
        sut.post("/post", params: ["foo": "bar"]) { response in
            let httpURLResponse = response.urlResponse as! HTTPURLResponse
            XCTAssertEqual(httpURLResponse.statusCode, 200)
            let json = response.json
            
            XCTAssertNotNil(json)
            self.async.fulfill()
        }
        
        wait(for: [async], timeout: 10)
    }
    
    func testGetWithQueryString() {
        sut.get("/get", params: ["env": "123"]) { response in
            XCTAssertNil(response.error)
            XCTAssertNotNil(response.data)
            
            let json = response.json!
            let args = json["args"] as! [String: String]
            XCTAssertEqual(args["env"], "123")
            
            self.async.fulfill()
        }
        
        wait(for: [async], timeout: 10)
    }
    
    func testGetWithQueryStringInURL() {
        sut.get("/get?env=123") { response in
            XCTAssertNil(response.error)
            XCTAssertNotNil(response.data)
            
            let json = response.json!
            let args = json["args"] as! [String: String]
            XCTAssertEqual(args["env"], "123")
            
            self.async.fulfill()
        }
        
        wait(for: [async], timeout: 10)
    }
    
    func testPost() {
        let params: [String : Any] = ["userId": 88, "id": 108, "title": "TTSY", "body": "Forever"]
        
        sut.post("/post", params: params) { response in
            XCTAssertNotNil(response.data)
            XCTAssertNil(response.error)
            
            guard let json = response.json else {
                return
            }
            print(json["json"] as! Dictionary<String, Any>)
            
            self.async.fulfill()
        }
        
        wait(for: [async], timeout: 10)
    }
    
    struct Article: Codable {
        let userId: Int
        let id: Int
        let title: String
        let body: String
    }
    
    func testPostWithBodyData() {
        let article = Article(userId: 88, id: 108, title: "TTSY", body: "Forever")
        let jsonData = try! JSONEncoder().encode(article)
        
        sut.post("/post", bodyData: jsonData) { response in
            XCTAssertNotNil(response.data)
            XCTAssertNil(response.error)
            
            guard let json = response.json else {
                XCTFail()
                return
            }
            
            guard let jsonDic = json["json"] as? [String: Any] else {
                XCTFail()
                return
            }
            
            XCTAssertEqual(jsonDic["userId"] as! Int, 88)
            XCTAssertEqual(jsonDic["id"] as! Int, 108)
            XCTAssertEqual(jsonDic["title"] as! String, "TTSY")
            XCTAssertEqual(jsonDic["body"] as! String, "Forever")
            
            self.async.fulfill()
        }
        
        wait(for: [async], timeout: 10)
    }
    
    func testDataRequestWithBodyData() {
        let article = Article(userId: 88, id: 108, title: "TTSY", body: "Forever")
        let jsonData = try! JSONEncoder().encode(article)
        
        sut.dataRequest(path: "/post", method: .post, bodyData: jsonData).go { response in
            XCTAssertNotNil(response.data)
            XCTAssertNil(response.error)
            
            guard let json = response.json else {
                XCTFail()
                return
            }
            
            guard let jsonDic = json["json"] as? [String: Any] else {
                XCTFail()
                return
            }
            
            XCTAssertEqual(jsonDic["userId"] as! Int, 88)
            XCTAssertEqual(jsonDic["id"] as! Int, 108)
            XCTAssertEqual(jsonDic["title"] as! String, "TTSY")
            XCTAssertEqual(jsonDic["body"] as! String, "Forever")
            
            self.async.fulfill()
        }
        
        wait(for: [async], timeout: 10)
    }
    
}
