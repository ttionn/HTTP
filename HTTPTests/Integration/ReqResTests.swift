//
//  ReqResTests.swift
//  HTTPTests
//
//  Created by TTSY on 2018/9/7.
//  Copyright © 2018 TTSY. All rights reserved.
//

import XCTest
import HTTP

class ReqResTests: XCTestCase {
    
    var sut: HTTP!
    var async: XCTestExpectation!
    
    override func setUp() {
        super.setUp()
        
        sut = HTTP(base: "https://reqres.in")
        async = expectation(description: "async")
    }
    
    func testGetListUsers() {
        sut.get("/api/users", params: ["page": 2]) { response in
            XCTAssertNotNil(response)
            XCTAssertNil(response.error)
            
            let httpURLResponse = response.urlResponse as! HTTPURLResponse
            XCTAssertEqual(httpURLResponse.statusCode, 200)
            
            self.async.fulfill()
        }
        
        wait(for: [async], timeout: 10)
    }
    
    func testPostCreate() {
        sut.post("/api/users", params: ["name": "morpheus", "job": "leader"]) { response in
            XCTAssertNotNil(response)
            XCTAssertNil(response.error)
            
            let httpURLResponse = response.urlResponse as! HTTPURLResponse
            XCTAssertEqual(httpURLResponse.statusCode, 201)
            
            let jsonDic = response.json!
            XCTAssertEqual(jsonDic["name"] as! String, "morpheus")
            XCTAssertEqual(jsonDic["job"] as! String, "leader")
            
            self.async.fulfill()
        }
        
        wait(for: [async], timeout: 10)
    }
    
    func testPutUpdate() {
        sut.put("/api/users", params: ["name": "morpheus", "job": "zion resident"]) { response in
            XCTAssertNotNil(response)
            XCTAssertNil(response.error)
            
            let httpURLResponse = response.urlResponse as! HTTPURLResponse
            XCTAssertEqual(httpURLResponse.statusCode, 200)
            
            let jsonDic = response.json!
            XCTAssertEqual(jsonDic["name"] as! String, "morpheus")
            XCTAssertEqual(jsonDic["job"] as! String, "zion resident")
            
            self.async.fulfill()
        }
        
        wait(for: [async], timeout: 10)
    }
    
    func testDelete() {
        sut.delete("/api/users/2") { response in
            XCTAssertNotNil(response)
            XCTAssertNil(response.error)
            
            let httpURLResponse = response.urlResponse as! HTTPURLResponse
            XCTAssertEqual(httpURLResponse.statusCode, 204)
            
            self.async.fulfill()
        }
        
        wait(for: [async], timeout: 10)
    }
    
    func testLoginSuccessful() {
        sut.post("/api/login", params: ["email": "peter@klaven", "password": "cityslicka"]) { response in
            let httpURLResponse = response.urlResponse as! HTTPURLResponse
            XCTAssertEqual(httpURLResponse.statusCode, 200)
            
            self.async.fulfill()
            
            let jsonDic = response.json!
            let token = jsonDic["token"] as! String
            XCTAssertEqual(token, "QpwL5tke4Pnpja7X")
        }
        
        wait(for: [async], timeout: 10)
    }
    
}
