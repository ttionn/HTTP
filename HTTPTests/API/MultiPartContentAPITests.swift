//
//  MultiPartContentAPITests.swift
//  HTTPTests
//
//  Created by TTSY on 2018/9/7.
//  Copyright © 2018 TTSY. All rights reserved.
//

import XCTest
import HTTP

class MultiPartContentAPITests: XCTestCase {
    
    var sut: MultiPartContent!
    
    func testInitWithData() {
        sut = MultiPartContent(name: "file", fileName: "swift.jpg", type: .jpg, data: Data())
        XCTAssertNotNil(sut)
    }
    
    func testInitWithURL() {
        let fileURL = URL(string: "/upload/swift.jpg")!
        sut = MultiPartContent(name: "file", type: .jpg, url: fileURL)
        XCTAssertNotNil(sut)
    }
    
}
